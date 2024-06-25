
package com.argusoft.imtecho.course.dao.impl;

import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.course.dao.TopicMediaMasterDao;
import com.argusoft.imtecho.course.model.TopicMediaMaster;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

/**
 * <p>
 * Define Database logic for topic video
 * </p>
 *
 * @author sneha
 * @since 01/03/2021 18:38
 */
@Repository
public class TopicMediaMasterDaoImpl extends GenericDaoImpl<TopicMediaMaster, Integer> implements TopicMediaMasterDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public List<TopicMediaMaster> getTopicMediaByTopicId(Integer topicId) {

        var session = getCurrentSession();
        var cb = session.getCriteriaBuilder();
        CriteriaQuery<TopicMediaMaster> cq = cb.createQuery(TopicMediaMaster.class);
        Root<TopicMediaMaster> root = cq.from(TopicMediaMaster.class);
        cq.select(root).where(
                cb.and(cb.equal(root.get(TopicMediaMaster.Fields.TOPIC_ID), topicId),
                        cb.equal(root.get(TopicMediaMaster.Fields.MEDIA_STATE), TopicMediaMaster.State.ACTIVE))
        );
        return session.createQuery(cq).getResultList();
    }

    @Transactional
    public List<TopicMediaMaster> getActiveTopicMedia(){
        var session = getCurrentSession();
        var cb = session.getCriteriaBuilder();

        CriteriaQuery<TopicMediaMaster> cq = cb.createQuery(TopicMediaMaster.class);
        Root<TopicMediaMaster> root = cq.from(TopicMediaMaster.class);

        cq.select(root).where(
            cb.equal(root.get(TopicMediaMaster.Fields.MEDIA_STATE), TopicMediaMaster.State.ACTIVE)
        );

        return session.createQuery(cq).getResultList();
    }
}
