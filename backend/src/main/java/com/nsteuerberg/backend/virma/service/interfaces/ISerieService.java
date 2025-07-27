package com.nsteuerberg.backend.virma.service.interfaces;

import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.EpisodeCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.SeasonCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.SerieCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.response.PagedResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.EpisodeInfoResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.SeasonEpisodeResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.SerieInfoResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.SerieSeasonEpidoseResponse;
import org.springframework.data.domain.Pageable;

public interface ISerieService {
    PagedResponse<SerieInfoResponse> getPageableSerieInfo(Pageable pageable);
    SerieSeasonEpidoseResponse getSerieCompleteInfo(Long serieId);
    EpisodeInfoResponse getEpisode(Long episodeId);
    SerieSeasonEpidoseResponse createSerie(SerieCreateRequest serieCreateRequest);
    SeasonEpisodeResponse createSeason(Long serieId, SeasonCreateRequest seasonCreateRequest);
    EpisodeInfoResponse createEpisode(Long serieId, Long seasonId, EpisodeCreateRequest episodeCreateRequest);
}
