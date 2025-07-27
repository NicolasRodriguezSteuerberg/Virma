package com.nsteuerberg.backend.virma.persistance.entity.series;

import com.nsteuerberg.backend.virma.persistance.entity.UserEntity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
/* ToDO hacer el userSerie
@Entity
@Table(name = "user_serie")
 */
public class UserSerieEntity {
    @EmbeddedId
    private UserSerieId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userId")
    private UserEntity user;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("serieId")
    private SerieEntity serie;

    private Boolean liked;
    @Column(name = "last_episode_id")
    private Long lastEpisodeId;
    @Column(name = "last_time_watched")
    private String lastTimeWatched;
}
