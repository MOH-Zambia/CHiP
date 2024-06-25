package com.argusoft.imtecho.config;

import com.argusoft.imtecho.common.util.ConstantUtil;
import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import java.io.File;

@Configuration(value = "FlywayMigrationInitializerConfiguration")
public class FlywayMigrationInitializer {

    @Autowired
    private DataSource dataSource;

    public void migrate() {
        String scriptLocation = "db/migration2";
        String implLocation = "db/" + ConstantUtil.IMPLEMENTATION_TYPE + File.separator;
        Flyway flyway = Flyway.configure()
                .locations(scriptLocation, implLocation)
                .baselineOnMigrate(Boolean.TRUE)
                .dataSource(dataSource)
                .validateOnMigrate(false)
                .outOfOrder(true)
                .baselineVersion("1").load();
        flyway.migrate();
    }

}
