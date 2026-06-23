package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class MovieGenreDAO implements IDAO<MovieGenreDTO, MovieGenreId> {

    public MovieGenreDAO() {
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

    public boolean add(MovieGenreDTO t) {
        return executeInTransaction(em -> em.persist(t));
    }

    public boolean remove(MovieGenreDTO t) {
        return executeInTransaction(em -> {
            MovieGenreDTO mg = em.find(MovieGenreDTO.class,
                    new MovieGenreId(t.getMovieId(), t.getGenreId()));
            if (mg == null) {
                throw new RuntimeException("MovieGenre not found");
            }
            em.remove(mg);
        });
    }

    public boolean update(MovieGenreDTO t) {
        return executeInTransaction(em -> em.merge(t));
    }

    public ArrayList<MovieGenreDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery("SELECT mg FROM MovieGenreDTO mg", MovieGenreDTO.class)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public MovieGenreDTO searchByID(MovieGenreId id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(MovieGenreDTO.class, id);
        } finally {
            em.close();
        }
    }

    public ArrayList<MovieGenreDTO> listByMovieId(int movieId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery(
                            "SELECT mg FROM MovieGenreDTO mg WHERE mg.movieId = :mid",
                            MovieGenreDTO.class)
                            .setParameter("mid", movieId)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public ArrayList<GenreDTO> listGenresByMovieId(int movieId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery(
                            "SELECT mg.genre FROM MovieGenreDTO mg WHERE mg.movieId = :mid",
                            GenreDTO.class)
                            .setParameter("mid", movieId)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public boolean removeAllByMovieId(int movieId) {
        return executeInTransaction(em -> {
            em.createQuery("DELETE FROM MovieGenreDTO mg WHERE mg.movieId = :mid")
                    .setParameter("mid", movieId)
                    .executeUpdate();
        });
    }
}
