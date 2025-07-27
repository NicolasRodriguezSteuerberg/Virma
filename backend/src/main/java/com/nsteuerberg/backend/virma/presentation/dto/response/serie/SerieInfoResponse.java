package com.nsteuerberg.backend.virma.presentation.dto.response.serie;

public record SerieInfoResponse (
        Long id,
        String title,
        String description,
        String coverUrl
){
}
