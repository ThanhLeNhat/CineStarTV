package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class BookingDAO implements IDAO<BookingDTO, Integer> {

    public BookingDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(BookingDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(BookingDTO t) {
        return executeInTransaction(em -> {
            BookingDTO b = em.find(BookingDTO.class, t.getBookingId());
            if (b == null) throw new RuntimeException("Booking not found");
            b.setStatus("CANCELLED");
        });
    }
    public boolean update(BookingDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<BookingDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT b FROM BookingDTO b ORDER BY b.createdAt DESC", BookingDTO.class).getResultList());
        } finally { em.close(); }
    }

    public BookingDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(BookingDTO.class, id); } finally { em.close(); }
    }

    public BookingDTO searchByCode(String bookingCode) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT b FROM BookingDTO b WHERE b.bookingCode = :code", BookingDTO.class)
                    .setParameter("code", bookingCode).getSingleResult();
        } catch (Exception e) { return null; } finally { em.close(); }
    }

    public ArrayList<BookingDTO> listByUserId(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT b FROM BookingDTO b WHERE b.user.userId = :uid ORDER BY b.createdAt DESC",
                    BookingDTO.class).setParameter("uid", userId).getResultList());
        } finally { em.close(); }
    }

    public long countAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.createQuery("SELECT COUNT(b) FROM BookingDTO b", Long.class).getSingleResult(); }
        finally { em.close(); }
    }

    public long sumRevenue() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Long sum = em.createQuery(
                    "SELECT SUM(b.finalAmount) FROM BookingDTO b WHERE b.status = 'CONFIRMED'", Long.class)
                    .getSingleResult();
            return sum != null ? sum : 0;
        } finally { em.close(); }
    }

    /**
     * Tạo mã booking tự động: CST-000001, CST-000002, ...
     */
    public String generateBookingCode() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            long count = em.createQuery("SELECT COUNT(b) FROM BookingDTO b", Long.class).getSingleResult();
            return String.format("CST-%06d", count + 1);
        } finally { em.close(); }
    }
}
