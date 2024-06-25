package com.argusoft.imtecho.fhs.controller;

import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.fhs.dto.MemberInformationDto;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.mobile.dto.FamilyDataBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * Define APIs for fhs.
 * </p>
 *
 * @author shrey
 * @since 26/08/20 10:19 AM
 */
@RestController
@RequestMapping("/api/fhs")
public class FhsController {

    @Autowired
    FamilyHealthSurveyService familyHealthSurveyService;


    /**
     * Search family based on id of user, search text, id of family, id of location etc.
     *
     * @param userId             Id of user.
     * @param searchString       Search text.
     * @param searchByFamilyId   Id of family.
     * @param searchByLocationId Id of location.
     * @param isArchivedFamily   Is family archived or not.
     * @param isVerifiedFamily   Is family verified or not.
     * @return Returns list of family details based on defined criteria.
     */
    @GetMapping(value = "/familysearch")
    public List<Map<String, List<FamilyDataBean>>> getFamiliesToBeAssignedBySearchString(
            @RequestParam(name = "userId") Integer userId,
            @RequestParam("searchString") List<String> searchString,
            @RequestParam("searchByFamilyId") Boolean searchByFamilyId,
            @RequestParam("searchByLocationId") Boolean searchByLocationId,
            @RequestParam("isArchivedFamily") Boolean isArchivedFamily,
            @RequestParam("isVerifiedFamily") Boolean isVerifiedFamily) {
        return familyHealthSurveyService.getFamiliesToBeAssignedBySearchString(userId, searchString, searchByFamilyId, searchByLocationId, isArchivedFamily, isVerifiedFamily);
    }

    /**
     * Retrieve Member Details by memberId
     *
     * @param memberId ID of imt_member
     * @return Returns Member Details
     */
    @GetMapping(value = "/membersearch")
    public MemberDto retrieveDetailsByMemberId(@RequestParam(name = "memberId", required = true) Integer memberId) {
        return familyHealthSurveyService.retrieveDetailsByMemberId(memberId);
    }

    /**
     * Search member by unique health id.
     *
     * @param byUniqueHealthId Unique health id.
     * @return Returns member details by unique health id.
     */
    @GetMapping(value = "/membersearchbyuniquehealthid")
    public MemberInformationDto getMembersByCriteria(@RequestParam(name = "uniqueHealthId") String byUniqueHealthId) {
        return familyHealthSurveyService.searchMembersByUniqueHealthId(byUniqueHealthId);
    }

    @GetMapping(value = "/getMemberDetailsByUniqueHealthId")
    public MemberDto getMemberDetailsByUniqueHealthId(@RequestParam(name = "uniqueHealthId") String byUniqueHealthId) {
        return familyHealthSurveyService.getMemberDetailsByUniqueHealthId(byUniqueHealthId);
    }

    /**
     * Update verified family location.
     *
     * @param selectedMoveAnganwadiAreaId Id of anganwadi area.
     * @param selectedMoveAshaAreaId      Id of asha area.
     * @param familyList                  Returns list of family.
     */
    @PutMapping(value = "/updateVerifiedFamilyLocation")
    public void updateVerifiedFamilyLocation(
            @RequestParam("selectedMoveAnganwadiAreaId") Integer selectedMoveAnganwadiAreaId,
            @RequestParam("selectedMoveAshaAreaId") Integer selectedMoveAshaAreaId,
            @RequestBody List<String> familyList) {
        familyHealthSurveyService.updateVerifiedFamilyLocation(familyList, selectedMoveAnganwadiAreaId, selectedMoveAshaAreaId);
    }
}
