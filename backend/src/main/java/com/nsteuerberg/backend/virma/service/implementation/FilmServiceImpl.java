package com.nsteuerberg.backend.virma.service.implementation;

import com.nsteuerberg.backend.virma.persistance.entity.movies.FilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmEntity;
import com.nsteuerberg.backend.virma.persistance.repository.movie.IFilmRepository;
import com.nsteuerberg.backend.virma.persistance.repository.movie.IUserFilmRepository;
import com.nsteuerberg.backend.virma.presentation.dto.request.FilmCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.response.*;
import com.nsteuerberg.backend.virma.service.interfaces.IFilmService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URL;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class FilmServiceImpl implements IFilmService {
    private final IFilmRepository filmRepository;
    private final IUserFilmRepository userFilmRepository;
    private final RestTemplate restTemplate;

    @Value("${nginx.server.url}")
    private String nginxBaseUrl;

    public FilmServiceImpl(IFilmRepository filmRepository, IUserFilmRepository userFilmRepository) {
        this.filmRepository = filmRepository;
        this.userFilmRepository = userFilmRepository;
        this.restTemplate = new RestTemplate();
    }

    public boolean isUrlValid(String url) {
        boolean isValid = false;
        try {
            URL parsedUrl = new URL(url);
            isValid = isValidServer(parsedUrl);
            if (isValid) isValid = filmUrlExists(parsedUrl);
        } catch (Exception e){
            isValid = false;
            System.out.println(e);
        }
        return isValid;
    }

    private boolean isValidServer(URL url) {
        String route = url.getProtocol() + "://" + url.getHost() + ":" + url.getPort();
        System.out.println(nginxBaseUrl);
        return nginxBaseUrl.equals(route);
    }

    private boolean filmUrlExists(URL url) {
        try {
            ResponseEntity<?> response = restTemplate.exchange(url.toURI(), HttpMethod.GET, null, String.class);
            if (!response.getStatusCode().is2xxSuccessful()) {
                throw new Exception("No ha sido satisfactoria");
            }
            String headerContentType = response.getHeaders().getFirst(HttpHeaders.CONTENT_TYPE);
            if (headerContentType == null || !headerContentType.toLowerCase().contains("mpegurl")){
                throw new Exception("No es un fichero correcto");
            }

            return true;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
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
                                    .coverUrl(film.getCoverUrl())
                                    .fileUrl(film.getFileUrl())
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
