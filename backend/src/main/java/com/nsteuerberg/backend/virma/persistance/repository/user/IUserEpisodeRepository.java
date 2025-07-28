package com.nsteuerberg.backend.virma.persistance.repository.user;

import com.nsteuerberg.backend.virma.persistance.entity.series.UserEpisodeEntity;
import com.nsteuerberg.backend.virma.persistance.entity.series.UserEpisodeId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IUserEpisodeRepository extends JpaRepository<UserEpisodeEntity, UserEpisodeId> {
    @Query("""
        SELECT ue FROM UserEpisodeEntity ue
        JOIN FETCH ue.episode e
        JOIN e.season s
        WHERE ue.user.id = :userId AND s.serie.id = :serieId
    """)
    List<UserEpisodeEntity> findByUserIdAndSerieId(@Param("userId") Long userId, @Param("serieId") Long serieId);

}
