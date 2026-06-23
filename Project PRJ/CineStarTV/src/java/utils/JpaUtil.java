package utils;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

/**
 * JPA EntityManager Factory utility
 * Persistence Unit: CineStarTV-PU (see persistence.xml)
 */
public class JpaUtil {

    private static final EntityManagerFactory emf
            = Persistence.createEntityManagerFactory("CineStarTVPU");

    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
