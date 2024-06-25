package com.argusoft.imtecho.common.controller;

import com.argusoft.imtecho.common.dto.FieldValueMasterDto;
import com.argusoft.imtecho.common.service.FieldMasterService;
import com.argusoft.imtecho.common.service.FieldValueService;
import java.util.Arrays;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 *<p>Defines rest endpoints for constant field value</p>
 * @author shrey
 * @since 26/08/2020 10:30
 */
@RestController
@RequestMapping("/api/constants")
public class FieldValueController {
    
    @Autowired
    FieldValueService fieldValueService;
    
    @Autowired
    FieldMasterService fieldMasterService;

    /**
     * Returns a list of constant field value of given key
     * @param key A constant key
     * @return A list of FieldValueMasterDto
     */
    @GetMapping(value = "")
    public List<FieldValueMasterDto> getConstantsByKey(@RequestParam("key") String key) {
        List<Integer> keys = fieldMasterService.getIdsByNameForFieldConstants(Arrays.asList(key));
        return fieldValueService.getFieldValuesByList(keys).get(key);
    }
}
