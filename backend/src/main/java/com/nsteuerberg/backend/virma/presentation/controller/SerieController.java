package com.nsteuerberg.backend.virma.presentation.controller;

import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.EpisodeCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.SeasonCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.SerieCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.response.PagedResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.EpisodeInfoResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.SeasonEpisodeResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.SerieInfoResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.SerieSeasonEpidoseResponse;
import jakarta.validation.Valid;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("series")
public class SerieController {
    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public PagedResponse<SerieInfoResponse> serieInfoResponsePagedResponse (Pageable pageable) {
        // ToDo por hacer
        return null;
    }

    @GetMapping("info/{id}")
    @ResponseStatus(HttpStatus.OK)
    public SerieSeasonEpidoseResponse serieSeasonEpidoseResponse (
            @PathVariable Long id
    ) {
        // ToDo recoger la info del usuario para poder mostrar si vio algun epidosdio
        return null;
    }

    @GetMapping("episode/{id}")
    @ResponseStatus(HttpStatus.OK)
    public EpisodeInfoResponse getEpisode(
            @PathVariable Long id
    ) {
        return null;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public SerieSeasonEpidoseResponse createSerie(
            @RequestBody @Valid SerieCreateRequest serieCreateRequest
    ) {
        // ToDo crear la serei
        return null;
    }

    @PostMapping("{id}/seasons")
    @ResponseStatus(HttpStatus.CREATED)
    public SeasonEpisodeResponse createSeason(
            @RequestBody @Valid SeasonCreateRequest seasonCreateRequest,
            @PathVariable(name = "id") Long serieId
    ) {
        // ToDo crear la seasaon
        return null;
    }

    @PostMapping("{serieId}/seasons/{seasonId}")
    @ResponseStatus(HttpStatus.CREATED)
    public EpisodeInfoResponse createEpisode(
            @PathVariable(name = "serieId") Long serieId,
            @PathVariable(name = "seasonId") Long seasonId,
            @RequestBody @Valid EpisodeCreateRequest episodeCreateRequest
    ){
        // ToDo crear episodio
        return null;
    }
}
