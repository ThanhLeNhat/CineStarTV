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
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;

@Entity
@Table(name = "Seats", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"screenId", "seatRow", "seatNumber"})
})
public class SeatDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "seatId")
    private int seatId;

    @ManyToOne
    @JoinColumn(name = "screenId", nullable = false)
    private ScreenDTO screen;

    @Column(name = "seatRow", nullable = false, length = 5)
    private String seatRow;

    @Column(name = "seatNumber", nullable = false)
    private int seatNumber;

    @Column(name = "seatType", length = 20)
    private String seatType = "STANDARD";

    @Column(name = "status", length = 20)
    private String status = "ACTIVE";

    @Transient
    private boolean booked;

    public SeatDTO() {
    }

    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public ScreenDTO getScreen() {
        return screen;
    }

    public void setScreen(ScreenDTO screen) {
        this.screen = screen;
    }

    public String getSeatRow() {
        return seatRow;
    }

    public void setSeatRow(String seatRow) {
        this.seatRow = seatRow;
    }

    public int getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(int seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getSeatType() {
        return seatType;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isBooked() {
        return booked;
    }

    public void setBooked(boolean booked) {
        this.booked = booked;
    }

    /**
     * Nhãn ghế: "A5", "B3"
     */
    public String getLabel() {
        return seatRow + seatNumber;
    }

    /**
     * Hệ số giá theo loại ghế
     */
    public double getPriceMultiplier() {
        switch (seatType) {
            case "VIP":
                return 1.3;
            case "SWEETBOX":
                return 1.6;
            default:
                return 1.0;
        }
    }

    @Override
    public String toString() {
        return "SeatDTO{" + getLabel() + ", type=" + seatType + "}";
    }
}
