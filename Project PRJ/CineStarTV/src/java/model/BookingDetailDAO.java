package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class BookingDetailDAO implements IDAO<BookingDetailDTO, Integer> {

    public BookingDetailDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(BookingDetailDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(BookingDetailDTO t) {
        return executeInTransaction(em -> {
            BookingDetailDTO bd = em.find(BookingDetailDTO.class, t.getDetailId());
            if (bd == null) throw new RuntimeException("BookingDetail not found");
            em.remove(bd);
        });
    }
    public boolean update(BookingDetailDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<BookingDetailDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT bd FROM BookingDetailDTO bd", BookingDetailDTO.class).getResultList());
        } finally { em.close(); }
    }

    public BookingDetailDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(BookingDetailDTO.class, id); } finally { em.close(); }
    }

    public ArrayList<BookingDetailDTO> listByBookingId(int bookingId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT bd FROM BookingDetailDTO bd WHERE bd.booking.bookingId = :bid", BookingDetailDTO.class)
                    .setParameter("bid", bookingId).getResultList());
        } finally { em.close(); }
    }
}
