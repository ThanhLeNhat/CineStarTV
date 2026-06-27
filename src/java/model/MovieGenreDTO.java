package model;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "MovieGenres")
@IdClass(MovieGenreId.class)
public class MovieGenreDTO implements Serializable {

    @Id
    @Column(name = "movieId")
    private int movieId;

    @Id
    @Column(name = "genreId")
    private int genreId;

    @ManyToOne
    @JoinColumn(name = "movieId", insertable = false, updatable = false)
    private MovieDTO movie;

    @ManyToOne
    @JoinColumn(name = "genreId", insertable = false, updatable = false)
    private GenreDTO genre;

    public MovieGenreDTO() {
    }

    public MovieGenreDTO(int movieId, int genreId) {
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

    public MovieDTO getMovie() {
        return movie;
    }

    public void setMovie(MovieDTO movie) {
        this.movie = movie;
    }

    public GenreDTO getGenre() {
        return genre;
    }

    public void setGenre(GenreDTO genre) {
        this.genre = genre;
    }

    @Override
    public String toString() {
        return "MovieGenreDTO{movieId=" + movieId + ", genreId=" + genreId + "}";
    }
}
