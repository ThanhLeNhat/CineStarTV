package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class ScreenDAO implements IDAO<ScreenDTO, Integer> {

    public ScreenDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(ScreenDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(ScreenDTO t) {
        return executeInTransaction(em -> {
            ScreenDTO s = em.find(ScreenDTO.class, t.getScreenId());
            if (s == null) throw new RuntimeException("Screen not found");
            s.setStatus("INACTIVE");
        });
    }
    public boolean update(ScreenDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<ScreenDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT s FROM ScreenDTO s", ScreenDTO.class).getResultList());
        } finally { em.close(); }
    }

    public ScreenDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(ScreenDTO.class, id); } finally { em.close(); }
    }

    public ArrayList<ScreenDTO> listByCinemaId(int cinemaId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT s FROM ScreenDTO s WHERE s.cinema.cinemaId = :cid AND s.status = 'ACTIVE'", ScreenDTO.class)
                    .setParameter("cid", cinemaId).getResultList());
        } finally { em.close(); }
    }
}
