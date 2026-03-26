package com.medlocal.core.llm.engine

import android.app.ActivityManager
import android.content.Context
import com.medlocal.core.llm.model.DeviceTier
import com.medlocal.core.llm.model.GenerationEvent
import com.medlocal.core.llm.model.GgufEngineSchema
import com.medlocal.core.llm.model.GgufLoadingParams
import com.medlocal.core.llm.model.Model
import com.medlocal.core.llm.model.ModelConfig
import com.mp.ai_gguf.GGUFNativeLib
import com.mp.ai_gguf.models.StreamCallback
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.buffer
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.withContext

/**
 * Engine wrapper for GGUF models using the native library.
 * Handles model loading, generation, and lifecycle management.
 */
class GGUFEngine {
    private val nativeLib = GGUFNativeLib()
    private var isLoaded = false
    private var currentModelId: String? = null
    private var currentToolsJson: String? = null  // Cache for grammar optimization

    /**
     * Load a model from file path
     */
    suspend fun load(model: Model, config: ModelConfig?): Boolean = withContext(Dispatchers.IO) {
        if (isLoaded) unload()

        val schema = GgufEngineSchema.fromJson(
            config?.modelLoadingParams,
            config?.modelInferenceParams
        )

        val loading = schema.loadingParams
        val inference = schema.inferenceParams

        val success = nativeLib.nativeLoadModel(
            path = model.modelPath,
            threads = loading.threads,
            ctxSize = loading.ctxSize,
            temp = inference.temperature,
            topK = inference.topK,
            topP = inference.topP,
            minP = inference.minP,
            mirostat = inference.mirostat,
            mirostatTau = inference.mirostatTau,
            mirostatEta = inference.mirostatEta,
            seed = inference.seed
        )

        if (success) {
            isLoaded = true
            currentModelId = model.id

            if (inference.systemPrompt.isNotEmpty()) {
                nativeLib.nativeSetSystemPrompt(inference.systemPrompt)
            }
            if (inference.chatTemplate.isNotEmpty()) {
                nativeLib.nativeSetChatTemplate(inference.chatTemplate)
            }
        }

        success
    }

    /**
     * Load model from file descriptor (for SAF/content:// URIs)
     * This allows loading models without MANAGE_EXTERNAL_STORAGE permission
     *
     * @param fd File descriptor from contentResolver.openFileDescriptor(uri, "r").detachFd()
     * @param config Optional model configuration
     * @return true if model loaded successfully
     */
    suspend fun loadFromFd(fd: Int, config: ModelConfig? = null): Boolean = withContext(Dispatchers.IO) {
        if (isLoaded) unload()

        val schema = GgufEngineSchema.fromJson(
            config?.modelLoadingParams,
            config?.modelInferenceParams
        )

        val loading = schema.loadingParams
        val inference = schema.inferenceParams

        val success = nativeLib.nativeLoadModelFromFd(
            fd = fd,
            threads = loading.threads,
            ctxSize = loading.ctxSize,
            temp = inference.temperature,
            topK = inference.topK,
            topP = inference.topP,
            minP = inference.minP,
            mirostat = inference.mirostat,
            mirostatTau = inference.mirostatTau,
            mirostatEta = inference.mirostatEta,
            seed = inference.seed
        )

        if (success) {
            isLoaded = true
            currentModelId = "fd_$fd"

            if (inference.systemPrompt.isNotEmpty()) {
                nativeLib.nativeSetSystemPrompt(inference.systemPrompt)
            }
            if (inference.chatTemplate.isNotEmpty()) {
                nativeLib.nativeSetChatTemplate(inference.chatTemplate)
            }
        }

        success
    }

