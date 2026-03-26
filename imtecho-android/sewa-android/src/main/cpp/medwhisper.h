#pragma once
#include <atomic>
#include <string>
#include <vector>

#ifdef __ANDROID__
#include <android/log.h>
#define WLOG_TAG "medwhisper"
#define WLOGI(...) __android_log_print(ANDROID_LOG_INFO , WLOG_TAG, __VA_ARGS__)
#define WLOGE(...) __android_log_print(ANDROID_LOG_ERROR, WLOG_TAG, __VA_ARGS__)
#else
#include <cstdio>
  #define WLOGI(...) (std::fprintf(stdout, __VA_ARGS__), std::fprintf(stdout, "\n"))
  #define WLOGE(...) (std::fprintf(stderr, __VA_ARGS__), std::fprintf(stderr, "\n"))
#endif

extern "C" {
#include "whisper.h"
}

struct MedWhisper {
    whisper_context* ctx = nullptr;

    std::atomic<bool> cancel{false};
    int  n_threads   = 4; // default threads
    int  sample_rate = 16000;  // expected PCM rate
    bool translate = false;  // force English if true
    char lang[8] = {0};
};

extern "C" {
MedWhisper* med_whisper_init(const char* model_path, int n_threads, int sample_rate, const char* language_or_null, bool translate);
void med_whisper_unload(MedWhisper* h);
void med_whisper_cancel(MedWhisper* h);

char* med_whisper_transcribe(MedWhisper* h, const short* pcm_s16, int n_samples);
}
