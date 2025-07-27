package com.nsteuerberg.backend.virma.persistance.entity.series;

import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmId;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Objects;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
public class UserSerieId {
    @Column(name = "user_id")
    private Long userId;
    @Column(name = "serie_id")
    private Long serieId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || getClass() != o.getClass())
            return false;

        UserSerieId that = (UserSerieId) o;
        return Objects.equals(userId, that.userId) &&
                Objects.equals(serieId, that.serieId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, serieId);
    }
}
