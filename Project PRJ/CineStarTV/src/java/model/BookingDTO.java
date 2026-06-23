package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "Bookings")
public class BookingDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "bookingId")
    private int bookingId;

    @ManyToOne
    @JoinColumn(name = "userId", nullable = false)
    private UserDTO user;

    @ManyToOne
    @JoinColumn(name = "showtimeId", nullable = false)
    private ShowtimeDTO showtime;

    @ManyToOne
    @JoinColumn(name = "voucherId")
    private VoucherDTO voucher;

    @Column(name = "totalAmount", nullable = false)
    private long totalAmount;

    @Column(name = "discountAmount")
    private long discountAmount;

    @Column(name = "finalAmount", nullable = false)
    private long finalAmount;

    @Column(name = "bookingCode", nullable = false, unique = true, length = 20)
    private String bookingCode;

    @Column(name = "status", length = 20)
    private String status = "PENDING";

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "createdAt")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updatedAt")
    private Date updatedAt;

    @OneToMany(mappedBy = "booking", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<BookingDetailDTO> details;

    public BookingDTO() {
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public UserDTO getUser() {
        return user;
    }

    public void setUser(UserDTO user) {
        this.user = user;
    }

    public ShowtimeDTO getShowtime() {
        return showtime;
    }

    public void setShowtime(ShowtimeDTO showtime) {
        this.showtime = showtime;
    }

    public VoucherDTO getVoucher() {
        return voucher;
    }

    public void setVoucher(VoucherDTO voucher) {
        this.voucher = voucher;
    }

    public long getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(long totalAmount) {
        this.totalAmount = totalAmount;
    }

    public long getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(long discountAmount) {
        this.discountAmount = discountAmount;
    }

    public long getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(long finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
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

    public List<BookingDetailDTO> getDetails() {
        return details;
    }

    public void setDetails(List<BookingDetailDTO> details) {
        this.details = details;
    }

    public boolean isConfirmed() {
        return "CONFIRMED".equals(status);
    }

    public boolean isPending() {
        return "PENDING".equals(status);
    }

    @Override
    public String toString() {
        return "BookingDTO{code=" + bookingCode + ", status=" + status + ", amount=" + finalAmount + "}";
    }
}
