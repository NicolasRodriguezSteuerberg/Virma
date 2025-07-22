package com.nsteuerberg.backend.virma.service.implementation;

import com.nsteuerberg.backend.virma.persistance.entity.FilmEntity;
import com.nsteuerberg.backend.virma.persistance.repository.IFilmRepository;
import com.nsteuerberg.backend.virma.presentation.dto.request.FilmCreateRequest;
import com.nsteuerberg.backend.virma.service.interfaces.IFilmService;
import org.springframework.stereotype.Service;

@Service
public class FilmServiceImpl implements IFilmService {
    private final IFilmRepository filmRepository;

    public FilmServiceImpl(IFilmRepository filmRepository) {
        this.filmRepository = filmRepository;
    }

    @Override
    public void saveFilm(FilmCreateRequest filmCreateRequest) {
        // ToDo Comprobar que exista el archivo de la pelicula y recoger la duracion del video
        filmRepository.save(FilmEntity.builder()
                        .title(filmCreateRequest.title())
                        .description(filmCreateRequest.description())
                        .coverUrl(filmCreateRequest.coverUrl())
                        .build()
        );
    }
}
