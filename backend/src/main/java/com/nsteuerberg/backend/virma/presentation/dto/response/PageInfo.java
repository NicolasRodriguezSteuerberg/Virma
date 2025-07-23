package com.nsteuerberg.backend.virma.presentation.dto.response;

import lombok.Builder;

@Builder
public record PageInfo (
        int number,
        int size,
        int totalElements,
        int totalPages,
        boolean last
){
}
