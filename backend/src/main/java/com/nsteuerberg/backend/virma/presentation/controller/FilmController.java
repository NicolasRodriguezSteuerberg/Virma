package com.nsteuerberg.backend.virma.presentation.controller;

import com.nsteuerberg.backend.virma.presentation.dto.request.FilmCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.response.FilmUserResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.PagedResponse;
import com.nsteuerberg.backend.virma.service.implementation.CommonMediaServiceImpl;
import com.nsteuerberg.backend.virma.service.implementation.FilmServiceImpl;
import jakarta.validation.Valid;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.io.FileNotFoundException;

@RestController
@RequestMapping("movie")
public class FilmController {
    private final FilmServiceImpl filmService;
    private final CommonMediaServiceImpl commonMediaService;

    public FilmController(FilmServiceImpl filmService, CommonMediaServiceImpl commonMediaService) {
        this.filmService = filmService;
        this.commonMediaService = commonMediaService;
    }

    @PostMapping()
    @ResponseStatus(HttpStatus.ACCEPTED)
    // ToDo cambiarlo por created
    public void createFilm(@RequestBody @Valid FilmCreateRequest filmCreateRequest) throws FileNotFoundException {
        if (!commonMediaService.isUrlValid(filmCreateRequest.fileUrl())) {
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

    @GetMapping("{id}")
    @ResponseStatus(HttpStatus.OK)
    public FilmUserResponse getFilm(@PathVariable Long id) {
        // ToDo recoger el id del usario con la autenticacion
        return filmService.getFilmById(id, 1L);
    }
}
