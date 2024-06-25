/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.model;

import com.argusoft.imtecho.common.util.AESEncryption;
import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 *
 * <p>
 *     Define imt_member aadhar entity and its fields.
 * </p>
 * @author kunjan
 * @since 26/08/20 11:00 AM
 *
 */
@javax.persistence.Entity
@Table(name = "imt_member")
public class MemberAdharEntity implements Serializable {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

}
