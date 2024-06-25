package com.argusoft.imtecho.mobile.mapper;

import com.argusoft.imtecho.mobile.dto.SohUserDto;
import com.argusoft.imtecho.mobile.model.SohUser;

public class SohUserMapper {

    private SohUserMapper() {
        throw new IllegalStateException("Utility Class");
    }

    public static SohUserDto getSohUserDto(SohUser sohUser) {
        SohUserDto sohUserDto = new SohUserDto();
        sohUserDto.setId(sohUser.getId());
        sohUserDto.setDesignation(sohUser.getDesignation());
        sohUserDto.setOrganization(sohUser.getOrganization());
        sohUserDto.setName(sohUser.getName());
        sohUserDto.setPurpose(sohUser.getPurpose());
        sohUserDto.setState(sohUser.getState());
        sohUserDto.setMobileNo(sohUser.getMobileNo());
        return sohUserDto;
    }

    public static SohUser getSohUser(SohUserDto sohUserDto) {
        SohUser sohUser = new SohUser();
        sohUser.setId(sohUserDto.getId());
        sohUser.setDesignation(sohUserDto.getDesignation());
        sohUser.setName(sohUserDto.getName());
        sohUser.setPurpose(sohUserDto.getPurpose());
        sohUser.setMobileNo(sohUserDto.getMobileNo());
        sohUser.setOrganization(sohUserDto.getOrganization());
        return sohUser;
    }

}
