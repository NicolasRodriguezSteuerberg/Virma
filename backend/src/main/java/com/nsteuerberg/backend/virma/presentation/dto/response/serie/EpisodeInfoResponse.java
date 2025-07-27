package com.nsteuerberg.backend.virma.presentation.dto.response.serie;

public record EpisodeInfoResponse (
        Long id,
        Integer number,
        String description,
        String fileUrl,
        Integer durationSeconds
){
}
