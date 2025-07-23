package com.nsteuerberg.backend.virma.presentation.dto.request;

public record FilmWatchedRequest (
        Long filmId,
        Integer secondsWatched
){
}
