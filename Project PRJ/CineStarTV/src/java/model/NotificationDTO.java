package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "Notifications")
public class NotificationDTO implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notificationId")
    private int notificationId;

    @ManyToOne
    @JoinColumn(name = "userId", nullable = false)
    private UserDTO user;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Lob
    @Column(name = "message", nullable = false)
    private String message;

    @Column(name = "type", length = 50)
    private String type = "INFO";

    @Column(name = "isRead")
    private boolean isRead = false;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "createdAt")
    private Date createdAt;

    public NotificationDTO() {
    }

    public NotificationDTO(UserDTO user, String title, String message, String type) {
        this.user = user;
        this.title = title;
        this.message = message;
        this.type = type;
        this.isRead = false;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public UserDTO getUser() {
        return user;
    }

    public void setUser(UserDTO user) {
        this.user = user;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        this.isRead = read;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Bootstrap icon theo loại thông báo
     */
    public String getIcon() {
        switch (type) {
            case "BOOKING":
                return "bi-ticket-perforated";
            case "PAYMENT":
                return "bi-credit-card";
            case "SYSTEM":
                return "bi-megaphone";
            default:
                return "bi-info-circle";
        }
    }

    @Override
    public String toString() {
        return "NotificationDTO{id=" + notificationId + ", title=" + title + "}";
    }
}
