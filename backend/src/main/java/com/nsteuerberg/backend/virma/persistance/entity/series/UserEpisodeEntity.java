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
// ToDo hacer el userepisode
/*
@Entity
@Table(name = "user_episode")
 */
public class UserEpisodeEntity {
    @EmbeddedId
    private UserEpisodeId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userId")
    private UserEntity user;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("episodeId")
    private EpisodeEntity episode;

    @Column(name = "watched_seconds")
    private Integer watchedSeconds;
}
