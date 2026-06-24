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
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "Payments")
public class PaymentDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "paymentId")
    private int paymentId;

    @ManyToOne
    @JoinColumn(name = "bookingId", nullable = false)
    private BookingDTO booking;

    @Column(name = "paymentMethod", nullable = false, length = 50)
    private String paymentMethod = "VNPAY";

    @Column(name = "transactionId", length = 100)
    private String transactionId;

    @Column(name = "amount", nullable = false)
    private long amount;

    @Column(name = "status", length = 20)
    private String status = "PENDING";

    @Column(name = "vnpayResponseCode", length = 10)
    private String vnpayResponseCode;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "paidAt")
    private Date paidAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "createdAt")
    private Date createdAt;

    public PaymentDTO() {
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public BookingDTO getBooking() {
        return booking;
    }

    public void setBooking(BookingDTO booking) {
        this.booking = booking;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public long getAmount() {
        return amount;
    }

    public void setAmount(long amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getVnpayResponseCode() {
        return vnpayResponseCode;
    }

    public void setVnpayResponseCode(String vnpayResponseCode) {
        this.vnpayResponseCode = vnpayResponseCode;
    }

    public Date getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Date paidAt) {
        this.paidAt = paidAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isSuccess() {
        return "SUCCESS".equals(status);
    }


    @PrePersist
    protected void onCreate() {
        if (createdAt == null) createdAt = new java.util.Date();
    }

    @Override
    public String toString() {
        return "PaymentDTO{id=" + paymentId + ", method=" + paymentMethod + ", status=" + status + "}";
    }
}