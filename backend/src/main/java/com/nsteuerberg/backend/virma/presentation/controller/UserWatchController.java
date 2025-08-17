package com.nsteuerberg.backend.virma.presentation.controller;

import com.nsteuerberg.backend.virma.presentation.dto.request.FilmWatchedRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.EpisodeWatchedRequest;
import com.nsteuerberg.backend.virma.service.implementation.UserServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
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
    public void addFilmWatched(
            @RequestBody FilmWatchedRequest filmWatchedRequest,
            Authentication authentication
    ) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        userService.filmWatched(filmWatchedRequest, userId);
    }

    @PostMapping("episode")
    @ResponseStatus(HttpStatus.OK)
    public void addEpisodeWatched(
            @RequestBody EpisodeWatchedRequest episodeWatchedRequest,
            Authentication authentication
    ) {
        Long userId = Long.parseLong(authentication.getPrincipal().toString());
        userService.episodeWatched(userId, episodeWatchedRequest);
    }
}
