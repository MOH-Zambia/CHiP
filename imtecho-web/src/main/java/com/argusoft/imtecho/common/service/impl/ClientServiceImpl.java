package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.service.ClientService;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.*;
import com.argusoft.imtecho.rch.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

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
    public List<InteractionDto> getInteractions(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        List<MalariaDto> malariaDetails = memberDao.getMalariaDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<TuberculosisDto> tuberculosisDetails = memberDao.getTuberculosisDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<CovidDto> covidDetails = memberDao.getCovidDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<HivDto> hivDetails = memberDao.getHivDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<AncDto> ancDetails = memberDao.getAncDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<ChildServiceDto> childServiceDetails = memberDao.getChildServiceDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<PncChildDetailsDto> pncChildDetails = memberDao.getPncChildDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<PncMotherDetailsDto> pncMotherDetails = memberDao.getPncMotherDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<WpdMotherDetailsDto> wpdMotherDetails = memberDao.getWpdMotherDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<WpdChildDetailsDto> wpdChildDetails = memberDao.getWpdChildDetails(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        Map<Integer, InteractionDto> interactionMap = new HashMap<>();

        for (MalariaDto malariaDto : malariaDetails) {
            if (malariaDto.getMemberId() != null) {
                interactionMap.computeIfAbsent(malariaDto.getMemberId(), k -> new InteractionDto()).getMalariaDetails().add(malariaDto);
            }
        }

        for (TuberculosisDto tuberculosisDto : tuberculosisDetails) {
            if (tuberculosisDto.getMemberId() != null) {
                interactionMap.computeIfAbsent(tuberculosisDto.getMemberId(), k -> new InteractionDto()).getTbDetails().add(tuberculosisDto);
            }
        }

        for (CovidDto covidDto : covidDetails) {
            if (covidDto.getMemberId() != null) {
                interactionMap.computeIfAbsent(covidDto.getMemberId(), k -> new InteractionDto()).getCovidDetails().add(covidDto);
            }
        }

        for (AncDto ancDto : ancDetails) {
            if (ancDto.getMemberId() != null) {
                interactionMap.computeIfAbsent(ancDto.getMemberId(), k -> new InteractionDto()).getAncDetails().add(ancDto);
            }
        }

        for (ChildServiceDto childServiceDto : childServiceDetails) {
            if (childServiceDto.getMemberId() != null) {
                interactionMap.computeIfAbsent(childServiceDto.getMemberId(), k -> new InteractionDto()).getChildServiceDetails().add(childServiceDto);
            }
        }

        for (PncChildDetailsDto pncChildDetailsDto : pncChildDetails) {
            if (pncChildDetailsDto.getChildId() != null) {
                interactionMap.computeIfAbsent(pncChildDetailsDto.getChildId(), k -> new InteractionDto()).getPncChildDetails().add(pncChildDetailsDto);
            }
        }

        for (PncMotherDetailsDto pncMotherDetailsDto : pncMotherDetails) {
            if (pncMotherDetailsDto.getMotherId() != null) {
                interactionMap.computeIfAbsent(pncMotherDetailsDto.getMotherId(), k -> new InteractionDto()).getPncMotherDetails().add(pncMotherDetailsDto);
            }
        }

        for (WpdMotherDetailsDto wpdMotherDetailsDto : wpdMotherDetails) {
            if (wpdMotherDetailsDto.getMemberId() != null) {
                interactionMap.computeIfAbsent(wpdMotherDetailsDto.getMemberId(), k -> new InteractionDto()).getWpdMotherDetails().add(wpdMotherDetailsDto);
            }
        }

        for (WpdChildDetailsDto wpdChildDetailsDto : wpdChildDetails) {
            if (wpdChildDetailsDto.getMemberId() != null) {
                interactionMap.computeIfAbsent(wpdChildDetailsDto.getMemberId(), k -> new InteractionDto()).getWpdChildDetails().add(wpdChildDetailsDto);
            }
        }

        for (HivDto hivDto : hivDetails) {
            if (hivDto.getMemberId() != null) {
                interactionMap.computeIfAbsent(hivDto.getMemberId(), k -> new InteractionDto()).getHivDetails().add(hivDto);
            }
        }

        List<InteractionDto> interactions = new ArrayList<>(interactionMap.values());

        for (Map.Entry<Integer, InteractionDto> entry : interactionMap.entrySet()) {
            entry.getValue().setMemberId(entry.getKey());
        }

        return interactions;

    }

}
