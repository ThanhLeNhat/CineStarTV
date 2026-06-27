package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class NotificationDAO implements IDAO<NotificationDTO, Integer> {

    public NotificationDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(NotificationDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(NotificationDTO t) {
        return executeInTransaction(em -> {
            NotificationDTO n = em.find(NotificationDTO.class, t.getNotificationId());
            if (n == null) throw new RuntimeException("Notification not found");
            em.remove(n);
        });
    }
    public boolean update(NotificationDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<NotificationDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT n FROM NotificationDTO n ORDER BY n.createdAt DESC", NotificationDTO.class).getResultList());
        } finally { em.close(); }
    }

    public NotificationDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(NotificationDTO.class, id); } finally { em.close(); }
    }

    public ArrayList<NotificationDTO> listByUserId(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT n FROM NotificationDTO n WHERE n.user.userId = :uid ORDER BY n.createdAt DESC",
                    NotificationDTO.class).setParameter("uid", userId).getResultList());
        } finally { em.close(); }
    }

    public long countUnread(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(n) FROM NotificationDTO n WHERE n.user.userId = :uid AND n.isRead = false",
                    Long.class).setParameter("uid", userId).getSingleResult();
        } finally { em.close(); }
    }

    public boolean markAsRead(int notificationId) {
        return executeInTransaction(em -> {
            NotificationDTO n = em.find(NotificationDTO.class, notificationId);
            if (n != null) n.setRead(true);
        });
    }

    public boolean markAllAsRead(int userId) {
        return executeInTransaction(em -> {
            em.createQuery("UPDATE NotificationDTO n SET n.isRead = true WHERE n.user.userId = :uid")
                    .setParameter("uid", userId).executeUpdate();
        });
    }
}
