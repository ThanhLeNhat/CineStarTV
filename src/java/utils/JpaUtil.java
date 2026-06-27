package utils;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

/**
 * JPA EntityManager Factory utility
 * Persistence Unit: CineStarTV-PU (see persistence.xml)
 */
public class JpaUtil {

    private static EntityManagerFactory emf;

    private static EntityManagerFactory getEMF() {
        if (emf == null || !emf.isOpen()) {
            emf = Persistence.createEntityManagerFactory("CineStarTVPU");
        }
        return emf;
    }

    public static EntityManager getEntityManager() {
        return getEMF().createEntityManager();
    }

    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
