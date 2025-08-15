package com.nsteuerberg.backend.virma.service.implementation;

import com.nsteuerberg.backend.virma.persistance.entity.movies.FilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmId;
import com.nsteuerberg.backend.virma.persistance.repository.movie.IFilmRepository;
import com.nsteuerberg.backend.virma.persistance.repository.movie.IUserFilmRepository;
import com.nsteuerberg.backend.virma.presentation.dto.request.FilmCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.response.*;
import com.nsteuerberg.backend.virma.service.interfaces.IFilmService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class FilmServiceImpl implements IFilmService {
    private final IFilmRepository filmRepository;
    private final IUserFilmRepository userFilmRepository;
    private final CommonMediaServiceImpl commonMediaService;

    public FilmServiceImpl(IFilmRepository filmRepository, IUserFilmRepository userFilmRepository, CommonMediaServiceImpl commonMediaService) {
        this.filmRepository = filmRepository;
        this.userFilmRepository = userFilmRepository;
        this.commonMediaService = commonMediaService;
    }

    @Override
    public void saveFilm(FilmCreateRequest filmCreateRequest) {
        // ToDo Comprobar que exista el archivo de la pelicula y recoger la duracion del video
        filmRepository.save(FilmEntity.builder()
                .title(filmCreateRequest.title())
                .description(filmCreateRequest.description())
                .coverUrl(filmCreateRequest.coverUrl())
                .fileUrl(filmCreateRequest.fileUrl())
                .durationSeconds(filmCreateRequest.durationSeconds())
                .build()
        );
    }

    @Override
    public PagedResponse<FilmUserResponse> getPagenableFilm(Pageable pageable, Long userId) {
        Page<FilmEntity> filmEntityPage = filmRepository.findAll(pageable);
        List<FilmEntity> filmEntities = filmEntityPage.getContent();

        List<UserFilmEntity> userFilmEntities = userFilmRepository.findByUserIdAndFilmIn(userId, filmEntities);
        List<FilmUserResponse> filmUserResponses = mapUserFilms(filmEntityPage.getContent(), userFilmEntities);

        return new PagedResponse<FilmUserResponse>(
                filmUserResponses,
                PageInfo.builder()
                        .number(filmEntityPage.getNumber())
                        .size(filmEntityPage.getSize())
                        .totalPages(filmEntityPage.getTotalPages())
                        .totalElements(filmEntityPage.getTotalElements())
                        .last(filmEntityPage.isLast())
                        .build()
        );
    }

    public FilmUserResponse getFilmById(Long filmId, Long userId) {
        FilmEntity film = filmRepository.findById(filmId).orElseThrow();
        Optional<UserFilmEntity> userFilm = userFilmRepository.findById(new UserFilmId(userId, filmId));
        return new FilmUserResponse(
            FilmResponse.builder()
                  .id(film.getId())
                  .title(film.getTitle())
                  .durationSeconds(film.getDurationSeconds())
                  .fileUrl(commonMediaService.createUrlByEndpoint(film.getFileUrl()))
                  .coverUrl(commonMediaService.createUrlByEndpoint(film.getCoverUrl()))
                  .build(),
            userFilm.isPresent()
                ? new UserFilmStateResponse(
                    userFilm.get().getLiked(),
                    userFilm.get().getWatchedSeconds()
                )
                : null
        );
    }

    private List<FilmUserResponse> mapUserFilms(List<FilmEntity> filmEntities, List<UserFilmEntity> userFilmEntities) {
        // creamos un mapa para que sea mas facil acceder a la info de la peli, cogiendo como clave el id de la pelicula
        Map<Long, UserFilmEntity> userFilmMap = userFilmEntities.stream()
                .collect(Collectors.toMap(uf -> uf.getId().getFilmId(), uf -> uf));
        return filmEntities.stream()
                .map(film -> {
                    UserFilmEntity uf = userFilmMap.getOrDefault(
                            film.getId(),
                            UserFilmEntity.builder()
                                    .watchedSeconds(0)
                                    .build()
                    );
                    return new FilmUserResponse(
                            FilmResponse.builder()
                                    .id(film.getId())
                                    .title(film.getTitle())
                                    .description(film.getDescription())
                                    .coverUrl(commonMediaService.createUrlByEndpoint(film.getCoverUrl()))
                                    .fileUrl(commonMediaService.createUrlByEndpoint(film.getFileUrl()))
                                    .durationSeconds(film.getDurationSeconds())
                                    .build(),
                            new UserFilmStateResponse(
                                    uf.getLiked(),
                                    uf.getWatchedSeconds()
                            )
                    );
                }).toList();
    }
}
