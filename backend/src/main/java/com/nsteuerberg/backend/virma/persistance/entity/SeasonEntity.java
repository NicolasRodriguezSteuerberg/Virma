package com.nsteuerberg.backend.virma.persistance.entity;

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
@Table(name = "season")
public class SeasonEntity {
    private Long id;
    private SerieEntity serieEntity;
    private int number;
}
