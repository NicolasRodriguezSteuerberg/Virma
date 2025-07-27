package com.nsteuerberg.backend.virma.persistance.entity.movies;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
public class UserFilmId implements Serializable {
    @Column(name = "user_id")
    private Long userId;
    @Column(name = "film_id")
    private Long filmId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || getClass() != o.getClass())
            return false;

        UserFilmId that = (UserFilmId) o;
        return Objects.equals(userId, that.userId) &&
                Objects.equals(filmId, that.filmId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, filmId);
    }
}
