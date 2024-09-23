package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.StockInventoryDao;
import com.argusoft.imtecho.chip.dao.StockManagementDao;
import com.argusoft.imtecho.chip.model.StockInventoryEntity;
import com.argusoft.imtecho.chip.model.StockManagementDataBean;
import com.argusoft.imtecho.chip.model.StockManagementEntity;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dto.StockInventoryDataBean;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Repository
@Transactional
public class StockManagementDaoImpl extends GenericDaoImpl<StockManagementEntity, Integer> implements StockManagementDao {

    @Autowired
    StockInventoryDao stockInventoryDao ;

    @Override
    public void handleRelTables(StockManagementEntity stockManagementEntity) {
        if (stockManagementEntity.getStockManagementDataBeans() != null) {
            StringBuilder queryString = new StringBuilder();
            String tableName = "insert into stock_medicines_rel values ";
            for (StockManagementDataBean bean : stockManagementEntity.getStockManagementDataBeans()) {
                queryString.append(String.format("%s (%d,%d,%d,'%s',%d);%n", tableName, stockManagementEntity.getId(), bean.getMedicineId(), bean.getMedicineQuantity(), bean.getStatus(), 0));
            }
            Session session = sessionFactory.getCurrentSession();
            NativeQuery<Integer> q = session.createNativeQuery(queryString.toString());
            q.executeUpdate();
        }
    }

    public void updateStock(List<StockManagementDataBean> stockManagementDataBeans, Integer healthInfraId, Integer userId) {
        Session session = sessionFactory.getCurrentSession();
        for (StockManagementDataBean stockManagementDataBean : stockManagementDataBeans) {
            String status = "ACKNOWLEDGED";
            String query = "";
            if (stockManagementDataBean.getApprovedQuantity() == null || stockManagementDataBean.getApprovedQuantity() == 0 || !stockManagementDataBean.getReason().isEmpty())
                status = "REJECTED";
            if(stockManagementDataBean.getInventoryId() != -1){
             query = """
                    update stock_medicines_rel
                    set status = '%s',
                        approved_qty = %d,
                        approved_by = %d,
                        approved_on = now(),
                        reason = '%s'
                    where medicine_id = %d and id = %d ;
                    
                    """.formatted(status, stockManagementDataBean.getApprovedQuantity(), healthInfraId, stockManagementDataBean.getReason(), stockManagementDataBean.getMedicineId(), stockManagementDataBean.getId(), stockManagementDataBean.getApprovedQuantity(), stockManagementDataBean.getInventoryId());
            }
            else {
                query = """
                    update stock_medicines_rel
                    set status = '%s',
                        approved_qty = %d,
                        approved_by = %d,
                        approved_on = now(),
                        reason = '%s'
                    where medicine_id = %d and id = %d ;
         
                    """.formatted(status, stockManagementDataBean.getApprovedQuantity(), healthInfraId, stockManagementDataBean.getReason(), stockManagementDataBean.getMedicineId(), stockManagementDataBean.getId());

                StockInventoryEntity stockInventoryEntity = new StockInventoryEntity();
                stockInventoryEntity.setRequestedBy(userId);
                stockInventoryEntity.setMedicineId(stockManagementDataBean.getMedicineId());
                stockInventoryEntity.setUsed(0);
                stockInventoryEntity.setApprovedBy(healthInfraId);
                stockInventoryEntity.setHealthInfraId(healthInfraId);
                stockInventoryEntity.setMedicineStockAmount(stockManagementDataBean.getApprovedQuantity());
                stockInventoryDao.createOrUpdate(stockInventoryEntity);
            }

            NativeQuery<Integer> q = session.createNativeQuery(query);
            q.executeUpdate();
        }
    }

    public List<StockManagementDataBean> getStockManagementDataBeans(Long requestedBy, Boolean getApproved) {
        String query = """
                select
                    smr.medicine_id as "medicineId",
                    smr.quantity as "medicineQuantity",
                    smr.approved_qty as "approvedQuantity",
                    smr.status,
                    smr.approved_on as "approvedOn",
                    smr.approved_by as "approvedBy",
                    smr.id
                from stock_medicines_rel smr
                inner join stock_management_details smd on smr.id = smd.id
                where smd.requested_by = %d
                """.formatted(requestedBy);

        if (getApproved)
            query = query + " and smr.status = 'DELIVERED'";
        else
            query = query + " and smr.status != 'DELIVERED'";

        Session session = sessionFactory.getCurrentSession();
        NativeQuery<StockManagementDataBean> q = session.createNativeQuery(query);
        q.addScalar("medicineId", StandardBasicTypes.INTEGER);
        q.addScalar("medicineQuantity", StandardBasicTypes.INTEGER);
        q.addScalar("approvedQuantity", StandardBasicTypes.INTEGER);
        q.addScalar("status", StandardBasicTypes.STRING);
        q.addScalar("approvedBy", StandardBasicTypes.INTEGER);
        q.addScalar("approvedOn", StandardBasicTypes.TIMESTAMP);
        q.addScalar("id", StandardBasicTypes.INTEGER);
        return q.setResultTransformer(Transformers.aliasToBean(StockManagementDataBean.class)).list();
    }

    public Integer markStockStatusAsDelivered(Integer stockReqId, Integer medicineId) {
        Session session = sessionFactory.getCurrentSession();
        String query = """
                update stock_medicines_rel
                set status = 'DELIVERED'
                where id = :stockRequestId and medicine_id = :medicineId
                """;

        NativeQuery q = session.createNativeQuery(query);
        q.setParameter("stockRequestId", stockReqId);
        q.setParameter("medicineId", medicineId);
        return q.executeUpdate();
    }

    @Override
    public List<StockInventoryDataBean> getStockInventoryDataBeans(int requestedBy, Date lastModifiedOn) {
        String query = "\n" +
                "select health_infra_id as \"healthInfraId\",\n" +
                "smr.medicine_id as \"medicineId\",\n" +
                "smr.approved_by as \"approvedBy\",\n" +
                "smr.approved_qty as \"deliveredQuantity\",\n" +
                "smd.modified_by as \"modifiedBy\",\n" +
                "smd.modified_on as \"modifiedOn\",\n" +
                "smd.created_by  as \"createdBy\",\n" +
                "smd.created_on  as \"createdOn\"\n" +
                "from stock_management_details smd\n" +
                "inner join stock_medicines_rel smr on smd.id=smr.id\n" +
                "where smr.status='DELIVERED'\n" +
                "and smd.requested_by= :requestedBy";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<StockInventoryDataBean> q = session.createNativeQuery(query);
        q.setParameter("requestedBy", requestedBy);
        q.addScalar("healthInfraId", StandardBasicTypes.INTEGER);
        q.addScalar("medicineId", StandardBasicTypes.INTEGER);
        q.addScalar("deliveredQuantity", StandardBasicTypes.INTEGER);
        q.addScalar("modifiedBy", StandardBasicTypes.INTEGER);
        q.addScalar("modifiedOn", StandardBasicTypes.TIMESTAMP);
        q.addScalar("createdBy", StandardBasicTypes.INTEGER);
        q.addScalar("createdOn", StandardBasicTypes.TIMESTAMP);
        q.addScalar("approvedBy", StandardBasicTypes.INTEGER);
        return q.setResultTransformer(Transformers.aliasToBean(StockInventoryDataBean.class)).list();

    }
}