package com.nsteuerberg.backend.virma.service.interfaces;

import com.nsteuerberg.backend.virma.presentation.dto.request.FilmWatchedRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.UserCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.EpisodeWatchedRequest;

public interface IUserService {
    void saveUser(UserCreateRequest userCreateRequest, Long userId);
    void filmWatched(FilmWatchedRequest filmWatchedRequest, Long userId);
    void episodeWatched(Long userId, EpisodeWatchedRequest episodeWatchedRequest);
}
