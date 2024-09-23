package com.argusoft.imtecho.fhs.dto;

import lombok.Data;
import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 * DTO for Service Interaction Details.
 * </p>
 */
@Data
public class InteractionDto {

    private Integer memberId;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<MalariaDto> malariaDetails = new ArrayList<>();

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<TuberculosisDto> tbDetails = new ArrayList<>();

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<CovidDto> covidDetails = new ArrayList<>();

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<AncDto> ancDetails = new ArrayList<>();

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<ChildServiceDto> childServiceDetails = new ArrayList<>();

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<PncChildDetailsDto> pncChildDetails = new ArrayList<>();

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<PncMotherDetailsDto> pncMotherDetails = new ArrayList<>();

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<WpdMotherDetailsDto> wpdMotherDetails = new ArrayList<>();

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<WpdChildDetailsDto> wpdChildDetails = new ArrayList<>();

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<HivDto> hivDetails = new ArrayList<>();
}
