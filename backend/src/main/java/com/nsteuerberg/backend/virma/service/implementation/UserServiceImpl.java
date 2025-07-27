package com.nsteuerberg.backend.virma.service.implementation;

import com.nsteuerberg.backend.virma.persistance.entity.UserEntity;
import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmId;
import com.nsteuerberg.backend.virma.persistance.repository.movie.IUserFilmRepository;
import com.nsteuerberg.backend.virma.persistance.repository.IUserRepository;
import com.nsteuerberg.backend.virma.presentation.dto.request.FilmWatchedRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.UserCreateRequest;
import com.nsteuerberg.backend.virma.service.exceptions.UserAlreadyExistsException;
import com.nsteuerberg.backend.virma.service.interfaces.IUserService;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements IUserService {
    private final IUserRepository userRepository;
    private final IUserFilmRepository userFilmRepository;

    public UserServiceImpl(IUserRepository userRepository, IUserFilmRepository userFilmRepository) {
        this.userRepository = userRepository;
        this.userFilmRepository = userFilmRepository;
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
        UserFilmId userFilmId = new UserFilmId(userId, filmWatchedRequest.filmId());
        UserFilmEntity userFilm = userFilmRepository.findById(userFilmId).orElseGet(() -> UserFilmEntity.builder()
                        .id(userFilmId)
                .build()
        );
        userFilm.setWatchedSeconds(filmWatchedRequest.secondsWatched());
        userFilmRepository.save(userFilm);
    }
}
