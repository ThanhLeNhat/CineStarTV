package model;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "Genres")
public class GenreDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "genreId")
    private int genreId;

    @Column(name = "genreName", nullable = false, unique = true, length = 100)
    private String genreName;

    @Column(name = "genreNameEn", length = 100)
    private String genreNameEn;

    public GenreDTO() {
    }

    public GenreDTO(String genreName, String genreNameEn) {
        this.genreName = genreName;
        this.genreNameEn = genreNameEn;
    }

    public int getGenreId() {
        return genreId;
    }

    public void setGenreId(int genreId) {
        this.genreId = genreId;
    }

    public String getGenreName() {
        return genreName;
    }

    public void setGenreName(String genreName) {
        this.genreName = genreName;
    }

    public String getGenreNameEn() {
        return genreNameEn;
    }

    public void setGenreNameEn(String genreNameEn) {
        this.genreNameEn = genreNameEn;
    }

    @Override
    public String toString() {
        return "GenreDTO{genreId=" + genreId + ", genreName=" + genreName + "}";
    }
}
