package com.nsteuerberg.backend.virma.service.interfaces;

import com.nsteuerberg.backend.virma.presentation.dto.request.FilmWatchedRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.UserCreateRequest;

public interface IUserService {
    void saveUser(UserCreateRequest userCreateRequest, Long userId);
    void filmWatched(FilmWatchedRequest filmWatchedRequest, Long userId);
}
