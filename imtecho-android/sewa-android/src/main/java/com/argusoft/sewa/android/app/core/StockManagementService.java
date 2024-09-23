package com.argusoft.sewa.android.app.core;

import java.sql.SQLException;

public interface StockManagementService {
    public Integer getStockAmountById(int medicineId) throws SQLException;
}
