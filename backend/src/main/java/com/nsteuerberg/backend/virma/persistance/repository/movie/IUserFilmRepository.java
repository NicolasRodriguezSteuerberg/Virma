package com.nsteuerberg.backend.virma.persistance.repository.movie;

import com.nsteuerberg.backend.virma.persistance.entity.movies.FilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmEntity;
import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IUserFilmRepository extends JpaRepository<UserFilmEntity, UserFilmId> {
    List<UserFilmEntity> findByUserIdAndFilmIn(Long userId, List<FilmEntity> films);
}
