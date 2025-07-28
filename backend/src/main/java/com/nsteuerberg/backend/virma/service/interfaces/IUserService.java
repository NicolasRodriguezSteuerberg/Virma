package com.nsteuerberg.backend.virma.service.interfaces;

import com.nsteuerberg.backend.virma.persistance.entity.UserEntity;
import com.nsteuerberg.backend.virma.persistance.entity.series.EpisodeEntity;
import com.nsteuerberg.backend.virma.persistance.entity.series.UserEpisodeEntity;
import com.nsteuerberg.backend.virma.presentation.dto.request.FilmWatchedRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.UserCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.EpisodeWatchedRequest;

public interface IUserService {
    void saveUser(UserCreateRequest userCreateRequest, Long userId);
    UserEntity getUserById(Long userId);
    void filmWatched(FilmWatchedRequest filmWatchedRequest, Long userId);
    void episodeWatched(Long userId, EpisodeWatchedRequest episodeWatchedRequest);
    UserEpisodeEntity getUserEpisodeEntity(Long userId, EpisodeEntity episode);
}
