package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class ReviewDAO implements IDAO<ReviewDTO, Integer> {

    public ReviewDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(ReviewDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(ReviewDTO t) {
        return executeInTransaction(em -> {
            ReviewDTO r = em.find(ReviewDTO.class, t.getReviewId());
            if (r == null) throw new RuntimeException("Review not found");
            r.setStatus("HIDDEN");
        });
    }
    public boolean update(ReviewDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<ReviewDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT r FROM ReviewDTO r ORDER BY r.createdAt DESC", ReviewDTO.class).getResultList());
        } finally { em.close(); }
    }

    public ReviewDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(ReviewDTO.class, id); } finally { em.close(); }
    }

    public ArrayList<ReviewDTO> listByMovieId(int movieId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT r FROM ReviewDTO r WHERE r.movie.movieId = :mid AND r.status = 'ACTIVE' ORDER BY r.createdAt DESC",
                    ReviewDTO.class).setParameter("mid", movieId).getResultList());
        } finally { em.close(); }
    }

    public ReviewDTO searchByUserAndMovie(int userId, int movieId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT r FROM ReviewDTO r WHERE r.user.userId = :uid AND r.movie.movieId = :mid",
                    ReviewDTO.class)
                    .setParameter("uid", userId).setParameter("mid", movieId).getSingleResult();
        } catch (Exception e) { return null; } finally { em.close(); }
    }

    public double getAverageRating(int movieId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Double avg = em.createQuery(
                    "SELECT AVG(r.rating) FROM ReviewDTO r WHERE r.movie.movieId = :mid AND r.status = 'ACTIVE'",
                    Double.class).setParameter("mid", movieId).getSingleResult();
            return avg != null ? avg : 0;
        } finally { em.close(); }
    }

    public int countByMovieId(int movieId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(r) FROM ReviewDTO r WHERE r.movie.movieId = :mid AND r.status = 'ACTIVE'",
                    Long.class).setParameter("mid", movieId).getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally { em.close(); }
    }
}
