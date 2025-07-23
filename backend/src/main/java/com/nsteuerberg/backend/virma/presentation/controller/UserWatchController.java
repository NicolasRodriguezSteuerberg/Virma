package com.nsteuerberg.backend.virma.presentation.controller;

import com.nsteuerberg.backend.virma.presentation.dto.request.FilmWatchedRequest;
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

    @PostMapping("film")
    @ResponseStatus(HttpStatus.OK)
    public void addFilmWatched(@RequestBody FilmWatchedRequest filmWatchedRequest) {
        // ToDo cambiar para cuando haya autenticacion
        userService.filmWatched(filmWatchedRequest, 1L);
    }
}
