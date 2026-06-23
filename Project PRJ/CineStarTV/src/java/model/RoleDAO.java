package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class RoleDAO implements IDAO<RoleDTO, Integer> {

    public RoleDAO() {
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

    public boolean add(RoleDTO t) {
        return executeInTransaction(em -> em.persist(t));
    }

    public boolean remove(RoleDTO t) {
        return executeInTransaction(em -> {
            RoleDTO role = em.find(RoleDTO.class, t.getRoleId());
            if (role == null) {
                throw new RuntimeException("Role not found");
            }
            em.remove(role);
        });
    }

    public boolean update(RoleDTO t) {
        return executeInTransaction(em -> em.merge(t));
    }

    public ArrayList<RoleDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery("SELECT r FROM RoleDTO r", RoleDTO.class)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public RoleDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(RoleDTO.class, id);
        } finally {
            em.close();
        }
    }

    public RoleDTO searchByName(String roleName) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT r FROM RoleDTO r WHERE r.roleName = :name", RoleDTO.class)
                    .setParameter("name", roleName)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }
}
