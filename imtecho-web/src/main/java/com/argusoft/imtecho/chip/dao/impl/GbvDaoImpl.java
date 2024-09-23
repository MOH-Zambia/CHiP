package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.GbvDao;
import com.argusoft.imtecho.chip.model.GbvVisit;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class GbvDaoImpl extends GenericDaoImpl<GbvVisit, Integer> implements GbvDao {
    @Override
    public Integer updateDocumentId(String uuid, Long docId, Integer relatedId, Integer memberId) {
        if (uuid == null || docId == null) {
            return null;
        }

        try {
            String query = "UPDATE gbv_visit_master " +
                    "SET photo_doc_id = " +
                    " (CASE " +
                    "    WHEN photo_unique_id = :uniqueId THEN CAST (:docId as TEXT) " +
                    "    ELSE photo_doc_id " +
                    " END)";

            if (relatedId != null) {
                query += " WHERE id = :relatedId";
            } else {
                query += " WHERE member_id = CAST(:memberId AS TEXT)";
            }

            Session session = sessionFactory.getCurrentSession();
            SQLQuery q = session.createSQLQuery(query);
            q.setParameter("uniqueId", uuid); // Assuming uuid is of type Long
            q.setParameter("docId", docId);

            if (relatedId != null) {
                q.setParameter("relatedId", relatedId);
            } else {
                q.setParameter("memberId", memberId);
            }

            return q.executeUpdate();
        } catch (Exception e) {
            // Handle exception and ensure transaction rollback
            throw new RuntimeException("Failed to update photo doc id", e);
        }
    }

}
