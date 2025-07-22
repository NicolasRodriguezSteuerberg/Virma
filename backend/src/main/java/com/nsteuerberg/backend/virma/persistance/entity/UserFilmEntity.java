package com.nsteuerberg.backend.virma.persistance.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "user_film")
public class UserFilmEntity {
    @EmbeddedId
    private UserFilmId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userId")
    private UserEntity userEntity;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("filmId")
    private FilmEntity filmEntity;
    private Boolean finished;
    @Column(name = "wathched_seconds")
    private Integer watchedSeconds;
}
