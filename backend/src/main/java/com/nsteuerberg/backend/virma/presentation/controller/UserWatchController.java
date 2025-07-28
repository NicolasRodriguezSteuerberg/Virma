package com.nsteuerberg.backend.virma.presentation.controller;

import com.nsteuerberg.backend.virma.presentation.dto.request.FilmWatchedRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.EpisodeWatchedRequest;
import com.nsteuerberg.backend.virma.service.implementation.UserServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("watch")
public class UserWatchController {
    private final UserServiceImpl userService;

    public UserWatchController(UserServiceImpl userService) {
        this.userService = userService;
    }

    @PostMapping("movie")
    @ResponseStatus(HttpStatus.OK)
    public void addFilmWatched(@RequestBody FilmWatchedRequest filmWatchedRequest) {
        // ToDo cambiar para cuando haya autenticacion
        userService.filmWatched(filmWatchedRequest, 1L);
    }

    @PostMapping("episode")
    @ResponseStatus(HttpStatus.OK)
    public void addEpisodeWatched(@RequestBody EpisodeWatchedRequest episodeWatchedRequest) {
        // ToDo recoger el id del usuario autenticado
        userService.episodeWatched(1L, episodeWatchedRequest);
    }
}
