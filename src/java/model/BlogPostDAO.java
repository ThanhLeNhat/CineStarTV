package model;

import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import utils.JpaUtil;

public class BlogPostDAO implements IDAO<BlogPostDTO, Integer> {

    public BlogPostDAO() {
    }

    private boolean executeInTransaction(java.util.function.Consumer<EntityManager> action) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); action.accept(em); tx.commit(); return true; }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); e.printStackTrace(); return false; }
        finally { em.close(); }
    }

    public boolean add(BlogPostDTO t) { return executeInTransaction(em -> em.persist(t)); }
    public boolean remove(BlogPostDTO t) {
        return executeInTransaction(em -> {
            BlogPostDTO bp = em.find(BlogPostDTO.class, t.getPostId());
            if (bp == null) throw new RuntimeException("BlogPost not found");
            bp.setStatus("HIDDEN");
        });
    }
    public boolean update(BlogPostDTO t) { return executeInTransaction(em -> em.merge(t)); }

    public ArrayList<BlogPostDTO> listAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT bp FROM BlogPostDTO bp ORDER BY bp.createdAt DESC", BlogPostDTO.class).getResultList());
        } finally { em.close(); }
    }

    public BlogPostDTO searchByID(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try { return em.find(BlogPostDTO.class, id); } finally { em.close(); }
    }

    public ArrayList<BlogPostDTO> listPublished() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT bp FROM BlogPostDTO bp WHERE bp.status = 'PUBLISHED' ORDER BY bp.createdAt DESC",
                    BlogPostDTO.class).getResultList());
        } finally { em.close(); }
    }

    public ArrayList<BlogPostDTO> listByCategory(String category) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT bp FROM BlogPostDTO bp WHERE bp.category = :cat AND bp.status = 'PUBLISHED' ORDER BY bp.createdAt DESC",
                    BlogPostDTO.class).setParameter("cat", category).getResultList());
        } finally { em.close(); }
    }

    public ArrayList<BlogPostDTO> searchByTitle(String keyword) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return new ArrayList<>(em.createQuery(
                    "SELECT bp FROM BlogPostDTO bp WHERE bp.title LIKE :kw AND bp.status = 'PUBLISHED'",
                    BlogPostDTO.class).setParameter("kw", "%" + keyword + "%").getResultList());
        } finally { em.close(); }
    }
}
