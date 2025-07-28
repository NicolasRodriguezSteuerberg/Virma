package com.nsteuerberg.backend.virma.presentation.dto.request.serie.create;

public record EpisodeWatchedRequest (
        Long serieId,
        Long episodeId,
        Integer watchedSeconds
){
}
