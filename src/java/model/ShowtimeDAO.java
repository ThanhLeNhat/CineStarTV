package model;

import java.util.ArrayList;
import java.util.Date;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class ShowtimeDAO implements IDAO<ShowtimeDTO, Integer> {

    public ShowtimeDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(ShowtimeDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(ShowtimeDTO t) {
        return executeInTransaction(em -> {
            ShowtimeDTO s = em.find(ShowtimeDTO.class, t.getShowtimeId());
            if (s == null) throw new RuntimeException("Showtime not found");
            s.setStatus("CANCELLED");
        });
    }
    public boolean update(ShowtimeDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<ShowtimeDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT s FROM ShowtimeDTO s ORDER BY s.showDate DESC, s.startTime",
                    ShowtimeDTO.class).getResultList());
        } finally { em.close(); }
    }

    public ShowtimeDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(ShowtimeDTO.class, id); } finally { em.close(); }
    }

    public ArrayList<ShowtimeDTO> listByMovieAndDate(int movieId, Date date) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT s FROM ShowtimeDTO s WHERE s.movie.movieId = :mid AND s.showDate = :date AND s.status = 'ACTIVE' ORDER BY s.startTime",
                    ShowtimeDTO.class)
                    .setParameter("mid", movieId)
                    .setParameter("date", date)
                    .getResultList());
        } finally { em.close(); }
    }

    public ArrayList<ShowtimeDTO> listByMovieId(int movieId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT s FROM ShowtimeDTO s WHERE s.movie.movieId = :mid AND s.status = 'ACTIVE' ORDER BY s.screen.cinema.cinemaId, s.showDate, s.startTime",
                    ShowtimeDTO.class)
                    .setParameter("mid", movieId).getResultList());
        } finally { em.close(); }
    }

    public ArrayList<ShowtimeDTO> listByMovieDateCity(int movieId, Date date, String city) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT s FROM ShowtimeDTO s WHERE s.movie.movieId = :mid AND s.showDate = :date " +
                    "AND s.screen.cinema.city = :city AND s.status = 'ACTIVE' " +
                    "ORDER BY s.screen.cinema.cinemaId, s.startTime",
                    ShowtimeDTO.class)
                    .setParameter("mid", movieId)
                    .setParameter("date", date)
                    .setParameter("city", city)
                    .getResultList());
        } finally { em.close(); }
    }

    public java.util.List<String> listCitiesByMovieId(int movieId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            java.util.Date today = new java.util.Date();
            return em.createQuery(
                    "SELECT DISTINCT s.screen.cinema.city FROM ShowtimeDTO s " +
                    "WHERE s.movie.movieId = :mid AND s.status = 'ACTIVE' AND s.showDate >= :today " +
                    "ORDER BY s.screen.cinema.city",
                    String.class)
                    .setParameter("mid", movieId)
                    .setParameter("today", today)
                    .getResultList();
        } finally { em.close(); }
    }

    public ArrayList<ShowtimeDTO> listByCinemaAndDate(int cinemaId, Date date) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT s FROM ShowtimeDTO s WHERE s.screen.cinema.cinemaId = :cid AND s.showDate = :date AND s.status = 'ACTIVE' ORDER BY s.startTime",
                    ShowtimeDTO.class)
                    .setParameter("cid", cinemaId)
                    .setParameter("date", date)
                    .getResultList());
        } finally { em.close(); }
    }
}
