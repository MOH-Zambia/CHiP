package com.argusoft.sewa.android.app.OCR;

import static org.androidannotations.annotations.EBean.Scope.Singleton;

import android.content.Context;

import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.OcrFormBean;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.j256.ormlite.dao.Dao;

import org.androidannotations.annotations.EBean;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.sql.SQLException;

@EBean(scope = Singleton)
public class OcrServiceImpl implements OcrService {

    @OrmLiteDao(helper = DBConnection.class)
    Dao<OcrFormBean, Integer> ocrFormBeanDao;
    Context context;


    @Override
    public String getConfigJsonForForm(String formName) {
        String formJson = null;
        try {
            formJson = ocrFormBeanDao.queryForEq(FieldNameConstants.FORM_NAME, formName).get(0).getFormJson();
        } catch (SQLException e) {
            Log.e(OcrServiceImpl.class.getName(), e.getMessage());
            SewaUtil.generateToast(context, e.getMessage());
            return null;
        }
        return formJson;
    }
}
