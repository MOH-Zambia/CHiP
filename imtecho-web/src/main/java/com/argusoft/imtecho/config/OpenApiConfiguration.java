package com.argusoft.imtecho.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.PathItem;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.media.Schema;
import io.swagger.v3.oas.models.servers.Server;
import org.springdoc.core.customizers.OpenApiCustomiser;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.*;

@Configuration
public class OpenApiConfiguration {

    List dtoArray = new ArrayList<>(List.of("AncDto", "ChildServiceDto", "ClientMemberDto", "CovidDto", "HivDto", "HouseHoldDto", "InteractionDto", "MalariaDto", "PncChildDetailsDto", "PncMotherDetailsDto", "ReferralDto", "TuberculosisDto", "WpdChildDetailsDto", "WpdMotherDetailsDto","ImtechoResponseEntity"));

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info().title("CHIP INTEGRATION API")
                        .version("1.0.0").contact(new Contact()
                                .name("CHIP")
                                .email("abcd@gmail.com")
                                .url("102.23.121.122/imtecho-ui/#!/")))
                .addServersItem(new Server().url("http://102.23.121.122").description("Staging server"));
    }

    @Bean
    public OpenApiCustomiser openApiCustomiser() {
        Map<String, Schema> temp = new HashMap<>();
        return openApi -> {
            openApi.path("/chipIntegration", new PathItem());
            openApi.getPaths().keySet().removeIf(path -> !path.startsWith("/chipIntegration"));
            if (openApi.getComponents() != null) {
                openApi.getComponents().getSchemas().forEach((key, value) -> {
                    if (dtoArray.contains(key)) {
                        temp.put(key,value);
                    }
                });
                openApi.getComponents().setSchemas(temp);
            }
        };
    }

}