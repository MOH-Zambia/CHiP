package com.medlocal.core.llm.model

import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

/**
 * Parameters for loading a GGUF model
 */
@Serializable
data class GgufLoadingParams(
    val threads: Int = 0,  // 0 = auto-detect
    val ctxSize: Int = 2048,
    val batchSize: Int = 512,
    val useMmap: Boolean = true,
    val useMlock: Boolean = false
) {
    companion object {
        fun forDeviceTier(tier: DeviceTier): GgufLoadingParams = when (tier) {
            DeviceTier.LOW_END -> GgufLoadingParams(
                threads = 0,
                ctxSize = 1024,
                batchSize = 256,
                useMmap = true,
                useMlock = false
            )
            DeviceTier.MID_RANGE -> GgufLoadingParams(
                threads = 0,
                ctxSize = 2048,
                batchSize = 512,
                useMmap = true,
                useMlock = false
            )
            DeviceTier.HIGH_END -> GgufLoadingParams(
                threads = 0,
                ctxSize = 4096,
                batchSize = 512,
                useMmap = true,
                useMlock = false
            )
        }

        fun recommendedContextSize(availableMemoryMB: Int, modelSizeMB: Int): Int {
            val freeAfterModel = availableMemoryMB - modelSizeMB
            return when {
                freeAfterModel < 1024 -> 512
                freeAfterModel < 2048 -> 1024
                freeAfterModel < 4096 -> 2048
                else -> 4096
            }
        }
    }
}

/**
 * Parameters for inference with a GGUF model
 */
@Serializable
data class GgufInferenceParams(
    val temperature: Float = 0.7f,
    val topK: Int = 40,
    val topP: Float = 0.9f,
    val minP: Float = 0.05f,
    val mirostat: Int = 0,
    val mirostatTau: Float = 5.0f,
    val mirostatEta: Float = 0.1f,
    val seed: Int = -1,
    val maxTokens: Int = 512,
    val systemPrompt: String = "",
    val chatTemplate: String = "",
    val toolsJson: String = ""  // JSON array of tool definitions
)

/**
 * Combined schema for GGUF engine loading and inference parameters
 */
@Serializable
data class GgufEngineSchema(
    val loadingParams: GgufLoadingParams = GgufLoadingParams(),
    val inferenceParams: GgufInferenceParams = GgufInferenceParams()
) {
    fun toLoadingJson(): String = Companion.json.encodeToString(loadingParams)

    fun toInferenceJson(): String = Companion.json.encodeToString(inferenceParams)

    companion object {
        private val json = Json {
            ignoreUnknownKeys = true
            encodeDefaults = true
        }

        fun fromJson(loadingJson: String?, inferenceJson: String?): GgufEngineSchema {
            val loading = loadingJson?.takeIf { it.isNotBlank() }?.let {
                try {
                    json.decodeFromString<GgufLoadingParams>(it)
                } catch (e: Exception) {
                    GgufLoadingParams()
                }
            } ?: GgufLoadingParams()

            val inference = inferenceJson?.takeIf { it.isNotBlank() }?.let {
                try {
                    json.decodeFromString<GgufInferenceParams>(it)
                } catch (e: Exception) {
                    GgufInferenceParams()
                }
            } ?: GgufInferenceParams()

            return GgufEngineSchema(loading, inference)
        }
    }
}
