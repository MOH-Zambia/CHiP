#pragma once
#include <atomic>
#include <string>
#include <vector>
#include "llama.h"
#ifdef __ANDROID__
#include <android/log.h>
#define LOG_TAG "medllm"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#else
#include <cstdio>
#define LOGI(...) (std::fprintf(stdout, __VA_ARGS__), std::fprintf(stdout, "\n"))
#define LOGE(...) (std::fprintf(stderr, __VA_ARGS__), std::fprintf(stderr, "\n"))
#endif

struct MedHandle {
    llama_model* model = nullptr;
    llama_context* ctx = nullptr;
    const llama_vocab* vocab = nullptr;
    llama_sampler* smpl = nullptr;
    // rolling chat buffer (like SmolChat)
    std::vector<llama_chat_message> messages;
    std::vector<char> formatted; // buffer used by llama_chat_apply_template
    const char* chat_tmpl = nullptr;
    std::atomic<bool> cancel{false};
    int n_threads = 4;
    int n_ctx = 0;
    // scratch for generation
    std::string cache_piece;
    std::string response;
};

// C API used by JNI
extern "C" {
    MedHandle* med_init(const char* model_path, int n_threads, int ctx_len);
    void med_unload(MedHandle* h);
    void med_cancel(MedHandle* h);
    char* med_generate(MedHandle* h, const char* user_text, int max_new_tokens, float temp, float top_p, int* output_token);
}