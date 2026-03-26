package com.medlocal.core.llm.model

import java.util.UUID

/**
 * Configuration for a model including loading and inference parameters.
 * This is a plain data class without Room annotations.
 */
data class ModelConfig(
    val id: String = UUID.randomUUID().toString(),
    val modelId: String,
    val modelLoadingParams: String?,
    val modelInferenceParams: String?
)
