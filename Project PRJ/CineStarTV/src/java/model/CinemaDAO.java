package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class CinemaDAO implements IDAO<CinemaDTO, Integer> {

    public CinemaDAO() {
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
            if (tx.isActive()) { tx.rollback(); }
            e.printStackTrace();
            return false;
        } finally { em.close(); }
    }

    public boolean add(CinemaDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(CinemaDTO t) {
        return executeInTransaction(em -> {
            CinemaDTO c = em.find(CinemaDTO.class, t.getCinemaId());
            if (c == null) throw new RuntimeException("Cinema not found");
            c.setStatus("INACTIVE");
        });
    }
    public boolean update(CinemaDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<CinemaDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT c FROM CinemaDTO c ORDER BY c.cinemaName", CinemaDTO.class).getResultList());
        } finally { em.close(); }
    }

    public CinemaDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(CinemaDTO.class, id); } finally { em.close(); }
    }

    public ArrayList<CinemaDTO> listActive() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT c FROM CinemaDTO c WHERE c.status = 'ACTIVE' ORDER BY c.cinemaName", CinemaDTO.class).getResultList());
        } finally { em.close(); }
    }

    public ArrayList<CinemaDTO> searchByCity(String city) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT c FROM CinemaDTO c WHERE c.city = :city AND c.status = 'ACTIVE'", CinemaDTO.class).setParameter("city", city).getResultList());
        } finally { em.close(); }
    }
}
