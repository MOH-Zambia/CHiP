#include "medwhisper.h"
#include <cstdlib>
#include <cstring>
#include <jni.h>

MedWhisper* med_whisper_init(const char* model_path, int n_threads, int sample_rate, const char* language_or_null, bool translate) {
    if (!model_path || !*model_path) {
        WLOGE("med_whisper_init: empty model path"); return nullptr;
    }
    WLOGI("med_whisper_init: %s", model_path);

    whisper_context_params cparams = whisper_context_default_params();
    cparams.use_gpu = false;   // Android CPU default

    whisper_context* ctx = whisper_init_from_file_with_params(model_path, cparams);
    if (!ctx) { WLOGE("whisper_init_from_file failed"); return nullptr; }

    auto* h = new MedWhisper();
    h->ctx = ctx;
    h->n_threads = (n_threads > 0) ? n_threads : 4;
    h->sample_rate = (sample_rate > 0) ? sample_rate : 16000;
    h->translate = translate;

    if (language_or_null && *language_or_null) {
        std::snprintf(h->lang, sizeof(h->lang), "%s", language_or_null);
    } else {
        h->lang[0] = 0;
    }

    return h;
}

void med_whisper_unload(MedWhisper* h) {
    if (!h)
        return;
    if (h->ctx) {
        whisper_free(h->ctx);
        h->ctx = nullptr;
    }
    delete h;
}

void med_whisper_cancel(MedWhisper* h) {
    if (!h)
        return;
    h->cancel.store(true, std::memory_order_relaxed);
}

char* med_whisper_transcribe(MedWhisper* h, const short* pcm_s16, int n_samples) {
    if (!h || !h->ctx || !pcm_s16 || n_samples <= 0) {
        return ::strdup("");
    }

    // s16 -> f32 [-1, 1]
    std::vector<float> pcm;
    pcm.resize((size_t)n_samples);
    for (int i = 0; i < n_samples; ++i) {
        pcm[(size_t)i] = pcm_s16[i] / 32768.0f;
    }

    whisper_full_params wparams = whisper_full_default_params(WHISPER_SAMPLING_GREEDY);
    wparams.n_threads = h->n_threads;
    wparams.print_realtime = false;
    wparams.print_progress = false;
    wparams.print_timestamps = false;
    wparams.translate = h->translate; // force English if true
    wparams.no_context = true;

    if (h->lang[0]) {
        wparams.language = h->lang;
        wparams.detect_language = false;
    }

    h->cancel.store(false, std::memory_order_relaxed);
    // If you want cancellation mid-run, set: wparams.abort_callback = [](void* user_data)->bool{ return static_cast<MedWhisper*>(user_data)->cancel.load(); };
     wparams.abort_callback_user_data = h;

    int rc = whisper_full(h->ctx, wparams, pcm.data(), (int)pcm.size());
    if (rc != 0) {
        WLOGE("whisper_full rc=%d", rc);
        return ::strdup("");
    }

    std::string out;
    const int n_seg = whisper_full_n_segments(h->ctx);
    for (int i = 0; i < n_seg; ++i) {
        const char* seg = whisper_full_get_segment_text(h->ctx, i);
        if (seg && *seg) {
            if (!out.empty()) out.push_back(' ');
            out += seg;
        }
    }
    char* ret = (char*) std::malloc(out.size() + 1);
    std::memcpy(ret, out.data(), out.size());
    ret[out.size()] = '\0';
    return ret;
}

// ---------- JNI: com.example.medlocal.WhisperClient ----------
static std::string j2s(JNIEnv* env, jstring js) {
    if (!js) return {};
    const char* c = env->GetStringUTFChars(js, nullptr);
    std::string s = c ? c : "";
    if (c) env->ReleaseStringUTFChars(js, c);
    return s;
}

extern "C" JNIEXPORT jlong JNICALL
Java_com_example_medlocal_WhisperClient_nativeInit(
        JNIEnv* env, jobject /*thiz*/,
        jstring jPath, jint nThreads, jint sampleRate,
        jstring jLang, jboolean translate) {
    std::string path = j2s(env, jPath);
    std::string lang = j2s(env, jLang);
    MedWhisper* h = med_whisper_init(path.c_str(),
                                     (int)nThreads,
                                     (int)sampleRate,
                                     lang.empty() ? nullptr : lang.c_str(),
                                     (bool)translate);
    return (jlong)(intptr_t)h;
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_example_medlocal_WhisperClient_nativeTranscribe(JNIEnv* env, jobject /*thiz*/, jlong handle, jshortArray jPcm) {
    auto* h = (MedWhisper*)(intptr_t)handle;
    if (!h || !jPcm)
        return env->NewStringUTF("");

    jsize n = env->GetArrayLength(jPcm);
    std::vector<short> tmp((size_t)n);
    env->GetShortArrayRegion(jPcm, 0, n, tmp.data());

    char* c = med_whisper_transcribe(h, tmp.data(), (int)n);
    jstring jret = env->NewStringUTF(c ? c : "");
    if (c)
        std::free(c);
    return jret;
}

extern "C" JNIEXPORT void JNICALL
Java_com_example_medlocal_WhisperClient_nativeCancel(JNIEnv* /*env*/, jobject /*thiz*/, jlong handle) {
    auto* h = (MedWhisper*)(intptr_t)handle;
    med_whisper_cancel(h);
}

extern "C" JNIEXPORT void JNICALL
Java_com_example_medlocal_WhisperClient_nativeUnload(JNIEnv* /*env*/, jobject /*thiz*/, jlong handle) {
    auto* h = (MedWhisper*)(intptr_t)handle;
    med_whisper_unload(h);
}
