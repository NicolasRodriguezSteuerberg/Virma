package com.nsteuerberg.backend.virma.persistance.entity.series;

import com.nsteuerberg.backend.virma.persistance.entity.movies.UserFilmId;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Objects;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Embeddable
public class UserEpisodeId {
    @Column(name = "user_id")
    private Long userId;
    @Column(name = "episode_id")
    private Long episodeId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || getClass() != o.getClass())
            return false;

        UserEpisodeId that = (UserEpisodeId) o;
        return Objects.equals(userId, that.userId) &&
                Objects.equals(episodeId, that.episodeId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, episodeId);
    }
}
