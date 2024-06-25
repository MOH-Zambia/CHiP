/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.rch.model.AdolescentScreeningEntity;

import java.util.List;

/**
 * @author utkarsh
 */
public interface AdolescentDao extends GenericDao<AdolescentScreeningEntity, Integer> {

    public AdolescentScreeningEntity retrieveMemberById(Integer id);

    /**
     * Retrieves member by unique Health id.
     * @param uniqueHealthId Unique Health id of member.
     * @return Returns member details by id.
     */
    AdolescentScreeningEntity retrieveMemberByUniqueHealthId(String  uniqueHealthId);


    public AdolescentScreeningEntity updateMember(AdolescentScreeningEntity adolescentScreeningEntity);


    public AdolescentScreeningEntity createMember(AdolescentScreeningEntity adolescentScreeningEntity);

    public List<MemberDto> getMembersOfSchool(Long schoolActualId, Integer standard);

    public List<MemberDto> getMembersByAdvanceSearch(Integer parentId, String searchText, Integer standard);
}
