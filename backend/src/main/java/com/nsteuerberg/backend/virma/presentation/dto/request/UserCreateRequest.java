package com.nsteuerberg.backend.virma.presentation.dto.request;

import jakarta.validation.constraints.NotBlank;

public record UserCreateRequest(
        @NotBlank
        String username
) {
}
