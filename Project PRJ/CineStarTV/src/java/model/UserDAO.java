package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;
import utils.PasswordUtil;

public class UserDAO implements IDAO<UserDTO, Integer> {

    public UserDAO() {
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

    public boolean add(UserDTO t) {
        return executeInTransaction(em -> em.persist(t));
    }

    public boolean remove(UserDTO t) {
        return softDelete(t.getUserId());
    }

    public boolean update(UserDTO t) {
        return executeInTransaction(em -> em.merge(t));
    }

    public ArrayList<UserDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery("SELECT u FROM UserDTO u", UserDTO.class)
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public UserDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(UserDTO.class, id);
        } finally {
            em.close();
        }
    }

    public UserDTO searchByEmail(String email) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT u FROM UserDTO u WHERE u.email = :email", UserDTO.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    public UserDTO searchByGoogleId(String googleId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT u FROM UserDTO u WHERE u.googleId = :googleId", UserDTO.class)
                    .setParameter("googleId", googleId)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    public ArrayList<UserDTO> searchByName(String name) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(
                    em.createQuery(
                            "SELECT u FROM UserDTO u WHERE u.fullName LIKE :name", UserDTO.class)
                            .setParameter("name", "%" + name + "%")
                            .getResultList()
            );
        } finally {
            em.close();
        }
    }

    public UserDTO searchByResetToken(String token) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT u FROM UserDTO u WHERE u.resetToken = :token", UserDTO.class)
                    .setParameter("token", token)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    public boolean checkLogin(String email, String password) {
        UserDTO u = searchByEmail(email);
        if (u == null) {
            return false;
        }
        if (!"ACTIVE".equals(u.getStatus())) {
            return false;
        }
        if (u.getPassword() == null) {
            return false; // Google-only account
        }
        return PasswordUtil.verify(password, u.getPassword());
    }

    public boolean softDelete(int userId) {
        return executeInTransaction(em -> {
            UserDTO user = em.find(UserDTO.class, userId);
            if (user == null) {
                throw new RuntimeException("User not found");
            }
            user.setStatus("BANNED");
        });
    }

    public boolean hardDelete(int userId) {
        return executeInTransaction(em -> {
            UserDTO user = em.find(UserDTO.class, userId);
            if (user == null) {
                throw new RuntimeException("User not found");
            }
            em.remove(user);
        });
    }

    public long countAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(u) FROM UserDTO u", Long.class)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }
}
