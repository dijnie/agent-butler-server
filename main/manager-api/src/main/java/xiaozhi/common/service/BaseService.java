package xiaozhi.common.service;

import java.io.Serializable;
import java.util.Collection;

import com.baomidou.mybatisplus.core.conditions.Wrapper;

/**
 * Base service interface; all Service interfaces must extend it
 * Copyright (c) Renren Open Source All rights reserved.
 * Website: https://www.renren.io
 */
public interface BaseService<T> {
    Class<T> currentModelClass();

    /**
     * <p>
     * Insert one record (selected fields, strategy insert)
     * </p>
     *
     * @param entity entity object
     */
    boolean insert(T entity);

    /**
     * <p>
     * Insert (batch); this method does not support Oracle or SQL Server
     * </p>
     *
     * @param entityList collection of entity objects
     */
    boolean insertBatch(Collection<T> entityList);

    /**
     * <p>
     * Insert (batch); this method does not support Oracle or SQL Server
     * </p>
     *
     * @param entityList collection of entity objects
     * @param batchSize  insert batch size
     */
    boolean insertBatch(Collection<T> entityList, int batchSize);

    /**
     * <p>
     * Selectively update by ID
     * </p>
     *
     * @param entity entity object
     */
    boolean updateById(T entity);

    /**
     * <p>
     * Update records by the whereEntity condition
     * </p>
     *
     * @param entity        entity object
     * @param updateWrapper entity object wrapper operation class
     *                      {@link com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper}
     */
    boolean update(T entity, Wrapper<T> updateWrapper);

    /**
     * <p>
     * Batch update by ID
     * </p>
     *
     * @param entityList collection of entity objects
     */
    boolean updateBatchById(Collection<T> entityList);

    /**
     * <p>
     * Batch update by ID
     * </p>
     *
     * @param entityList collection of entity objects
     * @param batchSize  update batch size
     */
    boolean updateBatchById(Collection<T> entityList, int batchSize);

    /**
     * <p>
     * Query by ID
     * </p>
     *
     * @param id primary key ID
     */
    T selectById(Serializable id);

    /**
     * <p>
     * Delete by ID
     * </p>
     *
     * @param id primary key ID
     */
    boolean deleteById(Serializable id);

    /**
     * <p>
     * Delete (batch delete by ID)
     * </p>
     *
     * @param idList list of primary key IDs
     */
    boolean deleteBatchIds(Collection<? extends Serializable> idList);
}