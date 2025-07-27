package com.nsteuerberg.backend.virma.persistance.repository.series;

import com.nsteuerberg.backend.virma.persistance.entity.series.EpisodeEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IEpisodeRepository extends JpaRepository<EpisodeEntity, Long> {

}
