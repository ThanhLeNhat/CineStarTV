package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class VoucherDAO implements IDAO<VoucherDTO, Integer> {

    public VoucherDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(VoucherDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(VoucherDTO t) {
        return executeInTransaction(em -> {
            VoucherDTO v = em.find(VoucherDTO.class, t.getVoucherId());
            if (v == null) throw new RuntimeException("Voucher not found");
            v.setStatus("DISABLED");
        });
    }
    public boolean update(VoucherDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<VoucherDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery("SELECT v FROM VoucherDTO v ORDER BY v.createdAt DESC", VoucherDTO.class).getResultList());
        } finally { em.close(); }
    }

    public VoucherDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(VoucherDTO.class, id); } finally { em.close(); }
    }

    public VoucherDTO searchByCode(String code) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT v FROM VoucherDTO v WHERE v.code = :code", VoucherDTO.class)
                    .setParameter("code", code.toUpperCase()).getSingleResult();
        } catch (Exception e) { return null; } finally { em.close(); }
    }

    public ArrayList<VoucherDTO> listActive() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT v FROM VoucherDTO v WHERE v.status = 'ACTIVE' AND v.endDate >= CURRENT_DATE AND v.usedCount < v.quantity",
                    VoucherDTO.class).getResultList());
        } finally { em.close(); }
    }

    public boolean incrementUsedCount(int voucherId) {
        return executeInTransaction(em -> {
            VoucherDTO v = em.find(VoucherDTO.class, voucherId);
            if (v == null) throw new RuntimeException("Voucher not found");
            v.setUsedCount(v.getUsedCount() + 1);
        });
    }
}
