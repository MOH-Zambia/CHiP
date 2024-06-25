package com.argusoft.imtecho.config;

import com.argusoft.imtecho.common.util.ConstantUtil;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.http.HttpMethod;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import java.util.Arrays;

/**
 *
 * @author Satyajit
 */
@Configuration
public class WebConfig extends WebMvcConfigurerAdapter {

    @Bean
    public FilterRegistrationBean accessControlFilterRegistrationBean() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();

        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        if (ConstantUtil.ALLOW_ORIGIN.equals("*")) {
            config.addAllowedOriginPattern(ConstantUtil.ALLOW_ORIGIN);
        } else {
            config.setAllowedOrigins(Arrays.asList(ConstantUtil.ALLOW_ORIGIN.split(",")));
        }
        config.addAllowedHeader("*");
        config.addAllowedMethod(HttpMethod.GET);
        config.addAllowedMethod(HttpMethod.POST);
        config.addAllowedMethod(HttpMethod.PUT);
        config.addAllowedMethod(HttpMethod.DELETE);
        source.registerCorsConfiguration("/**", config);
        FilterRegistrationBean bean = new FilterRegistrationBean(new CorsFilter(source));
        bean.setOrder(Ordered.HIGHEST_PRECEDENCE);
        return bean;
    }

    @Bean
    public FilterRegistrationBean noCacheFilterRegistrationBean() {
        FilterRegistrationBean noCacheFilterBean = new FilterRegistrationBean(new NoCacheFilter());
        noCacheFilterBean.setOrder(Ordered.LOWEST_PRECEDENCE);
        return noCacheFilterBean;
    }

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/imtecho-ui/").setViewName("forward:/imtecho-ui/index.html");
        registry.addViewController("/").setViewName("forward:/imtecho-ui/redirect.html");
        registry.setOrder(Ordered.HIGHEST_PRECEDENCE);
        super.addViewControllers(registry);
    }
//    @Bean(name = "multipartResolver")
//    public MultipartResolver multipartResolver() {
//        CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
//        multipartResolver.setMaxUploadSize((long) 1000000 * 3048);
//        return multipartResolver;
//    }

}
