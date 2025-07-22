package com.nsteuerberg.backend.virma.presentation.controller;

import com.nsteuerberg.backend.virma.presentation.dto.request.FilmCreateRequest;
import com.nsteuerberg.backend.virma.service.implementation.FilmServiceImpl;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
@RequestMapping("film")
public class FilmController {
    private final FilmServiceImpl filmService;

    public FilmController(FilmServiceImpl filmService) {
        this.filmService = filmService;
    }

    @PostMapping("")
    @ResponseStatus(HttpStatus.ACCEPTED)
    // ToDo cambiarlo por created
    public void createFilm(@RequestBody @Valid FilmCreateRequest filmCreateRequest) throws FileNotFoundException {
        File filmFile = Paths.get(filmCreateRequest.fileUrl()).toFile();
        if (!filmFile.exists() || !filmFile.isFile() || filmFile.getName().endsWith("m3u8")) {
            throw new FileNotFoundException("No existe el archivo de la pelicula o no es valido");
        }
        filmService.saveFilm(filmCreateRequest);
    }

}
