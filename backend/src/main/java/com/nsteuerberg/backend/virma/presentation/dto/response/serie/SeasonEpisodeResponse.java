package com.nsteuerberg.backend.virma.presentation.dto.response.serie;

import java.util.List;

public record SeasonEpisodeResponse (
        Long id,
        Integer number,
        List<EpisodeInfoResponse> episodeList
){
}
