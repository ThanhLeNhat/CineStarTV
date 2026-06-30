package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class MovieDAO implements IDAO<MovieDTO, Integer> {

    public MovieDAO() {
    }

    private boolean executeInTransaction(
            java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            action.accept(em);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean add(MovieDTO t) {
        return executeInTransaction(em -> em.persist(t));
    }

    public boolean remove(MovieDTO t) {
        return executeInTransaction(em -> {
            MovieDTO movie = em.find(MovieDTO.class, t.getMovieId());
            if (movie == null) {
                throw new RuntimeException("Movie not found");
            }
            movie.setStatus("ENDED");
        });
    }

    public boolean update(MovieDTO t) {
        return executeInTransaction(em -> em.merge(t));
    }

    public ArrayList<MovieDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery("SELECT m FROM MovieDTO m ORDER BY m.createdAt DESC", MovieDTO.class)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public MovieDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(MovieDTO.class, id);
        } finally {
            em.close();
        }
    }

    public ArrayList<MovieDTO> searchByTitle(String keyword) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery(
                            "SELECT m FROM MovieDTO m WHERE m.title LIKE :kw OR m.titleEn LIKE :kw",
                            MovieDTO.class)
                            .setParameter("kw", "%" + keyword + "%")
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public ArrayList<MovieDTO> listByStatus(String status) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery(
                            "SELECT m FROM MovieDTO m WHERE m.status = :status ORDER BY m.releaseDate DESC",
                            MovieDTO.class)
                            .setParameter("status", status)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public ArrayList<MovieDTO> listNowShowing() {
        return listByStatus("NOW_SHOWING");
    }

    public ArrayList<MovieDTO> listComingSoon() {
        return listByStatus("COMING_SOON");
    }

    public ArrayList<MovieDTO> listTopRated(int limit) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery(
                            "SELECT m FROM MovieDTO m WHERE m.status = 'NOW_SHOWING' ORDER BY m.rating DESC",
                            MovieDTO.class)
                            .setMaxResults(limit)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public ArrayList<MovieDTO> listByGenreId(int genreId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery(
                            "SELECT DISTINCT m FROM MovieDTO m JOIN MovieGenreDTO mg ON mg.movieId = m.movieId " +
                            "WHERE mg.genreId = :gid ORDER BY m.createdAt DESC",
                            MovieDTO.class)
                            .setParameter("gid", genreId)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public boolean updateRating(int movieId, double avgRating, int count) {
        return executeInTransaction(em -> {
            MovieDTO m = em.find(MovieDTO.class, movieId);
            if (m != null) {
                m.setRating(avgRating);
                m.setRatingCount(count);
            }
        });
    }

    public long countAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(m) FROM MovieDTO m", Long.class)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }
}
