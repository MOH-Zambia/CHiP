package com.argusoft.imtecho.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.UUID;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * <p>Defines fields related to menu group</p>
 * @author jaynam
 * @since 26/08/2020 5:30
 */
@Data
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class MenuGroupDto {

    private Integer id;
    private String groupName;
    private Boolean isActive;
    private Integer parentGroup;
    private String parentGroupName;
    private String type;
    private UUID groupUUID;

}
