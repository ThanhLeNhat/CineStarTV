package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.PrePersist;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "Vouchers")
public class VoucherDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "voucherId")
    private int voucherId;

    @Column(name = "code", nullable = false, unique = true, length = 50)
    private String code;

    @Column(name = "discountPercent")
    private int discountPercent;

    @Column(name = "discountAmount")
    private long discountAmount;

    @Column(name = "maxDiscount")
    private Long maxDiscount;

    @Column(name = "minOrder")
    private long minOrder;

    @Column(name = "quantity")
    private int quantity;

    @Column(name = "usedCount")
    private int usedCount;

    @Temporal(TemporalType.DATE)
    @Column(name = "startDate", nullable = false)
    private Date startDate;

    @Temporal(TemporalType.DATE)
    @Column(name = "endDate", nullable = false)
    private Date endDate;

    @Column(name = "status", length = 20)
    private String status = "ACTIVE";

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "createdAt")
    private Date createdAt;

    public VoucherDTO() {
    }

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public long getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(long discountAmount) {
        this.discountAmount = discountAmount;
    }

    public Long getMaxDiscount() {
        return maxDiscount;
    }

    public void setMaxDiscount(Long maxDiscount) {
        this.maxDiscount = maxDiscount;
    }

    public long getMinOrder() {
        return minOrder;
    }

    public void setMinOrder(long minOrder) {
        this.minOrder = minOrder;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getUsedCount() {
        return usedCount;
    }

    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
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

    public int getRemainingQuantity() {
        return quantity - usedCount;
    }

    public boolean isValid() {
        Date now = new Date();
        return "ACTIVE".equals(status)
                && usedCount < quantity
                && !now.before(startDate)
                && !now.after(endDate);
    }

    public long calculateDiscount(long orderAmount) {
        if (orderAmount < minOrder) {
            return 0;
        }
        long discount;
        if (discountPercent > 0) {
            discount = orderAmount * discountPercent / 100;
            if (maxDiscount != null && discount > maxDiscount) {
                discount = maxDiscount;
            }
        } else {
            discount = discountAmount;
        }
        return Math.min(discount, orderAmount);
    }


    @PrePersist
    protected void onCreate() {
        if (createdAt == null) createdAt = new java.util.Date();
    }

    @Override
    public String toString() {
        return "VoucherDTO{code=" + code + ", status=" + status + "}";
    }
}