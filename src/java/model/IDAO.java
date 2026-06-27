package model;

import java.util.ArrayList;

/**
 * Generic DAO Interface — tất cả DAO phải implement
 * @param <T> Entity type (DTO)
 * @param <K> Primary key type (Integer, String, ...)
 */
public interface IDAO<T, K> {

    public boolean add(T t);

    public boolean remove(T t);

    public boolean update(T t);

    public ArrayList<T> listAll();

    public T searchByID(K id);
}
