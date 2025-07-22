package com.nsteuerberg.backend.virma.persistance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "episode")
public class EpisodeEntity {
    private Long id;
    private Integer number;
    @Column(name = "duration_seconds")
    private Integer durationSeconds;
    @Column(name = "file_url")
    private String fileUrl;
    private SeasonEntity seasonEntity;
}
