package com.nsteuerberg.backend.virma.persistance.repository.series;

import com.nsteuerberg.backend.virma.persistance.entity.series.SerieEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ISerieRepository extends JpaRepository<SerieEntity, Long> {
    Page<SerieEntity> findAll(Pageable pageable);

    Page<SerieEntity> findBYTitlteContainingIgnoreCase(String title, Pageable pageable);
}
