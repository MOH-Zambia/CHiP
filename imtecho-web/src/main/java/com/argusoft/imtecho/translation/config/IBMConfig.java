package com.argusoft.imtecho.translation.config;

import com.argusoft.imtecho.common.util.ConstantUtil;
import com.ibm.cloud.sdk.core.security.IamAuthenticator;
import com.ibm.watson.language_translator.v3.LanguageTranslator;
import org.springframework.stereotype.Component;


@Component
public class IBMConfig {
    public IBMConfig() {
    }

    public LanguageTranslator getLanguageTranslatorInstance() {
        @SuppressWarnings("deprecation") IamAuthenticator authenticator = new IamAuthenticator(ConstantUtil.IBM_ACCESS_KEY);
        LanguageTranslator languageTranslator = new LanguageTranslator(ConstantUtil.IBM_VERSION_DATE, authenticator);
        languageTranslator.setServiceUrl(ConstantUtil.IBM_ACCESS_URL);
        return languageTranslator;
    }
}

