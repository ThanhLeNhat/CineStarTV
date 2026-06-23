package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class SeatDAO implements IDAO<SeatDTO, Integer> {

    public SeatDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(SeatDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(SeatDTO t) {
        return executeInTransaction(em -> {
            SeatDTO s = em.find(SeatDTO.class, t.getSeatId());
            if (s == null) throw new RuntimeException("Seat not found");
            em.remove(s);
        });
    }
    public boolean update(SeatDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<SeatDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT s FROM SeatDTO s", SeatDTO.class).getResultList());
        } finally { em.close(); }
    }

    public SeatDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(SeatDTO.class, id); } finally { em.close(); }
    }

    public ArrayList<SeatDTO> listByScreenId(int screenId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT s FROM SeatDTO s WHERE s.screen.screenId = :sid ORDER BY s.seatRow, s.seatNumber",
                    SeatDTO.class)
                    .setParameter("sid", screenId).getResultList());
        } finally { em.close(); }
    }

    /**
     * Lấy danh sách seatId đã được đặt cho 1 suất chiếu cụ thể
     */
    public ArrayList<Integer> listBookedSeatIds(int showtimeId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT bd.seat.seatId FROM BookingDetailDTO bd " +
                    "WHERE bd.booking.showtime.showtimeId = :stid " +
                    "AND bd.booking.status IN ('CONFIRMED', 'PENDING')",
                    Integer.class)
                    .setParameter("stid", showtimeId).getResultList());
        } finally { em.close(); }
    }

    /**
     * Thêm hàng loạt ghế cho 1 phòng chiếu
     */
    public boolean addBulk(ArrayList<SeatDTO> seats) {
        return executeInTransaction(em -> {
            for (SeatDTO seat : seats) {
                em.persist(seat);
            }
        });
    }
}
