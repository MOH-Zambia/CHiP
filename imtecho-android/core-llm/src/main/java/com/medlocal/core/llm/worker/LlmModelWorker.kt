package com.medlocal.core.llm.worker

import android.annotation.SuppressLint
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.net.Uri
import android.os.IBinder
import android.util.Log
import com.medlocal.core.llm.model.GenerationEvent
import com.medlocal.core.llm.model.Model
import com.medlocal.core.llm.model.ModelConfig
import com.medlocal.core.llm.service.IGgufGenerationCallback
import com.medlocal.core.llm.service.ILLMService
import com.medlocal.core.llm.service.IModelLoadCallback
import com.medlocal.core.llm.service.LLMService
import com.mp.ai_gguf.models.DecodingMetrics
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.buffer
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withTimeout
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

/**
 * Singleton manager for LLM operations.
 * Handles service binding and provides a clean API for model loading and generation.
 */
@SuppressLint("StaticFieldLeak")
object LlmModelWorker {

    private const val TAG = "LlmModelWorker"

    private var service: ILLMService? = null
    private var boundContext: Context? = null
    private val serviceBound = CompletableDeferred<Unit>()
    private var isBinding = false

    // Model state
    private val _isModelLoaded = MutableStateFlow(false)
    val isModelLoaded: StateFlow<Boolean> = _isModelLoaded.asStateFlow()

    private val _currentModelId = MutableStateFlow<String?>(null)
    val currentModelId: StateFlow<String?> = _currentModelId.asStateFlow()

