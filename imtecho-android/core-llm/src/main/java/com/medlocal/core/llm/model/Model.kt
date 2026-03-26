package com.medlocal.core.llm.model

import java.util.UUID

/**
 * Model definition containing path and metadata.
 * This is a plain data class without Room annotations.
 */
data class Model(
    val id: String = UUID.randomUUID().toString(),
    val modelName: String,
    val modelPath: String,
    val pathType: PathType,
    val providerType: ProviderType,
    val fileSize: Long?,
    val isActive: Boolean = true
)
