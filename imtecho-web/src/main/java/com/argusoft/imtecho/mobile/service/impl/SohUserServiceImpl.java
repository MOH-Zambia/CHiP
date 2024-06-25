package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.common.dao.RoleDao;
import com.argusoft.imtecho.common.dto.UserLocationDto;
import com.argusoft.imtecho.common.dto.UserMasterDto;
import com.argusoft.imtecho.common.model.RoleMaster;
import com.argusoft.imtecho.common.service.SmsService;
import com.argusoft.imtecho.common.service.UserService;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.EmailUtil;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.location.model.LocationMaster;
import com.argusoft.imtecho.mobile.constants.SOHUserState;
import com.argusoft.imtecho.mobile.dao.SohUserDao;
import com.argusoft.imtecho.mobile.dto.SohUserDto;
import com.argusoft.imtecho.mobile.mapper.SohUserMapper;
import com.argusoft.imtecho.mobile.model.SohUser;
import com.argusoft.imtecho.mobile.service.SohUserService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedList;
import java.util.Map;
import java.util.Optional;
import java.util.Random;

@Service
@Transactional
public class SohUserServiceImpl implements SohUserService {

    @Autowired
    private SohUserDao sohUserDao;

    @Autowired
    private UserService userService;

    @Autowired
    private EmailUtil emailUtil;

    @Autowired
    private LocationMasterDao locationMasterDao;

    @Autowired
    private SmsService smsService;

    @Autowired
    private RoleDao roleDao;
    
    Random rand = new Random();

    public SohUserDto sohRegisterSendOTP(SohUserDto sohUserDto) throws ImtechoUserException {

        if (StringUtils.isBlank(sohUserDto.getDesignation())
                || StringUtils.isBlank(sohUserDto.getMobileNo())
                || StringUtils.isBlank(sohUserDto.getName())
                || StringUtils.isBlank(sohUserDto.getPurpose())
                || StringUtils.isBlank(sohUserDto.getOrganization())) {
            throw new ImtechoUserException("Please fill all the fields", 0);
        }

        if (sohUserDao.countUserByMobileNo(sohUserDto.getMobileNo()) >= 1) {
            throw new ImtechoUserException("Mobile number already register. Please login using your existing username and password.", 0);
        }


        String otp = String.format("%04d", rand.nextInt(9999));
        String message = "Your OTP for State of Health Application is " + otp;

        String  mobileNo = sohUserDto.getMobileNo();
        try {
            smsService.sendSms(mobileNo, message, true, "STATE_OF_HEALTH_REGISTRATION_PROCESS_OTP");
        } catch (Exception e) {
            throw new ImtechoUserException("OTP sending failed. Please check mobile number.", 0);
        }

        SohUser sohUser = SohUserMapper.getSohUser(sohUserDto);
        sohUser.setState(SOHUserState.OTP_SEND.getState());
        sohUser.setOtp(otp);
        sohUserDao.deleteByMobileNo(sohUserDto.getMobileNo());      // delete by mobile no, If user trying to recreate account incase of OTP sending failed so deleting previous data
        sohUserDao.save(sohUser);
        sohUserDao.flush();
        return SohUserMapper.getSohUserDto(sohUser);

    }

    @Override
    public SohUserDto save(SohUserDto sohUserDto) throws ImtechoUserException {

        SohUser sohUserDb = sohUserDao.retrieveById(sohUserDto.getId());
        if (!sohUserDb.getOtp().equalsIgnoreCase(sohUserDto.getOtp())) {
            throw new ImtechoUserException("Please enter valid opt.", 0);
        }
        sohUserDb.setState(SOHUserState.PENDING.getState());
        sohUserDao.save(sohUserDb);
        String[] sendTo = new String[1];
        sendTo[0] = ConstantUtil.SOH_REGISTER_REQUEST_ACCESS_EMAIL;
        String subject = ConstantUtil.SOH_REGISTER_REQUEST_ACCESS_SUBJECT;
        StringBuilder messageBody = new StringBuilder();
        messageBody.append("Name : " + sohUserDto.getName());
        messageBody.append("\nDesignation : " + sohUserDto.getDesignation());
        messageBody.append("\nOrganization : " + sohUserDto.getOrganization());
        messageBody.append("\nPurpose : " + sohUserDto.getPurpose());
        messageBody.append("\nContact Number : " + sohUserDto.getMobileNo());
        emailUtil.sendEmail(sendTo, subject, messageBody.toString());
        return SohUserMapper.getSohUserDto(sohUserDb);
    }

    @Override
    public Optional<SohUserDto> activeCode(int id, int locationId) {
        SohUser sohUser = sohUserDao.retrieveById(id);
        sohUser.setState(SOHUserState.ACTIVE.getState());
        Integer userId = createUser(locationId, sohUser);
        sohUser.setUserId(userId);
        sohUserDao.saveOrUpdate(sohUser);
        return Optional.of(SohUserMapper.getSohUserDto(sohUser));
    }

    @Override
    public Optional<SohUserDto> inActiveCode(int id, String reason) {
        SohUser sohUser = sohUserDao.retrieveById(id);
        sohUser.setState(SOHUserState.INACTIVE.getState());
        sohUser.setDisapprovalReason(reason);
        sohUserDao.saveOrUpdate(sohUser);

        String mobileNumber = sohUser.getMobileNo();
        String message = "Reason for disapproval is: " + reason;
        smsService.sendSms(mobileNumber, message, true, "SOH_INACTIVE_CODE");
        return Optional.of(SohUserMapper.getSohUserDto(sohUser));
    }

    private Integer createUser(int locationId, SohUser sohUser) {

        UserLocationDto locationDto = new UserLocationDto();
        LocationMaster locationMaster = locationMasterDao.retrieveById(locationId);
        locationDto.setLocationId(locationId);
        locationDto.setType(locationMaster.getType());
        LinkedList<UserLocationDto> addedLocations = new LinkedList<>();
        addedLocations.add(locationDto);

        String loginCode = userService.getRandomLoginCode();

        RoleMaster roleMaster = roleDao.retrieveByCode(ConstantUtil.STATE_OF_HEALTH_USER_ROLE);

        UserMasterDto userMasterDto = new UserMasterDto();
        userMasterDto.setAddedLocations(addedLocations);
        userMasterDto.setFirstName(sohUser.getName());
        userMasterDto.setLastName(sohUser.getName());
        userMasterDto.setUserName(sohUser.getName().replace(" ", "").toLowerCase() + "_" + loginCode);
        userMasterDto.setLoginCode(loginCode);
        userMasterDto.setPassword(loginCode);
        userMasterDto.setMobileNumber(sohUser.getMobileNo());
        userMasterDto.setRoleId(roleMaster.getId());
        Map<String,Integer> idMap = userService.createOrUpdate(userMasterDto);
        String mobileNumber = sohUser.getMobileNo();
        String message = "Your Login Code for State of Health Application is " + userMasterDto.getLoginCode();
        smsService.sendSms(mobileNumber, message, true, "STATE_OF_HEALTH_LOGIN_CODE");
        return idMap.get("userId");
    }

}
