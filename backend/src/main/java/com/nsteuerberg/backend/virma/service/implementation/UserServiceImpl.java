package com.nsteuerberg.backend.virma.service.implementation;

import com.nsteuerberg.backend.virma.persistance.entity.UserEntity;
import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmId;
import com.nsteuerberg.backend.virma.persistance.entity.series.*;
import com.nsteuerberg.backend.virma.persistance.repository.movie.IUserFilmRepository;
import com.nsteuerberg.backend.virma.persistance.repository.series.IEpisodeRepository;
import com.nsteuerberg.backend.virma.persistance.repository.user.IUserEpisodeRepository;
import com.nsteuerberg.backend.virma.persistance.repository.user.IUserRepository;
import com.nsteuerberg.backend.virma.persistance.repository.user.IUserSerieRepository;
import com.nsteuerberg.backend.virma.presentation.dto.request.FilmWatchedRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.UserCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.EpisodeWatchedRequest;
import com.nsteuerberg.backend.virma.service.exceptions.UserAlreadyExistsException;
import com.nsteuerberg.backend.virma.service.interfaces.IUserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class UserServiceImpl implements IUserService {
    private static final Logger log = LoggerFactory.getLogger(UserServiceImpl.class);

    private final IUserRepository userRepository;
    private final IUserFilmRepository userFilmRepository;
    private final IUserSerieRepository userSerieRepository;
    private final IEpisodeRepository episodeRepository;
    private final IUserEpisodeRepository userEpisodeRepository;

    public UserServiceImpl(IUserRepository userRepository, IUserFilmRepository userFilmRepository, IUserSerieRepository userSerieRepository, IEpisodeRepository episodeRepository, IUserEpisodeRepository userEpisodeRepository) {
        this.userRepository = userRepository;
        this.userFilmRepository = userFilmRepository;
        this.userSerieRepository = userSerieRepository;
        this.episodeRepository = episodeRepository;
        this.userEpisodeRepository = userEpisodeRepository;
    }

    @Override
    public void saveUser(UserCreateRequest userCreateRequest, Long userId) {
        if (userRepository.findById(userId).isPresent()) throw new UserAlreadyExistsException("El usuario ya existe");

        userRepository.save(
            UserEntity.builder()
                    .id(userId)
                    .username(userCreateRequest.username())
                    .build()
        );
    }

    @Override
    public void filmWatched(FilmWatchedRequest filmWatchedRequest, Long userId) {
        // ToDo completar
        UserFilmId userFilmId = new UserFilmId(userId, filmWatchedRequest.filmId());
        UserFilmEntity userFilm = userFilmRepository.findById(userFilmId).orElseGet(() -> UserFilmEntity.builder()
                        .id(userFilmId)
                .build()
        );
        userFilm.setWatchedSeconds(filmWatchedRequest.secondsWatched());
        userFilmRepository.save(userFilm);
    }

    @Override
    public void episodeWatched(Long userId, EpisodeWatchedRequest episodeWatchedRequest) {
        // Miramos que el episodio pertenezca a la serie que nos indican por posibles errores
        // rechazamos intentos de ver mas segundos de lo que dura el episodio
        log.info("EpisodeWatched:: Comprobando que el id de la serie pertenezca a al serieId que tiene el episodio");
        EpisodeEntity episode = episodeRepository.findById(episodeWatchedRequest.episodeId()).orElseThrow();
        if (episode.getDurationSeconds() < episodeWatchedRequest.watchedSeconds()) throw new IllegalArgumentException("No se puede ver mas segundos de lo que dura el episodio");
        if (episode.getSeason().getSerie().getId() != episodeWatchedRequest.serieId()) throw new IllegalArgumentException("No coinciden los ids de las series");
        UserEpisodeId userEpisodeId = new UserEpisodeId(userId, episodeWatchedRequest.episodeId());
        log.info("EPISODE_WATCHED:: Recogiendo o creando entidad de UserEpisode...");
        UserEpisodeEntity userEpisodeEntity = userEpisodeRepository.findById(userEpisodeId)
                .orElseGet(() -> UserEpisodeEntity.builder()
                        .id(userEpisodeId)
                        .episode(episode)
                        .user(userRepository.findById(userId).orElseThrow())
                        .build()
                );
        userEpisodeEntity.setWatchedSeconds(episodeWatchedRequest.watchedSeconds());
        log.info("EPISODE WATCHED:: Guardando el episodio visto del usuario");
        userEpisodeRepository.save(userEpisodeEntity);
        log.info("EPISODE WATCHED:: Agregando la informacion de la serie vista");
        serieWatchedEpisode(userEpisodeEntity.getUser(), episode.getSeason().getSerie(), episode.getId());
    }

    /**
     * Metodo que se llama despues de actualizar el tiempo visto de un episodio
     * Para poder especificar cual fue el último episodio visto
     * @param user
     * @param serie
     * @param episodeId
     */
    private void serieWatchedEpisode(UserEntity user, SerieEntity serie, Long episodeId) {
        log.info("Recogiendo la informacion del episodio (a partir de la que se recogerá ");
        UserSerieId userSerieId = new UserSerieId(user.getId(), serie.getId());
        UserSerieEntity userSerieEntity = userSerieRepository.findById(userSerieId)
                .orElseGet(() -> UserSerieEntity.builder()
                        .id(userSerieId)
                        .user(user)
                        .serie(serie)
                        .build()
                );
        log.info("SERIE_WATCHED_EPISODE:: Agregando la hora y el id del episodo");
        userSerieEntity.setLastEpisodeId(episodeId);
        LocalDateTime now = LocalDateTime.now();
        userSerieEntity.setLastTimeWatched(now);
        userSerieRepository.save(userSerieEntity);
    }
}
