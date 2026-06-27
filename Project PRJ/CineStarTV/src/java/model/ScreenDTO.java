package model;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Screens")
public class ScreenDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "screenId")
    private int screenId;

    @ManyToOne
    @JoinColumn(name = "cinemaId", nullable = false)
    private CinemaDTO cinema;

    @Column(name = "screenName", nullable = false, length = 50)
    private String screenName;

    @Column(name = "screenType", length = 20)
    private String screenType = "2D";

    @Column(name = "capacity")
    private int capacity;

    @Column(name = "status", length = 20)
    private String status = "ACTIVE";

    public ScreenDTO() {
    }

    public int getScreenId() {
        return screenId;
    }

    public void setScreenId(int screenId) {
        this.screenId = screenId;
    }

    public CinemaDTO getCinema() {
        return cinema;
    }

    public void setCinema(CinemaDTO cinema) {
        this.cinema = cinema;
    }

    public String getScreenName() {
        return screenName;
    }

    public void setScreenName(String screenName) {
        this.screenName = screenName;
    }

    public String getScreenType() {
        return screenType;
    }

    public void setScreenType(String screenType) {
        this.screenType = screenType;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * "Phòng 1 (IMAX)"
     */
    public String getFullName() {
        return screenName + " (" + screenType + ")";
    }

    @Override
    public String toString() {
        return "ScreenDTO{screenId=" + screenId + ", screenName=" + screenName + ", type=" + screenType + "}";
    }
}
