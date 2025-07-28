package com.nsteuerberg.backend.virma.persistance.repository.user;

import com.nsteuerberg.backend.virma.persistance.entity.series.UserEpisodeEntity;
import com.nsteuerberg.backend.virma.persistance.entity.series.UserEpisodeId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IUserEpisodeRepository extends JpaRepository<UserEpisodeEntity, UserEpisodeId> {

}
