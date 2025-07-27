package com.nsteuerberg.backend.virma.service.implementation;

import com.nsteuerberg.backend.virma.persistance.repository.series.ISerieRepository;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.EpisodeCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.SeasonCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.request.serie.create.SerieCreateRequest;
import com.nsteuerberg.backend.virma.presentation.dto.response.PagedResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.EpisodeInfoResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.SeasonEpisodeResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.SerieInfoResponse;
import com.nsteuerberg.backend.virma.presentation.dto.response.serie.SerieSeasonEpidoseResponse;
import com.nsteuerberg.backend.virma.service.interfaces.ISerieService;
import org.springframework.data.domain.Pageable;

public class SerieServiceImpl implements ISerieService {

    private final ISerieRepository serieRepository;

    public SerieServiceImpl(ISerieRepository serieRepository) {
        this.serieRepository = serieRepository;
    }

    @Override
    public PagedResponse<SerieInfoResponse> getPageableSerieInfo(Pageable pageable) {
        return null;
    }

    @Override
    public SerieSeasonEpidoseResponse getSerieCompleteInfo(Long serieId) {
        return null;
    }

    @Override
    public EpisodeInfoResponse getEpisode(Long episodeId) {
        return null;
    }

    @Override
    public SerieSeasonEpidoseResponse createSerie(SerieCreateRequest serieCreateRequest) {
        return null;
    }

    @Override
    public SeasonEpisodeResponse createSeason(Long serieId, SeasonCreateRequest seasonCreateRequest) {
        return null;
    }

    @Override
    public EpisodeInfoResponse createEpisode(Long serieId, Long seasonId, EpisodeCreateRequest episodeCreateRequest) {
        return null;
    }
}
