package com.medlocal.core.llm.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.os.ParcelFileDescriptor
import android.os.Process
import android.util.Log
import androidx.core.app.NotificationCompat
import com.medlocal.core.llm.R
import com.medlocal.core.llm.engine.GGUFEngine
import com.medlocal.core.llm.model.GenerationEvent
import com.medlocal.core.llm.model.Model
import com.medlocal.core.llm.model.ModelConfig
import com.medlocal.core.llm.model.PathType
import com.medlocal.core.llm.model.ProviderType
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

/**
 * Foreground service for LLM operations.
 * Runs in a separate process (:llm_process) to isolate memory usage.
 */
class LLMService : Service() {

    companion object {
        private const val TAG = "LLMService"
        private const val NOTIFICATION_CHANNEL_ID = "llm_service"
        private const val NOTIFICATION_ID = 1
    }

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private val ggufEngine = GGUFEngine()

    private val binder = object : ILLMService.Stub() {

        override fun loadGgufModel(
            modelPath: String,
            modelName: String,
            loadingParams: String,
            inferenceParams: String,
            callback: IModelLoadCallback
        ) {
            scope.launch(Dispatchers.IO) {
                try {
                    val model = Model(
                        id = modelName,
                        modelPath = modelPath,
                        modelName = modelName,
                        pathType = PathType.FILE,
                        providerType = ProviderType.GGUF,
                        fileSize = null
                    )
                    val config = ModelConfig(
                        modelId = modelName,
                        modelLoadingParams = loadingParams,
                        modelInferenceParams = inferenceParams
                    )

                    val success = ggufEngine.load(model, config)

                    if (success) {
                        Log.i(TAG, "Model loaded successfully: $modelName")
                        callback.onSuccess()
                    } else {
                        Log.e(TAG, "Failed to load model: $modelName")
                        callback.onError("Failed to load model")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Exception loading model", e)
                    callback.onError(e.message ?: "Unknown error")
                }
            }
        }

        override fun loadGgufModelFromFd(
            pfd: ParcelFileDescriptor,
            modelName: String,
            loadingParams: String,
            inferenceParams: String,
            callback: IModelLoadCallback
        ) {
            scope.launch(Dispatchers.IO) {
                try {
                    // Get the native FD and detach it so GGUFEngine can own it
                    val fd = pfd.detachFd()

                    val config = ModelConfig(
                        modelId = modelName,
                        modelLoadingParams = loadingParams,
                        modelInferenceParams = inferenceParams
                    )

                    val success = ggufEngine.loadFromFd(fd, config)

                    if (success) {
                        Log.i(TAG, "Model loaded from FD successfully: $modelName")
                        callback.onSuccess()
                    } else {
                        Log.e(TAG, "Failed to load model from FD: $modelName")
                        callback.onError("Failed to load model from file descriptor")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Exception loading model from FD", e)
                    callback.onError(e.message ?: "Unknown error")
                }
            }
        }

        override fun generateGguf(
            prompt: String, maxTokens: Int, callback: IGgufGenerationCallback
        ) {
            scope.launch(Dispatchers.IO) {
                try {
                    ggufEngine.generateFlow(prompt, maxTokens).collect { event ->
                        when (event) {
                            is GenerationEvent.Token -> {
                                callback.onToken(event.text)
                            }

                            is GenerationEvent.Done -> {
                                callback.onDone()
                            }

                            is GenerationEvent.Error -> {
                                callback.onError(event.message)
                            }

                            is GenerationEvent.Metrics -> {
                                callback.onMetrics(
                                    event.metrics.totalTokens,
                                    event.metrics.promptTokens,
                                    event.metrics.generatedTokens,
                                    event.metrics.tokensPerSecond,
                                    event.metrics.timeToFirstToken,
                                    event.metrics.totalTimeMs
                                )
                            }

                            is GenerationEvent.ToolCall -> {
                                callback.onToolCall(event.name, event.args)
                            }
                        }
                    }
                } catch (e: Exception) {
                    try {
                        callback.onError(e.message ?: "Unknown error")
                    } catch (_: Exception) {
                        // Client may have disconnected
                    }
                }
            }
        }

        override fun stopGenerationGguf() {
            ggufEngine.stopGeneration()
        }

        override fun unloadModelGguf() {
            scope.launch(Dispatchers.IO) {
                ggufEngine.unload()
                Log.i(TAG, "Model unloaded")
            }
        }

        override fun getModelInfoGguf(): String? = ggufEngine.getModelInfo()

        override fun setToolsJsonGguf(toolsJson: String): Boolean {
            return ggufEngine.setToolsJson(toolsJson)
        }

        override fun clearToolsGguf() {
            ggufEngine.clearTools()
        }
    }

    override fun onBind(intent: Intent?): IBinder = binder

    override fun onCreate() {
        super.onCreate()
        startForeground(NOTIFICATION_ID, createNotification())
        Log.i(TAG, "LLMService created")
    }

    override fun onDestroy() {
        scope.launch {
            ggufEngine.unload()
        }
        scope.cancel()
        super.onDestroy()
        Log.i(TAG, "LLMService destroyed")
    }

    private fun createNotification(): Notification {
        val manager = getSystemService(NotificationManager::class.java)
        val channel = NotificationChannel(
            NOTIFICATION_CHANNEL_ID, 
            "LLM Service", 
            NotificationManager.IMPORTANCE_LOW
        )
        manager.createNotificationChannel(channel)

        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("AI Model Service")
            .setContentText("Running...")
            .setSmallIcon(android.R.drawable.ic_menu_info_details)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .setSilent(true)
            .build()
    }
}
