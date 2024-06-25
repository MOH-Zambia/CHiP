package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.service.ClientService;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.*;
import com.argusoft.imtecho.fhs.mapper.*;
import com.argusoft.imtecho.rch.dao.*;
import com.argusoft.imtecho.rch.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Implementation of method in ClientService.
 */
@Service
@Transactional
public class ClientServiceImpl implements ClientService {

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private AncVisitDao ancVisitDao;

    @Autowired
    private ChildServiceDao childServiceDao;

    @Autowired
    private PncChildMasterDao pncChildMasterDao;

    @Autowired
    private PncMotherMasterDao pncMotherMasterDao;

    @Autowired
    private WpdMotherDao wpdMotherDao;

    @Autowired
    private WpdChildDao wpdChildDao;

    /**
     * {@inheritDoc}
     */
    public List<ClientMemberDto> getMembers(Integer facilityCode, Date registrationStartDate, Date registrationEndDate, String householdId, Integer zoneId, Integer cbvId){
        return memberDao.findMembers(facilityCode, registrationStartDate, registrationEndDate, householdId, zoneId, cbvId);

    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<HouseholdDto> getHouseholds(Integer facilityCode, Date registrationStartDate, Date registrationEndDate, String householdId, Integer zoneId, Integer cbvId, boolean includeMembers) {
        return familyDao.getHouseholds(facilityCode, registrationStartDate, registrationEndDate, householdId, zoneId, cbvId, includeMembers);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<ReferralDto> getReferrals(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, String householdId, Integer zoneId, Integer cbvId) {
        return memberDao.getReferral(facilityCode, serviceStartDate, serviceEndDate, householdId, zoneId, cbvId);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public InteractionDto getInteractions(Integer memberId, Date serviceStartDate, Date serviceEndDate) {
        List<MalariaDto> malariaDetails = memberDao.getMalariaDetails(memberId, serviceStartDate, serviceEndDate);
        List<TuberculosisDto> tuberculosisDetails = memberDao.getTuberculosisDetails(memberId, serviceStartDate, serviceEndDate);
        List<CovidDto> covidDetails = memberDao.getCovidDetails(memberId, serviceStartDate, serviceEndDate);
        List<AncDto> ancDetails = getAncDetails(memberId);
        List<ChildServiceDto> childServiceDetails = getChildServiceDetails(memberId, 10);
        List<PncChildDetailsDto> pncChildDetails = getPncChildDetails(memberId);
        List<PncMotherDetailsDto> pncMotherDetails = getPncMotherDetails(memberId);
        List<WpdMotherDetailsDto> wpdMotherDetails = getWpdMotherDetails(memberId);
        List<WpdChildDetailsDto> wpdChildDetails = getWpdChildDetails(memberId);
        List<HivDto> hivDetails = memberDao.getHivDetails(memberId,serviceStartDate,serviceEndDate);


        InteractionDto interactionDto = new InteractionDto();
        interactionDto.setMemberId(memberId);

        if (!malariaDetails.isEmpty()) {
            interactionDto.setMalariaDetails(malariaDetails);
        }

        if (!tuberculosisDetails.isEmpty()) {
            interactionDto.setTbDetails(tuberculosisDetails);
        }

        if (!covidDetails.isEmpty()) {
            interactionDto.setCovidDetails(covidDetails);
        }

        if (!ancDetails.isEmpty()) {
            interactionDto.setAncDetails(ancDetails);
        }

        if (!childServiceDetails.isEmpty()) {
            interactionDto.setChildServiceDetails(childServiceDetails);
        }

        if (!pncChildDetails.isEmpty()) {
            interactionDto.setPncChildDetails(pncChildDetails);
        }

        if (!pncMotherDetails.isEmpty()){
            interactionDto.setPncMotherDetails(pncMotherDetails);
        }

        if (!wpdMotherDetails.isEmpty()){
            interactionDto.setWpdMotherDetails(wpdMotherDetails);
        }

        if (!wpdChildDetails.isEmpty()) {
            interactionDto.setWpdChildDetails(wpdChildDetails);
        }

        if(!hivDetails.isEmpty()){
            interactionDto.setHivDetails(hivDetails);
        }

        return interactionDto;
    }

    public List<AncDto> getAncDetails(Integer memberId) {
        List<AncVisit> ancVisits = ancVisitDao.retrieveByMemberId(memberId);
        List<AncDto> ancDetails = new ArrayList<>();
        for (AncVisit visit : ancVisits) {
            ancDetails.add(AncDetailsMapper.mapFromAncVisit(visit));
        }
        return ancDetails;
    }

    public List<ChildServiceDto> getChildServiceDetails(Integer memberId, int limit) {
        List<ChildServiceMaster> childServiceMasters = childServiceDao.retrieveByMemberId(memberId, limit);
        List<ChildServiceDto> childServiceDetails = new ArrayList<>();
        for (ChildServiceMaster service : childServiceMasters) {
            childServiceDetails.add(ChildServiceMapper.mapFromChildServiceMaster(service));
        }
        return childServiceDetails;
    }

    public List<PncChildDetailsDto> getPncChildDetails(Integer memberId) {
        List<PncChildMaster> pncChildMasters = pncChildMasterDao.getPncChildbyMemberid(memberId);
        List<PncChildDetailsDto> pncChildDetails = new ArrayList<>();
        for (PncChildMaster pncChildMaster : pncChildMasters) {
            pncChildDetails.add(PncChildDetailMapper.mapFromPncChildMaster(pncChildMaster));
        }
        return pncChildDetails;
    }

    public List<PncMotherDetailsDto> getPncMotherDetails(Integer memberId) {
        List<PncMotherMaster> pncMotherMasters = pncMotherMasterDao.getPncMotherbyMemberid(memberId);
        List<PncMotherDetailsDto> pncMotherDetails = new ArrayList<>();
        for (PncMotherMaster pncMotherMaster : pncMotherMasters) {
            pncMotherDetails.add(PncMotherDetailsMapper.mapFromPncMotherMaster(pncMotherMaster));
        }
        return pncMotherDetails;
    }

    public List<WpdMotherDetailsDto> getWpdMotherDetails(Integer memberId) {
        List<WpdMotherMaster> wpdMotherMasters = wpdMotherDao.getWpdMotherbyMemberid(memberId);
        List<WpdMotherDetailsDto> wpdMotherDetails = new ArrayList<>();
        for (WpdMotherMaster master : wpdMotherMasters) {
            wpdMotherDetails.add(WpdMotherDetailsMapper.mapFromWpdMotherMaster(master));
        }
        return wpdMotherDetails;
    }

    public List<WpdChildDetailsDto> getWpdChildDetails(Integer memberId) {
        List<WpdChildMaster> wpdChildMasters = wpdChildDao.getWpdChildbyMemberid(memberId);
        List<WpdChildDetailsDto> wpdChildDetails = new ArrayList<>();
        for (WpdChildMaster master : wpdChildMasters) {
            wpdChildDetails.add(WpdChildMapper.mapFromWpdChildMaster(master));
        }
        return wpdChildDetails;
    }


}
