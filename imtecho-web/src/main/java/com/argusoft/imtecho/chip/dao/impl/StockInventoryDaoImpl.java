package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.StockInventoryDao;
import com.argusoft.imtecho.chip.model.StockInventoryEntity;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dto.StockInventoryDataBean;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.util.Date;
import java.util.List;

@Repository
@Transactional
public class StockInventoryDaoImpl extends GenericDaoImpl<StockInventoryEntity, Integer> implements StockInventoryDao {

    public static final String MEDICINE_ID = "medicineId";
    public static final String REQUESTED_BY = "requestedBy";


    @Override
    public StockInventoryEntity retrieveByUserIdAndMedicineId(Long userId, Integer medicineId) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<StockInventoryEntity> cq = cb.createQuery(StockInventoryEntity.class);
        Root<StockInventoryEntity> root = cq.from(StockInventoryEntity.class);
        cq.select(root);
        cq.where(
                cb.and(
                        cb.equal(root.get(REQUESTED_BY), userId),
                        cb.equal(root.get(MEDICINE_ID), medicineId)
                )
        );
        return session.createQuery(cq).uniqueResult();
    }

    @Override
    public StockInventoryEntity retrieveByUserIdAndMedicineName(Long userId, String medicineName) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<StockInventoryEntity> cq = cb.createQuery(StockInventoryEntity.class);
        Root<StockInventoryEntity> root = cq.from(StockInventoryEntity.class);
        cq.select(root);
        cq.where(
                cb.and(
                        cb.equal(root.get(REQUESTED_BY), userId),
                        cb.equal(root.get(MEDICINE_ID), medicineName)
                )
        );
        return session.createQuery(cq).uniqueResult();
    }

    @Override
    public StockInventoryDataBean retrieveDeliveredRecords(Long userId, Integer medicineIds) {
        String query = "\n" +
                "select \n" +
                "smd.health_infra_id  as healthInfraId,\n" +
                "smr.medicine_id as medicineId,\n" +
                "smr.approved_qty as deliveredQuantity,\n" +
                "smr.approved_by as approvedBy,\n" +
                "smd.requested_by as requestedBy\n" +
                "from stock_management_details smd \n" +
                "inner join stock_medicines_rel smr on smd.id=smr.id \n" +
                "where smd.requested_by = :requestedBy\n" +
                "and smr.medicine_id = :medicineIds\n" +
                "and status='DELIVERED'\n" +
                "order by modified_on desc\n" +
                "limit 1";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<StockInventoryDataBean> q = session.createNativeQuery(query);
        q.setParameter("requestedBy", userId);
        q.setParameter("medicineIds", medicineIds);
        q.addScalar("healthInfraId", StandardBasicTypes.INTEGER);
        q.addScalar("medicineId", StandardBasicTypes.INTEGER);
        q.addScalar("deliveredQuantity", StandardBasicTypes.INTEGER);
        q.addScalar("requestedBy", StandardBasicTypes.INTEGER);
        q.addScalar("approvedBy", StandardBasicTypes.INTEGER);
        return q.setResultTransformer(Transformers.aliasToBean(StockInventoryDataBean.class)).uniqueResult();
    }

    @Override
    public List<StockInventoryDataBean> retrieveStockInventoryForMobile(Long userId, Date lastModifiedOn) {
        String query = "\n" +
                "select health_infra_id as \"healthInfraId\",\n" +
                "medicine_id as \"medicineId\",\n" +
                "approved_by as \"approvedBy\",\n" +
                "requested_by as \"requestedBy\",\n" +
                "medicine_stock_amount  as \"deliveredQuantity\",\n" +
                "used,\n" +
                "created_by as createdBy,\n" +
                "created_on as createdOn,\n" +
                "modified_by as modifiedBy,\n" +
                "modified_on as modifiedOn\n" +
                "from stock_inventory_entity sie \n" +
                "where requested_by =:requestedBy  ";
        if (lastModifiedOn != null) {
            query = query + " and modified_on > :lastModifiedOn";
        }
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<StockInventoryDataBean> q = session.createNativeQuery(query);
        q.setParameter("requestedBy", userId);
        if (lastModifiedOn != null) {
            q.setParameter("lastModifiedOn", lastModifiedOn);
        }
        q.addScalar("medicineId", StandardBasicTypes.INTEGER);
        q.addScalar("approvedBy", StandardBasicTypes.INTEGER);
        q.addScalar("requestedBy", StandardBasicTypes.INTEGER);
        q.addScalar("used", StandardBasicTypes.INTEGER);
        q.addScalar("deliveredQuantity", StandardBasicTypes.INTEGER);
        q.addScalar("createdBy", StandardBasicTypes.INTEGER);
        q.addScalar("createdOn", StandardBasicTypes.TIMESTAMP);
        q.addScalar("modifiedBy", StandardBasicTypes.INTEGER);
        q.addScalar("modifiedOn", StandardBasicTypes.TIMESTAMP);
        return q.setResultTransformer(Transformers.aliasToBean(StockInventoryDataBean.class)).list();
    }
}