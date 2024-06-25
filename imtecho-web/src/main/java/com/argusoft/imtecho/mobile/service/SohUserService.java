package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.mobile.dto.SohUserDto;

import java.util.Optional;

public interface SohUserService {

    SohUserDto save(SohUserDto sohUser) throws ImtechoUserException;

    SohUserDto sohRegisterSendOTP(SohUserDto sohUser) throws ImtechoUserException;

    Optional<SohUserDto> activeCode(int id, int locationId);

    Optional<SohUserDto> inActiveCode(int id, String reason);

}
