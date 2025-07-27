package com.nsteuerberg.backend.virma.presentation.controller;

import com.nsteuerberg.backend.virma.presentation.dto.request.FilmCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.response.FilmUserResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.PagedResponse;
import com.nsteuerberg.backend.virma.service.implementation.FilmServiceImpl;
import jakarta.validation.Valid;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URI;
import java.nio.file.Paths;

@RestController
@RequestMapping("movie")
public class FilmController {
    private final FilmServiceImpl filmService;

    public FilmController(FilmServiceImpl filmService) {
        this.filmService = filmService;
    }

    @PostMapping()
    @ResponseStatus(HttpStatus.ACCEPTED)
    // ToDo cambiarlo por created
    public void createFilm(@RequestBody @Valid FilmCreateRequest filmCreateRequest) throws FileNotFoundException {
        if (!filmService.isUrlValid(filmCreateRequest.fileUrl())) {
            throw new FileNotFoundException("No existe el archivo o no pertenece al servidor");
        }
        filmService.saveFilm(filmCreateRequest);
    }

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public PagedResponse<FilmUserResponse> getFilms(Pageable pageable) {
        // ToDo recoger el id del usuario con la autenticacion
        return filmService.getPagenableFilm(pageable, 1L);
    }
}
