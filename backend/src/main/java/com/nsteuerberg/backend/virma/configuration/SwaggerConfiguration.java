package com.nsteuerberg.backend.virma.configuration;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.servers.Server;

@OpenAPIDefinition(
        info = @Info(
                title = "Virma",
                description = "App para ver series o peliculas",
                version = "0.1.0",
                contact = @Contact(
                        name = "Nicolas Steuerberg",
                        email = "nicolassteuerberg@gmail.com"
                )
        ),
        servers = {
                @Server(
                        description = "Dev server",
                        url = "http://localhost:8080/virma/api"
                )
        }
)
public class SwaggerConfiguration {

}
