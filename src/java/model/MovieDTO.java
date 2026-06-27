package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;

@Entity
@Table(name = "Movies")
public class MovieDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "movieId")
    private int movieId;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "titleEn", length = 255)
    private String titleEn;

    @Lob
    @Column(name = "description")
    private String description;

    @Column(name = "posterUrl", length = 500)
    private String posterUrl;

    @Column(name = "trailerUrl", length = 500)
    private String trailerUrl;

    @Column(name = "duration", nullable = false)
    private int duration;

    @Temporal(TemporalType.DATE)
    @Column(name = "releaseDate")
    private Date releaseDate;

    @Temporal(TemporalType.DATE)
    @Column(name = "endDate")
    private Date endDate;

    @Column(name = "director", length = 100)
    private String director;

    @Column(name = "actors", length = 500)
    private String actors;

    @Column(name = "rating")
    private double rating;

    @Column(name = "ratingCount")
    private int ratingCount;

    @Column(name = "ageRating", length = 10)
    private String ageRating = "P";

    @Column(name = "language", length = 50)
    private String language = "Phụ đề";

    @Column(name = "status", length = 20)
    private String status = "NOW_SHOWING";

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "createdAt")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updatedAt")
    private Date updatedAt;

    public MovieDTO() {
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitleEn() {
        return titleEn;
    }

    public void setTitleEn(String titleEn) {
        this.titleEn = titleEn;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }

    public String getTrailerUrl() {
        return trailerUrl;
    }

    public void setTrailerUrl(String trailerUrl) {
        this.trailerUrl = trailerUrl;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getActors() {
        return actors;
    }

    public void setActors(String actors) {
        this.actors = actors;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getRatingCount() {
        return ratingCount;
    }

    public void setRatingCount(int ratingCount) {
        this.ratingCount = ratingCount;
    }

    public String getAgeRating() {
        return ageRating;
    }

    public void setAgeRating(String ageRating) {
        this.ageRating = ageRating;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    /**
     * Thời lượng dạng "2h 15m"
     */
    public String getDurationFormatted() {
        int h = duration / 60;
        int m = duration % 60;
        return h > 0 ? h + "h " + m + "m" : m + "m";
    }

    public boolean isNowShowing() {
        return "NOW_SHOWING".equals(status);
    }

    public boolean isComingSoon() {
        return "COMING_SOON".equals(status);
    }

    @Override
    public String toString() {
        return "MovieDTO{movieId=" + movieId + ", title=" + title + "}";
    }

    @PrePersist
    protected void onCreate() {
        createdAt = new java.util.Date();
        updatedAt = new java.util.Date();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = new java.util.Date();
    }
}
