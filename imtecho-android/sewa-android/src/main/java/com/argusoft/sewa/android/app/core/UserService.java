package com.argusoft.sewa.android.app.core;

import com.argusoft.sewa.android.app.model.LoginBean;

public interface UserService {

    LoginBean getLoginBeanFromDb();

    void createOrUpdate(LoginBean loginBean);
}