    private val connection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, binder: IBinder?) {
            service = ILLMService.Stub.asInterface(binder)
            isBinding = false
            serviceBound.complete(Unit)
            Log.i(TAG, "Service connected")
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            service = null
            isBinding = false
            Log.w(TAG, "Service disconnected unexpectedly")
        }

        override fun onBindingDied(name: ComponentName?) {
            service = null
            isBinding = false
            Log.e(TAG, "Service binding died")
        }

        override fun onNullBinding(name: ComponentName?) {
            isBinding = false
            Log.e(TAG, "Service returned null binding")
        }
    }

    /**
     * Bind to the LLM service. Should be called during app initialization.
     */
    fun bindService(context: Context) {
        if (boundContext != null && service != null) {
            Log.w(TAG, "Service already bound and connected")
            return
        }

        if (isBinding) {
            Log.w(TAG, "Service binding already in progress")
            return
        }

        isBinding = true
        val appContext = context.applicationContext
        val intent = Intent(appContext, LLMService::class.java)

        val bound = appContext.bindService(
            intent,
            connection,
            Context.BIND_AUTO_CREATE or Context.BIND_IMPORTANT
        )

        if (bound) {
            boundContext = appContext
            Log.i(TAG, "Service binding initiated")
        } else {
            isBinding = false
            Log.e(TAG, "Failed to bind service")
        }
    }

    /**
     * Unbind from the LLM service. Should be called during app cleanup.
     */
    fun unbindService() {
        try {
            boundContext?.unbindService(connection)
            Log.i(TAG, "Service unbound")
        } catch (e: Exception) {
            Log.e(TAG, "Error unbinding service", e)
        } finally {
            service = null
            boundContext = null
            isBinding = false
            _isModelLoaded.value = false
            _currentModelId.value = null
        }
    }

    private suspend fun ensureServiceBound(): ILLMService {
        // Increased timeout for slow devices
        return withTimeout(10000) {
            serviceBound.await()
            service ?: throw IllegalStateException("Service not available")
        }
    }

    // ==================== Model Loading ====================

    /**
     * Load a GGUF model from file path
     */
    suspend fun loadModel(model: Model, modelConfig: ModelConfig): Boolean {
        val svc = ensureServiceBound()

        return suspendCancellableCoroutine { continuation ->
            val callback = object : IModelLoadCallback.Stub() {
                override fun onSuccess() {
                    _isModelLoaded.value = true
                    _currentModelId.value = model.id
                    Log.i(TAG, "Model loaded successfully: ${model.modelName}")
                    continuation.resume(true)
                }

                override fun onError(message: String) {
                    _isModelLoaded.value = false
                    Log.e(TAG, "Failed to load model: $message")
                    continuation.resume(false)
                }
            }

            try {
                svc.loadGgufModel(
                    model.modelPath,
                    model.modelName,
                    modelConfig.modelLoadingParams ?: "",
                    modelConfig.modelInferenceParams ?: "",
                    callback
                )
            } catch (e: Exception) {
                Log.e(TAG, "Exception loading model", e)
                continuation.resumeWithException(e)
            }
        }
    }

    /**
     * Load GGUF model from a content:// URI using file descriptor.
     * This is used for SAF (Storage Access Framework) URIs.
     */
    suspend fun loadModelFromUri(
        context: Context,
        uri: Uri,
        modelName: String,
        modelConfig: ModelConfig
    ): Boolean {
        val svc = ensureServiceBound()

        // Open ParcelFileDescriptor from content URI
        val pfd = context.contentResolver.openFileDescriptor(uri, "r")
            ?: throw IllegalArgumentException("Cannot open file descriptor for URI: $uri")

        return suspendCancellableCoroutine { continuation ->
            val callback = object : IModelLoadCallback.Stub() {
                override fun onSuccess() {
                    _isModelLoaded.value = true
                    _currentModelId.value = modelName
                    Log.i(TAG, "Model loaded successfully from URI")
                    continuation.resume(true)
                }

                override fun onError(message: String) {
                    _isModelLoaded.value = false
                    Log.e(TAG, "Failed to load model from URI: $message")
                    continuation.resume(false)
                }
            }

            try {
                svc.loadGgufModelFromFd(
                    pfd,
                    modelName,
                    modelConfig.modelLoadingParams ?: "",
                    modelConfig.modelInferenceParams ?: "",
                    callback
                )
            } catch (e: Exception) {
                Log.e(TAG, "Exception loading model from URI", e)
                pfd.close()
                continuation.resumeWithException(e)
            }
        }
    }

    // ==================== Text Generation ====================

    /**
     * Generate text as a streaming Flow
     */
    fun generateStreaming(prompt: String, maxTokens: Int): Flow<GenerationEvent> = callbackFlow {
        serviceBound.await()

        val svc = service
        if (svc == null) {
            trySend(GenerationEvent.Error("Service not bound"))
            close()
            return@callbackFlow
        }

        val callback = object : IGgufGenerationCallback.Stub() {
            override fun onToken(token: String) {
                trySend(GenerationEvent.Token(token))
            }

            override fun onToolCall(name: String, args: String) {
                trySend(GenerationEvent.ToolCall(name, args))
            }

            override fun onMetrics(
                totalTokens: Int,
                promptTokens: Int,
                generatedTokens: Int,
                tokensPerSecond: Float,
                timeToFirstToken: Long,
                totalTimeMs: Long
            ) {
                trySend(
                    GenerationEvent.Metrics(
                        DecodingMetrics(
                            totalTokens,
                            promptTokens,
                            generatedTokens,
                            tokensPerSecond,
                            timeToFirstToken,
                            totalTimeMs
                        )
                    )
                )
            }

            override fun onDone() {
                trySend(GenerationEvent.Done)
                close()
            }

            override fun onError(message: String) {
                trySend(GenerationEvent.Error(message))
                close()
            }
        }

        try {
            svc.generateGguf(prompt, maxTokens, callback)
        } catch (e: Exception) {
            trySend(GenerationEvent.Error(e.message ?: "Failed to start generation"))
            close()
        }

        awaitClose {
            // Optional: stop generation if flow is cancelled
        }
    }.buffer(Channel.UNLIMITED)
        .flowOn(Dispatchers.IO)

    /**
     * Stop the current generation
     */
    fun stopGeneration() {
        service?.stopGenerationGguf()
        Log.i(TAG, "Generation stopped")
    }

    // ==================== Model Management ====================

    /**
     * Unload the current model
     */
    fun unloadModel() {
        service?.unloadModelGguf()
        _isModelLoaded.value = false
        _currentModelId.value = null
        Log.i(TAG, "Model unloaded")
    }

    /**
     * Get information about the currently loaded model
     */
    fun getModelInfo(): String? {
        return service?.modelInfoGguf
    }

    // ==================== Tool Calling ====================

    /**
     * Set tools for function calling
     * @param toolsJson JSON string containing tool definitions in OpenAI format
     * @return true if tools were set successfully
     */
    fun setTools(toolsJson: String): Boolean {
        return try {
            service?.setToolsJsonGguf(toolsJson) ?: false
        } catch (e: Exception) {
            Log.e(TAG, "Failed to set tools: ${e.message}")
            false
        }
    }

    /**
     * Clear all registered tools
     */
    fun clearTools() {
        try {
            service?.clearToolsGguf()
            Log.i(TAG, "Tools cleared")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to clear tools: ${e.message}")
        }
    }
}
