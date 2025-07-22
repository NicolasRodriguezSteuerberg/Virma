package com.nsteuerberg.backend.virma.service.interfaces;

import com.nsteuerberg.backend.virma.presentation.dto.request.FilmCreateRequest;

public interface IFilmService {
    void saveFilm(FilmCreateRequest filmCreateRequest);
}
