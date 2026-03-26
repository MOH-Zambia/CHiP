package com.medlocal.core.llm.model

import com.mp.ai_gguf.models.DecodingMetrics

/**
 * Sealed class representing events during text generation.
 * Used for streaming responses from the GGUF engine.
 */
sealed class GenerationEvent {
    /** A new token was generated */
    data class Token(val text: String) : GenerationEvent()
    
    /** A tool/function call was detected */
    data class ToolCall(val name: String, val args: String) : GenerationEvent()
    
    /** Generation completed successfully */
    data object Done : GenerationEvent()
    
    /** An error occurred during generation */
    data class Error(val message: String) : GenerationEvent()
    
    /** Metrics about the generation process */
    data class Metrics(val metrics: DecodingMetrics) : GenerationEvent()
}
