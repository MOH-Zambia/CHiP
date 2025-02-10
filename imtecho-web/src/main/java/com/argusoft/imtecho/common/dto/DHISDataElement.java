package com.argusoft.imtecho.common.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class DHISDataElement {
    List<DataElementPayload> dataValues;

    @Getter
    @Setter
    public static class DataElementPayload {
        private String dataElement;
        private String categoryOptionCombo;
        private String orgUnit;
        private int period;
        private int value;
    }
}
