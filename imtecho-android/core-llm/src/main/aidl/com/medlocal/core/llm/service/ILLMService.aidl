package com.medlocal.core.llm.service;

import com.medlocal.core.llm.service.IGgufGenerationCallback;
import com.medlocal.core.llm.service.IModelLoadCallback;

interface ILLMService {

    // Model Loading
    void loadGgufModel(String modelPath, String modelName, String loadingParams, String inferenceParams, IModelLoadCallback callback);
    void loadGgufModelFromFd(in ParcelFileDescriptor pfd, String modelName, String loadingParams, String inferenceParams, IModelLoadCallback callback);
    
    // Text Generation
    void generateGguf(String prompt, int maxTokens, IGgufGenerationCallback callback);
    void stopGenerationGguf();
    
    // Model Management
    void unloadModelGguf();
    String getModelInfoGguf();
    
    // Tool Calling
    boolean setToolsJsonGguf(String toolsJson);
    void clearToolsGguf();
}
