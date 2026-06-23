package model;

import java.io.Serializable;
import java.util.Objects;

/**
 * Composite key cho MovieGenreDTO (movieId + genreId)
 */
public class MovieGenreId implements Serializable {

    private int movieId;
    private int genreId;

    public MovieGenreId() {
    }

    public MovieGenreId(int movieId, int genreId) {
        this.movieId = movieId;
        this.genreId = genreId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getGenreId() {
        return genreId;
    }

    public void setGenreId(int genreId) {
        this.genreId = genreId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MovieGenreId that = (MovieGenreId) o;
        return movieId == that.movieId && genreId == that.genreId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(movieId, genreId);
    }
}
