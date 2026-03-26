#include "medllm.h"
#include <cstring>
#include <cstdlib>
#include <iostream>
#include <algorithm>
#include <sstream>

static std::vector<llama_token> tokenize_v3(
        const llama_vocab* vocab, const std::string& text, bool add_special, bool parse_special) {
    if (!vocab) return {};
    const int len = (int) text.size();
    int need = llama_tokenize(vocab, text.c_str(), len, /*tokens*/ nullptr, /*n_tokens_max*/ 0, add_special, parse_special);
    if (need < 0) need = -need; // convert to positive "needed"
    if (need == 0) return {}; // empty input => no tokens
    std::vector<llama_token> toks((size_t)need);
    int got = llama_tokenize(vocab, text.c_str(), len, toks.data(), (int)toks.size(), add_special, parse_special);
    // If this API variant again returns negative when the buffer was still short,
    // allocate the larger buffer and retry once.
    if (got < 0) {
        got = -got;
        toks.resize((size_t)got);
        got = llama_tokenize(vocab, text.c_str(), len, toks.data(), (int)toks.size(), add_special, parse_special);
    }
    if (got < 0) {
        // Something else is wrong; log and bail.
        LOGE("tokenize_v3: final tokenize returned %d (len=%d) text(first128)='%.*s'", got, len, std::min(128, len), text.c_str());
        return {};
    }
    if (got != (int)toks.size()) {
        toks.resize((size_t)got);
    }
    return toks;
}

static std::string token_to_piece(
        const llama_vocab* vocab, llama_token tok, bool special = true) {
    if (!vocab)
        return {};
    char buf[512];
    int n = llama_token_to_piece(vocab, tok, buf, (int)sizeof(buf) - 1, /*lstrip*/0, special);
    if (n > 0 && n < (int)sizeof(buf)) {
        buf[n] = '\0';
        return std::string(buf, (size_t)n);
    }
    if (n > (int)sizeof(buf) - 1) {
        // Need a bigger buffer – allocate and retry once
        std::string out;
        out.resize((size_t)n);
        int n2 = llama_token_to_piece(vocab, tok, out.data(), n, /*lstrip*/0, special);
        if (n2 > 0) out.resize((size_t)n2);
        return out;
    }
    return {};
}

static std::string build_turn_prompt(const std::string& user_text) {
    // If your model ships a chat template, we’ll prefer that.
    // Fallback Gemma-like format if none:
    std::ostringstream oss;
    oss << "<start_of_turn>user\n" << user_text << "\n<end_of_turn>\n"
        << "<start_of_turn>model\n";
    return oss.str();
}
MedHandle* med_init(const char* model_path, int n_threads, int ctx_len) {
    if (!model_path || !*model_path) {
        LOGE("med_init: empty model path");
        return nullptr;
    }
    LOGI("med_init: path=%s", model_path);
    llama_backend_init();
    ggml_backend_load_all();
    llama_model_params mp = llama_model_default_params();
    mp.use_mmap = true;
    mp.use_mlock = false;
    llama_model* model = llama_model_load_from_file(model_path, mp);
    if (!model) {
        LOGE("failed to load model: %s", model_path);
        return nullptr;
    }
    const llama_vocab* vocab = llama_model_get_vocab(model);
    if (!vocab) {
        LOGE("no vocab");
        llama_model_free(model);
        return nullptr;
    }
    llama_context_params cp = llama_context_default_params();
    cp.n_ctx = std::max(256, ctx_len);
    cp.n_threads = std::max(1, n_threads);
    cp.no_perf = true;
    llama_context* ctx = llama_init_from_model(model, cp);
    if (!ctx) {
        LOGE("llama_new_context_with_model() returned null");
        llama_model_free(model);
        return nullptr;
    }
    llama_sampler_chain_params scp = llama_sampler_chain_default_params();
    scp.no_perf = true;
    llama_sampler* smpl = llama_sampler_chain_init(scp);
    // default: temperature + classic seed
    llama_sampler_chain_add(smpl, llama_sampler_init_temp(0.7f));
    llama_sampler_chain_add(smpl, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));
    auto* h = new MedHandle();
    h->model = model;
    h->ctx = ctx;
    h->vocab = vocab;
    h->smpl = smpl;
    h->n_threads = cp.n_threads;
    h->n_ctx = cp.n_ctx;
    // chat template (if model embeds one)
    const char* tmpl = llama_model_chat_template(model, /*buf*/ nullptr);
    if (tmpl && *tmpl) {
        h->chat_tmpl = strdup(tmpl);
    } else {
        h->chat_tmpl = nullptr;
    }
    h->formatted.assign((size_t)llama_n_ctx(ctx), 0);
    LOGI("Model loaded and context created");
    return h;
}

