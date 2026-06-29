package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class GenreDAO implements IDAO<GenreDTO, Integer> {

    public GenreDAO() {
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

    public boolean add(GenreDTO t) {
        return executeInTransaction(em -> em.persist(t));
    }

    public boolean remove(GenreDTO t) {
        return executeInTransaction(em -> {
            GenreDTO genre = em.find(GenreDTO.class, t.getGenreId());
            if (genre == null) {
                throw new RuntimeException("Genre not found");
            }
            em.remove(genre);
        });
    }

    public boolean update(GenreDTO t) {
        return executeInTransaction(em -> em.merge(t));
    }

    public ArrayList<GenreDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery("SELECT g FROM GenreDTO g ORDER BY g.genreName", GenreDTO.class)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public GenreDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(GenreDTO.class, id);
        } finally {
            em.close();
        }
    }
}
