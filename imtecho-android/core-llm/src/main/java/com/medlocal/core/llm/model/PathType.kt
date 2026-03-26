package com.medlocal.core.llm.model

/**
 * Type of path for model location
 */
enum class PathType {
    FILE,           // Direct file path
    DIRECTORY,      // Directory containing model files
    CONTENT_URI     // SAF content:// URI (Android Storage Access Framework)
}
