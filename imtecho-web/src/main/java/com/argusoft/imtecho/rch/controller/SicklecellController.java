//package com.argusoft.imtecho.rch.controller;
//
//import com.argusoft.imtecho.rch.dto.SicklecellScreeningDto;
//import com.argusoft.imtecho.rch.service.SicklecellService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.*;
//
///**
// *
// * <p>
// * Define APIs for sickle cell.
// * </p>
// *
// * @author smeet
// * @since 26/08/20 10:19 AM
// */
//@RestController
//@RequestMapping("/api/sicklecell")
//public class SicklecellController {
//
//    @Autowired
//    SicklecellService sicklecellService;
//
//    /**
//     * Add sickle cell details.
//     * @param sicklecellScreeningDto Details of sickle cell.
//     */
//    @PostMapping(value = "")
//    public void create(@RequestBody SicklecellScreeningDto sicklecellScreeningDto) {
//        sicklecellService.create(sicklecellScreeningDto);
//    }
//}
