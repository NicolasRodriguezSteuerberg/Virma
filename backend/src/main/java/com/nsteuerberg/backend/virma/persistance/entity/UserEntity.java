package com.nsteuerberg.backend.virma.persistance.entity;

import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.series.UserEpisodeEntity;
import com.nsteuerberg.backend.virma.persistance.entity.series.UserSerieEntity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "users")
public class UserEntity {
    @Id
    private Long id;
    private String username;
    @Column(name = "profile_url")
    private String profileUrl;

    @OneToMany(
            mappedBy = "user",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private List<UserFilmEntity> moviesWatched = new ArrayList<>();

    @OneToMany(
            mappedBy = "user",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private List<UserSerieEntity> seriesWatched = new ArrayList<>();

    @OneToMany(
            mappedBy = "user",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private List<UserEpisodeEntity> episodeWatched = new ArrayList<>();
}