void med_unload(MedHandle* h) {
    if (!h) return;
    if (h->smpl) {
        llama_sampler_free(h->smpl);
        h->smpl = nullptr;
    }
    if (h->ctx) {
        llama_free(h->ctx);
        h->ctx = nullptr;
    }
    if (h->model){
        llama_model_free(h->model);
        h->model= nullptr;
    }
    if (h->chat_tmpl) {
        free(const_cast<char*>(h->chat_tmpl));
        h->chat_tmpl = nullptr;
    }
    for (auto& m : h->messages) {
        free(const_cast<char*>(m.role));
        free(const_cast<char*>(m.content));
    }
    delete h;
}

static uint32_t kv_used_cells_compat(const llama_context * ctx) {
    // Compile-time dispatch across known variants:
    #if defined(LLAMA_API_KV_SELF_USED_CELLS) || defined(LLAMA_KV_SELF_USED)
        return llama_kv_self_used_cells(ctx);
    #elif defined(LLAMA_API_GET_KV_CACHE_USED_CELLS)
        return llama_get_kv_cache_used_cells(ctx);
    #else
        // Last resort: skip the pre-check and let decode fail if it overflows.
        // (many older commits didn't expose a "used cells" query)
        return 0;
    #endif
}

void med_cancel(MedHandle* h) {
    if (!h)
        return;
    h->cancel.store(true, std::memory_order_relaxed);
}

static void reset_ctx_bruteforce(MedHandle* h) {
    llama_free(h->ctx);
    llama_context_params cp = llama_context_default_params();
    cp.n_ctx     = h->n_ctx;
    cp.n_threads = h->n_threads;
    cp.no_perf   = true;
    h->ctx = llama_init_from_model(h->model, cp);
}

