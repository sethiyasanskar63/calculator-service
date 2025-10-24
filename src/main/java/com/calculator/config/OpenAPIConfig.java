package com.calculator.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenAPIConfig {

    @Bean
    public OpenAPI calculatorOpenAPI() {
        Server localServer = new Server();
        localServer.setUrl("http://localhost:8080");
        localServer.setDescription("Local Development Server");

        Server prodServer = new Server();
        prodServer.setUrl("https://your-production-url.com");
        prodServer.setDescription("Production Server");

        Contact contact = new Contact();
        contact.setName("Calculator Service Team");
        contact.setEmail("support@calculator.com");

        License license = new License()
                .name("MIT License")
                .url("https://opensource.org/licenses/MIT");

        Info info = new Info()
                .title("Calculator Microservice API")
                .version("1.0.0")
                .contact(contact)
                .description("RESTful API for basic arithmetic operations. Supports addition, subtraction, multiplication, and division.")
                .license(license);

        return new OpenAPI()
                .info(info)
                .servers(List.of(localServer, prodServer));
    }
}
