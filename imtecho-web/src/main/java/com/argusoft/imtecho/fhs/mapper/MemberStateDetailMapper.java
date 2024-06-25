/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.MemberStateDetailDto;
import com.argusoft.imtecho.fhs.model.MemberStateDetailEntity;

/**
 * <p>
 * Mapper for member state in order to convert dto to model or model to dto.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 11:00 AM
 */
public class MemberStateDetailMapper {

    private MemberStateDetailMapper() {
        throw new IllegalStateException("Utility Class");
    }

    /**
     * Convert member state dto to entity.
     *
     * @param memberStateDetailDto Details of member state.
     * @return Returns member state entity.
     */
    public static MemberStateDetailEntity getMemberStateDetailEntity(MemberStateDetailDto memberStateDetailDto) {
        if (memberStateDetailDto != null) {
            MemberStateDetailEntity memberStateDetailEntity = new MemberStateDetailEntity();
            memberStateDetailEntity.setMemberId(memberStateDetailDto.getMemberId());
            memberStateDetailEntity.setFromState(memberStateDetailDto.getFromState());
            memberStateDetailEntity.setToState(memberStateDetailDto.getToState());
            memberStateDetailEntity.setParent(memberStateDetailDto.getParent());
            memberStateDetailEntity.setComment(memberStateDetailDto.getComment());
            memberStateDetailEntity.setCreatedBy(memberStateDetailDto.getCreatedBy());
            memberStateDetailEntity.setCreatedOn(memberStateDetailDto.getCreatedOn());
            return memberStateDetailEntity;
        }
        return null;
    }
}
