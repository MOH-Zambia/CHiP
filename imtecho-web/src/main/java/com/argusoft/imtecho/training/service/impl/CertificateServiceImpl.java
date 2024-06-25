/*
 * To change certificateDao license header, choose License Headers in Project Properties.
 * To change certificateDao template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.training.service.impl;

import com.argusoft.imtecho.common.service.UserService;
import com.argusoft.imtecho.training.dao.CertificateDao;
import com.argusoft.imtecho.training.dto.CertificateDto;
import com.argusoft.imtecho.training.mapper.CertificateMapper;
import com.argusoft.imtecho.training.model.Certificate;
import com.argusoft.imtecho.training.service.CertificateService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * <p>
 *     Define services for certificate.
 * </p>
 * @author akshar
 * @since 26/08/20 11:00 AM
 *
 */
@Service("certificateService")
@Transactional
public class CertificateServiceImpl implements CertificateService {

    @Autowired
    CertificateDao certificateDao;

    @Autowired
    UserService userService;

    /**
     * {@inheritDoc}
     */
    @Override
    public void createCertificate(CertificateDto certificateDto) {
        certificateDao.create(CertificateMapper.dtoToEntityCertificate(certificateDto,null));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void updateCertificate(CertificateDto certificateDto) {
        Certificate certificate = certificateDao.retrieveById(certificateDto.getCertificateId());
        certificateDao.createOrUpdate(CertificateMapper.dtoToEntityCertificate(certificateDto,certificate));
    }


    /**
     * {@inheritDoc}
     */
    @Override
    public List<CertificateDto> getCertificatesByCourseAndType(Integer courseId, Certificate.Type type) {
        return CertificateMapper.entityToDtoCertificateList(certificateDao.getCertificatesByCourseAndType(courseId, type));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<CertificateDto> getCertificatesByTrainingAndUser(Integer trainingId, Integer userId) {
        return CertificateMapper.entityToDtoCertificateList(certificateDao.getCertificatesByTrainingAndUser(trainingId, userId));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<CertificateDto> getCertificatesByTrainingIdsAndCourseAndType(List<Integer> trainingIds, Integer courseId, Certificate.Type type) {
        return CertificateMapper.entityToDtoCertificateList(certificateDao.getCertificatesByTrainingIdsAndCourseAndType(trainingIds, courseId, type));
    }
}
