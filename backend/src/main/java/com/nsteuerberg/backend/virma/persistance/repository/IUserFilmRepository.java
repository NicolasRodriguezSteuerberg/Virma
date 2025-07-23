package com.nsteuerberg.backend.virma.persistance.repository;

import com.nsteuerberg.backend.virma.persistance.entity.FilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.UserFilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.UserFilmId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IUserFilmRepository extends JpaRepository<UserFilmEntity, UserFilmId> {
    List<UserFilmEntity> findByUserIdAndFilmIn(Long userId, List<FilmEntity> films);
}