    /**
     * Generate tokens as a Flow using callbackFlow
     *
     * This properly handles the callback-to-flow conversion without
     * violating Flow invariants. The native callback runs on whatever
     * thread llama.cpp uses, and we safely send events to the channel.
     *
     * The flow is consumed on IO dispatcher and buffered for smooth streaming.
     */
    fun generateFlow(prompt: String, maxTokens: Int): Flow<GenerationEvent> = callbackFlow {
        if (!isLoaded) {
            trySend(GenerationEvent.Error("Model not loaded"))
            close()
            return@callbackFlow
        }

        val callback = object : StreamCallback {
            override fun onToken(token: String) {
                // trySend is thread-safe and non-blocking
                trySend(GenerationEvent.Token(token))
            }

            override fun onToolCall(name: String, argsJson: String) {
                trySend(GenerationEvent.ToolCall(name, argsJson))
            }

            override fun onDone() {
                trySend(GenerationEvent.Done)
                close() // Close the channel when done
            }

            override fun onError(message: String) {
                trySend(GenerationEvent.Error(message))
                close()
            }

            override fun onMetrics(metrics: com.mp.ai_gguf.models.DecodingMetrics) {
                trySend(GenerationEvent.Metrics(metrics))
            }
        }

        // Run the native generation on IO thread
        // This call blocks until generation completes
        try {
            nativeLib.nativeGenerateStream(prompt, maxTokens, callback)
        } catch (e: Exception) {
            trySend(GenerationEvent.Error(e.message ?: "Generation failed"))
            close()
        }

        // Keep the flow alive until the channel is closed
        awaitClose {
            // Cleanup if the collector cancels
            // This will be called if the flow is cancelled
        }
    }
        .buffer(Channel.UNLIMITED) // Buffer to prevent backpressure blocking native code
        .flowOn(Dispatchers.IO)    // Ensure collection happens on IO dispatcher

    /**
     * Stop the current generation
     */
    fun stopGeneration() {
        nativeLib.nativeStopGeneration()
    }

    /**
     * Unload the current model and free resources
     */
    suspend fun unload() = withContext(Dispatchers.IO) {
        if (isLoaded) {
            nativeLib.nativeRelease()
            isLoaded = false
            currentModelId = null
            currentToolsJson = null  // Clear tools cache
        }
    }

    /**
     * Check if a specific model is currently loaded
     */
    fun isModelLoaded(modelId: String): Boolean =
        isLoaded && currentModelId == modelId

    /**
     * Get information about the currently loaded model
     */
    fun getModelInfo(): String? =
        if (isLoaded) nativeLib.nativeGetModelInfo() else null

    /**
     * Set tools JSON for function calling support.
     * Uses grammar caching - only rebuilds grammar when tools JSON changes.
     *
     * @param toolsJson JSON array of tool definitions, or empty string to disable
     * @return true if tools were set successfully
     */
    fun setToolsJson(toolsJson: String): Boolean {
        if (!isLoaded) return false

        // Grammar caching: skip if tools haven't changed
        if (toolsJson == currentToolsJson) return true

        return try {
            nativeLib.nativeSetToolsJson(toolsJson)
            currentToolsJson = toolsJson
            true
        } catch (e: Exception) {
            false
        }
    }

    /**
     * Clear tools configuration and disable function calling
     */
    fun clearTools() {
        if (isLoaded) {
            try {
                nativeLib.nativeSetToolsJson("")
                currentToolsJson = null
            } catch (_: Exception) {
                // Ignore errors when clearing
            }
        }
    }

    /**
     * Check if tools/function calling is currently enabled
     */
    fun hasToolsEnabled(): Boolean = !currentToolsJson.isNullOrEmpty()

    companion object {
        /**
         * Detect device tier based on available RAM
         */
        fun detectDeviceTier(context: Context): DeviceTier {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memInfo = ActivityManager.MemoryInfo()
            activityManager.getMemoryInfo(memInfo)

            val totalRamGB = memInfo.totalMem / (1024.0 * 1024.0 * 1024.0)

            return when {
                totalRamGB < 4.0 -> DeviceTier.LOW_END
                totalRamGB < 8.0 -> DeviceTier.MID_RANGE
                else -> DeviceTier.HIGH_END
            }
        }

        /**
         * Get recommended loading params for the current device
         */
        fun getRecommendedParams(context: Context): GgufLoadingParams {
            val tier = detectDeviceTier(context)
            return GgufLoadingParams.forDeviceTier(tier)
        }

        /**
         * Calculate recommended context size based on available memory and model size
         */
        fun getRecommendedContextSize(context: Context, modelSizeMB: Int): Int {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memInfo = ActivityManager.MemoryInfo()
            activityManager.getMemoryInfo(memInfo)

            val availableMemoryMB = (memInfo.availMem / (1024 * 1024)).toInt()
            return GgufLoadingParams.recommendedContextSize(availableMemoryMB, modelSizeMB)
        }
    }
}
