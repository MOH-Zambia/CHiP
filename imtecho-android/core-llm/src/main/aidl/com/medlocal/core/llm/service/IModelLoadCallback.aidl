package com.medlocal.core.llm.service;

interface IModelLoadCallback {
    void onSuccess();
    void onError(String message);
}
