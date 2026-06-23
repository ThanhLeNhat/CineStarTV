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
import javax.persistence.UniqueConstraint;

@Entity
@Table(name = "BookingDetails", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"bookingId", "seatId"})
})
public class BookingDetailDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "detailId")
    private int detailId;

    @ManyToOne
    @JoinColumn(name = "bookingId", nullable = false)
    private BookingDTO booking;

    @ManyToOne
    @JoinColumn(name = "seatId", nullable = false)
    private SeatDTO seat;

    @Column(name = "price", nullable = false)
    private long price;

    @Column(name = "seatLabel", length = 10)
    private String seatLabel;

    public BookingDetailDTO() {
    }

    public BookingDetailDTO(BookingDTO booking, SeatDTO seat, long price, String seatLabel) {
        this.booking = booking;
        this.seat = seat;
        this.price = price;
        this.seatLabel = seatLabel;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public BookingDTO getBooking() {
        return booking;
    }

    public void setBooking(BookingDTO booking) {
        this.booking = booking;
    }

    public SeatDTO getSeat() {
        return seat;
    }

    public void setSeat(SeatDTO seat) {
        this.seat = seat;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public String getSeatLabel() {
        return seatLabel;
    }

    public void setSeatLabel(String seatLabel) {
        this.seatLabel = seatLabel;
    }

    @Override
    public String toString() {
        return "BookingDetailDTO{seat=" + seatLabel + ", price=" + price + "}";
    }
}
