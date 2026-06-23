package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

@Entity
@Table(name = "Showtimes")
public class ShowtimeDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "showtimeId")
    private int showtimeId;

    @ManyToOne
    @JoinColumn(name = "movieId", nullable = false)
    private MovieDTO movie;

    @ManyToOne
    @JoinColumn(name = "screenId", nullable = false)
    private ScreenDTO screen;

    @Temporal(TemporalType.DATE)
    @Column(name = "showDate", nullable = false)
    private Date showDate;

    @Column(name = "startTime", nullable = false, length = 8)
    private String startTime;

    @Column(name = "endTime", nullable = false, length = 8)
    private String endTime;

    @Column(name = "basePrice", nullable = false)
    private long basePrice = 75000;

    @Column(name = "status", length = 20)
    private String status = "ACTIVE";

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "createdAt")
    private Date createdAt;

    @Transient
    private int availableSeats;

    public ShowtimeDTO() {
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }

    public MovieDTO getMovie() {
        return movie;
    }

    public void setMovie(MovieDTO movie) {
        this.movie = movie;
    }

    public ScreenDTO getScreen() {
        return screen;
    }

    public void setScreen(ScreenDTO screen) {
        this.screen = screen;
    }

    public Date getShowDate() {
        return showDate;
    }

    public void setShowDate(Date showDate) {
        this.showDate = showDate;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public long getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(long basePrice) {
        this.basePrice = basePrice;
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

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }

    @Override
    public String toString() {
        return "ShowtimeDTO{id=" + showtimeId + ", date=" + showDate + ", time=" + startTime + "}";
    }
}
