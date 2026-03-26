package com.medlocal.core.llm.model

/**
 * Device tier classification based on available RAM
 */
enum class DeviceTier {
    LOW_END,    // < 4GB RAM
    MID_RANGE,  // 4-8GB RAM
    HIGH_END    // > 8GB RAM
}
