package com.nsteuerberg.backend.virma.presentation.dto.response.serie;

import java.util.List;

public record SerieSeasonEpidoseResponse(
        SerieInfoResponse serieInfo,
        List<SeasonEpisodeResponse> seasonList
) {
}