char* med_generate(MedHandle* h, const char* user_text, int max_new_tokens, float temp, float top_p) {
    if (!h || !h->ctx || !h->model || !h->smpl || !h->vocab) {
        return strdup("ERROR: uninitialized handle");
    }
    if (!user_text) user_text = "";
    reset_ctx_bruteforce(h);
    // If your llama.cpp uses a different name, replace with the appropriate API.

    llama_sampler_free(h->smpl);
    llama_sampler_chain_params scp = llama_sampler_chain_default_params();
    scp.no_perf = true;
    h->smpl = llama_sampler_chain_init(scp);
    llama_sampler_chain_add(h->smpl, llama_sampler_init_temp(std::max(0.01f, temp)));
    llama_sampler_chain_add(h->smpl, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));
    if (top_p < 0.999f) {
        llama_sampler_chain_add(h->smpl, llama_sampler_init_top_p(top_p, /*min_keep*/1));
    }
    llama_sampler_chain_add(h->smpl, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));
    h->cancel.store(false, std::memory_order_relaxed);
    h->cache_piece.clear();
    h->response.clear();

    std::string prompt;
    if (h->chat_tmpl && *h->chat_tmpl) {
        llama_chat_message one_turn[1] = {
                { "user", user_text }
        };

        int need = llama_chat_apply_template(h->chat_tmpl,
                                             one_turn, 1,
                /*add_ass=*/true,
                                             h->formatted.data(),
                                             (int)h->formatted.size());
        if (need > (int)h->formatted.size()) {
            h->formatted.resize(need);
            need = llama_chat_apply_template(h->chat_tmpl,
                                             one_turn, 1, /*add_ass=*/true,
                                             h->formatted.data(),
                                             (int)h->formatted.size());
        }
        if (need < 0) {
            prompt = build_turn_prompt(user_text);
        } else {
            prompt.assign(h->formatted.data(), h->formatted.data() + need);
        }
    } else {
        prompt = build_turn_prompt(user_text);
    }

    auto toks = tokenize_v3(h->vocab, prompt, /*add_special*/true, /*parse_special*/true);
    LOGI("prompt tokens: %zu", toks.size());
    if (toks.empty()) return strdup("ERROR: tokenization produced 0 tokens");

    llama_batch prompt_batch = llama_batch_init((int32_t)toks.size(), /*embd*/0, /*n_seq_max*/1);
    prompt_batch.n_tokens = (int32_t)toks.size();
    for (int32_t i = 0; i < prompt_batch.n_tokens; ++i) {
        prompt_batch.token[i]    = toks[i];
        prompt_batch.pos[i]      = i;
        prompt_batch.n_seq_id[i] = 1;
        prompt_batch.seq_id[i][0]= 0;
        prompt_batch.logits[i]   = false;
    }
    if (prompt_batch.n_tokens > 0)
        prompt_batch.logits[prompt_batch.n_tokens - 1] = true;

    const uint32_t n_ctx = llama_n_ctx(h->ctx);
    if ((uint32_t)prompt_batch.n_tokens > n_ctx) {
        llama_batch_free(prompt_batch);
        return strdup("ERROR: prompt exceeds context");
    }

    int decode_ret = llama_decode(h->ctx, prompt_batch);
    if (decode_ret < 0) {
        llama_batch_free(prompt_batch);
        return strdup("ERROR: decode failed on prompt");
    }
    int32_t n_prompt = prompt_batch.n_tokens;
    llama_batch_free(prompt_batch);

    llama_batch single_batch = llama_batch_init(1, /*embd*/0, /*n_seq_max*/1);
    int32_t cur_pos = n_prompt;
    int produced = 0;

    while (produced < std::max(1, max_new_tokens)) {
        if (h->cancel.load(std::memory_order_relaxed)) break;

        // sample from most recent logits (after prompt: index n_prompt-1; thereafter index 0)
        int32_t sample_idx = (produced == 0) ? (n_prompt - 1) : 0;
        llama_token id = llama_sampler_sample(h->smpl, h->ctx, sample_idx);
        if (llama_vocab_is_eog(h->vocab, id)) break;

        // append decoded piece
        std::string piece = token_to_piece(h->vocab, id, /*special*/true);
        if (!piece.empty()) {
            h->cache_piece += piece;

            // flush only if UTF-8 valid
            const unsigned char* b = (const unsigned char*)h->cache_piece.c_str();
            bool valid = true;
            while (*b) {
                int num;
                if      ((*b & 0x80) == 0x00) num = 1;
                else if ((*b & 0xE0) == 0xC0) num = 2;
                else if ((*b & 0xF0) == 0xE0) num = 3;
                else if ((*b & 0xF8) == 0xF0) num = 4;
                else { valid = false; break; }
                ++b;
                for (int i = 1; i < num; ++i, ++b) {
                    if ((*b & 0xC0) != 0x80) { valid = false; break; }
                }
                if (!valid) break;
            }
            if (valid) {
                h->response += h->cache_piece;
                h->cache_piece.clear();
            }
        }

        single_batch.n_tokens      = 1;
        single_batch.token[0]      = id;
        single_batch.pos[0]        = cur_pos;
        single_batch.n_seq_id[0]   = 1;
        single_batch.seq_id[0][0]  = 0;
        single_batch.logits[0]     = true;

        decode_ret = llama_decode(h->ctx, single_batch);
        if (decode_ret < 0) {
            LOGE("decode failed on generated token");
            break;
        }
        ++cur_pos;
        ++produced;
    }
    llama_batch_free(single_batch);

    char* ret = (char*) std::malloc(h->response.size() + 1);
    std::memcpy(ret, h->response.data(), h->response.size());
    ret[h->response.size()] = '\0';
    std::cout<<"output token------"<<produced<<std::endl;
    return ret;
}


// ----------------- JNI (package: com.example.medlocal) -----------------
#include <jni.h>
extern "C" JNIEXPORT jlong JNICALL Java_com_example_medlocal_LlmClient_nativeInit(
        JNIEnv* env, jobject thiz, jstring jpath, jint n_threads, jint ctx_len) {
    const char* p = env->GetStringUTFChars(jpath, nullptr);
    MedHandle* h = med_init(p, (int)n_threads, (int)ctx_len);
    env->ReleaseStringUTFChars(jpath, p);
    return (jlong)(intptr_t)h;
}
extern "C" JNIEXPORT jstring JNICALL Java_com_example_medlocal_LlmClient_nativeGenerate(
        JNIEnv* env, jobject thiz, jlong handle, jstring juser, jint max_new, jfloat temp, jfloat top_p) {
    MedHandle* h = (MedHandle*)(intptr_t)handle;
    const char* ut = env->GetStringUTFChars(juser, nullptr);
    char* out = med_generate(h, ut, (int)max_new, (float)temp, (float)top_p);
    env->ReleaseStringUTFChars(juser, ut);
    jstring jret = env->NewStringUTF(out ? out : "");
    if (out) std::free(out);
    return jret;
}
extern "C" JNIEXPORT void JNICALL Java_com_example_medlocal_LlmClient_nativeCancel(
        JNIEnv* env, jobject thiz, jlong handle) {
    MedHandle* h = (MedHandle*)(intptr_t)handle;
    med_cancel(h);
}
extern "C" JNIEXPORT void JNICALL Java_com_example_medlocal_LlmClient_nativeUnload(
        JNIEnv* env, jobject thiz, jlong handle) {
    MedHandle* h = (MedHandle*)(intptr_t)handle;
    med_unload(h);
}