package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class PaymentDAO implements IDAO<PaymentDTO, Integer> {

    public PaymentDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(PaymentDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(PaymentDTO t) {
        return executeInTransaction(em -> {
            PaymentDTO p = em.find(PaymentDTO.class, t.getPaymentId());
            if (p == null) throw new RuntimeException("Payment not found");
            em.remove(p);
        });
    }
    public boolean update(PaymentDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<PaymentDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT p FROM PaymentDTO p ORDER BY p.createdAt DESC", PaymentDTO.class).getResultList());
        } finally { em.close(); }
    }

    public PaymentDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(PaymentDTO.class, id); } finally { em.close(); }
    }

    public PaymentDTO searchByTransactionId(String transactionId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM PaymentDTO p WHERE p.transactionId = :tid", PaymentDTO.class)
                    .setParameter("tid", transactionId).getSingleResult();
        } catch (Exception e) { return null; } finally { em.close(); }
    }

    public PaymentDTO searchByBookingId(int bookingId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM PaymentDTO p WHERE p.booking.bookingId = :bid ORDER BY p.createdAt DESC", PaymentDTO.class)
                    .setParameter("bid", bookingId).setMaxResults(1).getSingleResult();
        } catch (Exception e) { return null; } finally { em.close(); }
    }
}
