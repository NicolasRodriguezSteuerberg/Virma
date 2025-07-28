package com.nsteuerberg.backend.virma.persistance.repository.user;

import com.nsteuerberg.backend.virma.persistance.entity.series.UserSerieEntity;
import com.nsteuerberg.backend.virma.persistance.entity.series.UserSerieId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IUserSerieRepository extends JpaRepository<UserSerieEntity, UserSerieId> {
}
