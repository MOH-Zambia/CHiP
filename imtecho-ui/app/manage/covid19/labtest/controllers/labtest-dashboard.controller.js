(function () {
    function LabTestController(Mask, toaster, $state, QueryDAO, AuthenticateService, PagingService, GeneralUtil, CovidService, $sessionStorage, $rootScope) {
        var labtest = this;
        labtest.referredForCovidLabTest = [];
        labtest.today = moment();
        labtest.filteredCollectionDate = null;
        labtest.collectionDate = labtest.receiveDate = labtest.resultDate = labtest.transferDate = labtest.today;

        labtest.init = () => {
            labtest.selectedTab = "sample-collection-tab";
            Mask.show();
            AuthenticateService.getLoggedInUser().then((user) => {
                labtest.user = user.data
                return QueryDAO.execute({
                    code: 'retrieve_health_infra_for_user',
                    parameters: {
                        userId: labtest.user.id
                    }
                });
            }).then((response) => {
                if (Array.isArray(response.result) && response.result.length) {
                    if (response.result.length > 1) {
                        labtest.rights = {};
                        labtest.multipleHealthInfrastructuresAssigned = true;
                        return Promise.reject({ data: { message: 'Multiple Health Infrastructures Assigned' } });
                    } else {
                        return AuthenticateService.getAssignedFeature($state.current.name);
                    }
                } else {
                    labtest.rights = {};
                    labtest.noHealthInfrastructureAssigned = true;
                    return Promise.reject({ data: { message: 'No Health Infrastructure Assigned' } });
                }
            }).then((response) => {
                labtest.rights = response.featureJson
                if (!labtest.rights) {
                    labtest.rights = {};
                }
                labtest.retrieveDistinctHealthInfraForReceiveTab();
                labtest.retrieveDistinctHealthInfraForResultTab();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.sampleCollectionTabSelected = () => {
            labtest.markAll = false;
            labtest.filteredWard = null;
            labtest.retrieveDistinctWardNameForCollection();
            labtest.retrievePagingService = PagingService.initialize();
            labtest.getSampleCollectionList();
        }

        labtest.getSampleCollectionList = () => {
            labtest.criteria = { limit: labtest.retrievePagingService.limit, offset: labtest.retrievePagingService.offSet, search: labtest.search, wardId: labtest.filteredWard };
            let sampleCollectionList = labtest.sampleCollectionList;
            Mask.show();
            PagingService.getNextPage(CovidService.retrieveSampleCollectionList, labtest.criteria, sampleCollectionList, null).then((response) => {
                labtest.sampleCollectionList = response;
                labtest.sampleCollectionList.forEach((sample) => {
                    sample.labTestGeneratedNumber = sample.labTestNumber && sample.labTestNumber != 'null' ? `${sample.labTestId}(${sample.labTestNumber})` : sample.labTestId;
                    if (sample.labCollectionStatus === 'SAMPLE_COLLECTED') {
                        sample.checkBoxDisabled = true;
                    }
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.collectSamples = () => {
            labtest.minimumSampleCollectionDate = moment('01/02/2020', 'DD-MM-YYYY');
            labtest.collectionTime = labtest.receiveTime = labtest.resultTime = new Date(
                moment().year(),
                moment().month(),
                moment().date(),
                moment().hours(),
                moment().minutes()
            );
            Mask.show();
            labtest.retrieveMarkedMembersList('covid19_lab_test_pending_sample_collection_all', labtest.sampleCollectionList).then(() => {
                labtest.currentSampleCollectionMember = labtest.markedMembersList[0];
                if (labtest.currentSampleCollectionMember.isSameHealthInfrastructure) {
                    labtest.showIsSameHealthInfrastructure = true
                } else {
                    labtest.showIsSameHealthInfrastructure = false;
                    labtest.isSameHealthInfrastructure = false
                }
                labtest.retrieveDistrictLocationsAndHealthInfrastructure();
                $("#sampleCollection").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.saveSampleCollectionDetails = () => {
            labtest.sampleCollectionForm.$setSubmitted();
            if (labtest.sampleCollectionForm.$valid) {
                let queryDto = [];
                const collectionDate = moment(labtest.getDate(labtest.collectionDate, labtest.collectionTime)).format('DD-MM-YYYY HH:mm:ss');
                labtest.markedMembersList.forEach((member, index) => {
                    queryDto.push({
                        code: 'lab_test_dashboard_save_sample_collection',
                        parameters: {
                            id: member.labCollectionId,
                            healthInfraId: labtest.healthInfraId || null,
                            collectionDate: collectionDate,
                            userId: labtest.user.id
                        },
                        sequence: index + 1
                    })
                })
                Mask.show();
                QueryDAO.executeAll(queryDto).then((response) => {
                    toaster.pop('success', 'Details saved successfully');
                    $("#sampleCollection").modal('hide');
                    labtest.resetSampleCollection();
                    labtest.sampleCollectionTabSelected();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        }

        labtest.printSampleCollection = (member) => {
            CovidService.downloadOpdLabSrfPdf(member.labCollectionId).then((response) => {
                if (response.data !== null && navigator.msSaveBlob) {
                    return navigator.msSaveBlob(new Blob([response.data], { type: "application/pdf;charset=UTF-8'" }));
                }
                var a = $("<a style='display: none;'/>");
                var url = window.URL.createObjectURL(new Blob([response.data], { type: "application/pdf;charset=UTF-8'" }));
                a.attr("href", url);
                a.attr("download", `${member.labTestGeneratedNumber}_${member.memberDetail}.pdf`);
                $("body").append(a);
                a[0].click();
                window.URL.revokeObjectURL(url);
                a.remove();
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        labtest.markSampleCollectionArchive = (member) => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_lab_test_mark_sample_collection_archive',
                parameters: {
                    id: member.labCollectionId
                }
            }).then(() => {
                toaster.pop('success', 'Member marked as archive successfully');
                labtest.resetSampleCollection();
                labtest.sampleCollectionTabSelected();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.sampleReceiveTabSelected = () => {
            labtest.markAll = false;
            labtest.filteredCollectionDate = null;
            labtest.filteredHealthInfra = null;
            labtest.filteredWard = null;
            labtest.retrieveDistinctWardNameForReceive();
            labtest.retrievePagingService = PagingService.initialize();
            labtest.getSampleReceiveList();
        }

        labtest.getSampleReceiveList = () => {
            labtest.criteria = {
                limit: labtest.retrievePagingService.limit,
                offset: labtest.retrievePagingService.offSet,
                search: labtest.search,
                healthInfra: labtest.filteredHealthInfra,
                collectionDate: labtest.filteredCollectionDate ? moment(labtest.filteredCollectionDate).format('DD-MM-YYYY') : null,
                wardId: labtest.filteredWard
            };
            let sampleReceiveList = labtest.sampleReceiveList;
            Mask.show();
            PagingService.getNextPage(CovidService.retrieveSampleReceiveList, labtest.criteria, sampleReceiveList, null).then((response) => {
                labtest.sampleReceiveList = response;
                labtest.sampleReceiveList.forEach((member) => {
                    member.sampleReceiveTime = moment(member.sampleCollectionDate).format('DD-MM-YYYY HH:mm:ss');
                    member.hoursLapsed = moment().diff(member.sampleCollectionDate, 'hours');
                    member.showInRed = member.hoursLapsed > 10;
                    member.labTestGeneratedNumber = member.labTestNumber && member.labTestNumber != 'null' ? `${member.labTestId}(${member.labTestNumber})` : member.labTestId;
                    if (!member.memberDetailUpdated) {
                        member.memberDetail = member.isTransferred ? member.memberDetail.concat(" (T)") : member.memberDetail;
                        member.memberDetailUpdated = true
                    }
                })
                labtest.markAll ? labtest.selectMarkAll(labtest.sampleReceiveList) : null;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.acceptMembers = () => {
            labtest.currentSampleReceiveStatus = 'SAMPLE_ACCEPTED';
            labtest.minimumSampleReceiveDate = moment('01/02/2020', 'DD-MM-YYYY');
            labtest.collectionTime = labtest.receiveTime = labtest.resultTime = new Date(
                moment().year(),
                moment().month(),
                moment().date(),
                moment().hours(),
                moment().minutes()
            );
            Mask.show();
            labtest.retrieveMarkedMembersList('covid19_lab_test_pending_sample_receive_all', labtest.sampleReceiveList).then(() => {
                $("#sampleReceive").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labtest.rejectMembers = () => {
            labtest.minimumSampleReceiveDate = moment('01/02/2020', 'DD-MM-YYYY');
            labtest.currentSampleReceiveStatus = 'SAMPLE_REJECTED';
            labtest.collectionTime = labtest.receiveTime = labtest.resultTime = new Date(
                moment().year(),
                moment().month(),
                moment().date(),
                moment().hours(),
                moment().minutes()
            );
            Mask.show();
            labtest.retrieveMarkedMembersList('covid19_lab_test_pending_sample_receive_all', labtest.sampleReceiveList).then(() => {
                $("#sampleReceive").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labtest.transferMembers = () => {
            labtest.collectionTime = labtest.receiveTime = labtest.resultTime = labtest.transferTime = new Date(
                moment().year(),
                moment().month(),
                moment().date(),
                moment().hours(),
                moment().minutes()
            );
            labtest.retrieveDistrictLocationsAndHealthInfrastructure();
            Mask.show();
            labtest.retrieveMarkedMembersList('covid19_lab_test_pending_sample_receive_all', labtest.sampleReceiveList).then(() => {
                $("#transferSample").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labtest.saveSampleReceiveDetails = () => {
            labtest.sampleReceiveForm.$setSubmitted();
            if (labtest.sampleReceiveForm.$valid) {
                const receiveDate = moment(labtest.getDate(labtest.receiveDate, labtest.receiveTime)).format('DD-MM-YYYY HH:mm:ss');
                let queryDto = [];
                labtest.markedMembersList.forEach((member, index) => {
                    queryDto.push({
                        code: 'lab_test_dashboard_mark_sample_received_status',
                        parameters: {
                            id: member.labCollectionId,
                            receiveDate: receiveDate,
                            userId: labtest.user.id,
                            status: labtest.currentSampleReceiveStatus,
                            labTestNumber: labtest.labTestNumber != null ? labtest.labTestNumber.replace(/:/g, "").replace(/'/g, "''") : null,
                            rejectionRemarkSelected: labtest.rejectionRemarkSelected,
                            rejectionRemarks: labtest.rejectionRemarks != null ? labtest.rejectionRemarks.replace(/:/g, "").replace(/'/g, "''") : null
                        },
                        sequence: index + 1
                    })
                })
                Mask.show();
                QueryDAO.executeAll(queryDto).then((response) => {
                    toaster.pop('success', 'Details saved successfully');
                    $("#sampleReceive").modal('hide');
                    labtest.resetSampleReceive();
                    labtest.sampleReceiveTabSelected();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                })
            }
        }

        labtest.saveTransferDetails = () => {
            labtest.transferSampleForm.$setSubmitted();
            if (labtest.transferSampleForm.$valid) {
                let sequence = 1;
                let queryDto = [];
                const queryHistoryDto = [];
                const queryUpdateDto = [];
                const transferDate = moment(labtest.getDate(labtest.transferDate, labtest.transferTime)).format('DD-MM-YYYY HH:mm:ss');
                labtest.markedMembersList.forEach((member) => {
                    queryHistoryDto.push({
                        code: 'lab_test_insert_transfer_history',
                        parameters: {
                            labTestId: member.labCollectionId,
                            healthInfraFrom: member.healthInfraTo,
                            healthInfraTo: labtest.healthInfraId,
                            transferDate: transferDate,
                            userId: labtest.user.id
                        },
                        sequence: sequence
                    })
                    sequence++;
                });
                labtest.markedMembersList.forEach((member) => {
                    queryUpdateDto.push({
                        code: 'lab_test_transfer_update',
                        parameters: {
                            labTestId: member.labCollectionId,
                            healthInfraTo: labtest.healthInfraId
                        },
                        sequence: sequence
                    })
                    sequence++;
                });
                queryDto = [...queryHistoryDto, ...queryUpdateDto];
                Mask.show();
                QueryDAO.executeAll(queryDto).then((response) => {
                    $("#transferSample").modal('hide');
                    toaster.pop('success', "Members transferred successfully");
                    labtest.markedMembersList = [];
                    labtest.sampleReceiveTabSelected();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                })
            }
        }

        labtest.resultTabSelected = () => {
            labtest.markAll = false;
            labtest.filteredCollectionDate = null;
            labtest.filteredHealthInfra = null;
            labtest.filteredWard = null;
            labtest.retrieveDistinctWardNameForResult();
            labtest.retrievePagingService = PagingService.initialize();
            labtest.getResultList();
        }

        labtest.getResultList = () => {
            labtest.criteria = {
                limit: labtest.retrievePagingService.limit,
                offset: labtest.retrievePagingService.offSet,
                search: labtest.search,
                healthInfra: labtest.filteredHealthInfra,
                wardId: labtest.filteredWard,
                collectionDate: labtest.filteredCollectionDate ? moment(labtest.filteredCollectionDate).format('DD-MM-YYYY') : null
            };
            let resultList = labtest.resultList;
            Mask.show();
            PagingService.getNextPage(CovidService.retrieveResultList, labtest.criteria, resultList, null).then((response) => {
                labtest.resultList = response;
                labtest.resultList.forEach((result) => {
                    result.labTestGeneratedNumber = result.labTestNumber && result.labTestNumber != 'null' ? `${result.labTestId}(${result.labTestNumber})` : result.labTestId;
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.enterResult = (mode) => {
            labtest.resultMode = mode;
            labtest.minimumResultDate = moment('01/02/2020', 'DD-MM-YYYY');
            labtest.collectionTime = labtest.receiveTime = labtest.resultTime = new Date(
                moment().year(),
                moment().month(),
                moment().date(),
                moment().hours(),
                moment().minutes(),
            );
            labtest.result = 'NEGATIVE';
            Mask.show();
            labtest.retrieveMarkedMembersList('covid19_lab_test_pending_sample_result_all', labtest.resultList).then(() => {
                $("#resultModal").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labtest.openResultModal = (member, mode) => {
            labtest.resultMode = mode;
            labtest.currentResultMember = member;
            // if (labtest.resultMode === 'INDETERMINATE') {
            //     labtest.currentResultMember.minimumResultDate = moment(labtest.currentResultMember.indeterminateDate);
            // } else {
            //     labtest.currentResultMember.minimumResultDate = moment(labtest.currentResultMember.sampleReceiveDate);
            // }
            labtest.currentResultMember.minimumResultDate = moment('01/02/2020', 'DD-MM-YYYY');
            labtest.collectionTime = labtest.receiveTime = labtest.resultTime = new Date(
                moment().year(),
                moment().month(),
                moment().date(),
                moment().hours(),
                moment().minutes(),
            );
            labtest.result = 'NEGATIVE';
            $("#resultModal").modal({ backdrop: 'static', keyboard: false });
        }

        labtest.saveResultDetails = () => {
            labtest.resultForm.$setSubmitted();
            if (labtest.resultForm.$valid) {
                const resultDate = moment(labtest.getDate(labtest.resultDate, labtest.resultTime)).format('DD-MM-YYYY HH:mm:ss');
                let queryDto = [];
                let resultDto = {};
                let memberList = [];
                // No checkbox available for sent for confirmation tab. So need to add only current result member.
                if (labtest.selectedTab === 'indeterminate-tab') {
                    memberList.push(labtest.currentResultMember);
                } else {
                    memberList = labtest.markedMembersList;
                }
                memberList.forEach((member, index) => {
                    if (labtest.result === 'INDETERMINATE') {
                        resultDto = {
                            code: 'lab_test_dashboard_mark_indeterminate',
                            parameters: {
                                id: member.labCollectionId,
                                resultDate: resultDate,
                                userId: labtest.user.id,
                            },
                            sequence: index + 1
                        }
                    } else {
                        resultDto = {
                            code: 'lab_test_dashboard_mark_result_status',
                            parameters: {
                                id: member.labCollectionId,
                                resultDate: resultDate,
                                userId: labtest.user.id,
                                result: labtest.result,
                                labName: labtest.labName,
                                isRecollect: labtest.isRecollect,
                                otherResultRemarksSelected: labtest.otherResultRemarksSelected,
                                resultRemarks: labtest.resultRemarks
                            },
                            sequence: index + 1
                        }
                    }
                    queryDto.push(resultDto);
                });
                Mask.show();
                QueryDAO.executeAll(queryDto).then((response) => {
                    toaster.pop('success', 'Details saved successfully');
                    $("#resultModal").modal('hide');
                    labtest.resetResult();
                    labtest.selectedTab === 'indeterminate-tab' ? labtest.indeterminateTabSelected() : labtest.resultTabSelected();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                })
            }
        }

        labtest.openEditResultModal = (member, mode) => {
            labtest.resultMode = mode;
            labtest.currentResultMember = member;
            labtest.currentResultMember.resultDate = new Date(labtest.currentResultMember.labResultEntryOn);
            labtest.currentResultMember.resultTime = new Date(labtest.currentResultMember.labResultEntryOn);
            $("#editResultModal").modal({ backdrop: 'static', keyboard: false });
        }

        labtest.editResult = () => {
            labtest.resultForm.$setSubmitted();
            if (labtest.editResultForm.$valid) {
                Mask.show();
                const resultDate = moment(labtest.getDate(labtest.currentResultMember.resultDate, labtest.currentResultMember.resultTime)).format('DD-MM-YYYY HH:mm:ss');
                QueryDAO.execute({
                    code: 'covid19_edit_lab_result',
                    parameters: {
                        id: labtest.currentResultMember.labCollectionId,
                        resultDate: resultDate,
                        userId: labtest.user.id,
                        result: labtest.currentResultMember.labResult,
                        isRecollect: labtest.currentResultMember.isRecollect,
                        otherResultRemarksSelected: labtest.currentResultMember.otherResultRemarksSelected,
                        resultRemarks: labtest.currentResultMember.resultRemarks
                    }
                }).then(() => {
                    toaster.pop('success', 'Result Updated successfully');
                    $("#editResultModal").modal('hide');
                    labtest.resultConfirmedTabSelected();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(() => {
                    Mask.hide();
                })
            }
        }


        labtest.indeterminateTabSelected = () => {
            labtest.retrievePagingService = PagingService.initialize();
            labtest.getIndeterminateList();
        }

        labtest.getIndeterminateList = () => {
            labtest.criteria = { limit: labtest.retrievePagingService.limit, offset: labtest.retrievePagingService.offSet, search: labtest.search };
            let indeterminateList = labtest.indeterminateList;
            Mask.show();
            PagingService.getNextPage(CovidService.retrieveIndeterminateList, labtest.criteria, indeterminateList, null).then((response) => {
                labtest.indeterminateList = response;
                labtest.indeterminateList.forEach((result) => {
                    result.labTestGeneratedNumber = result.labTestNumber && result.labTestNumber != 'null' ? `${result.labTestId}(${result.labTestNumber})` : result.labTestId;
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.openAdmissionDetailsModal = (member) => {
            labtest.currentAdmissionDisplayMember = member;
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_retrieve_admission_details',
                parameters: {
                    admissionId: member.admissionId
                }
            }).then((response) => {
                Object.assign(labtest.currentAdmissionDisplayMember, response.result[0]);
                labtest.currentAdmissionDisplayMember.symptomsArray = [];
                if (labtest.currentAdmissionDisplayMember.fever) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('Fever')
                }
                if (labtest.currentAdmissionDisplayMember.cough) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('Cough')
                }
                if (labtest.currentAdmissionDisplayMember.breathlessness) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('Breathlessness')
                }
                if (labtest.currentAdmissionDisplayMember.sari) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('SARI')
                }
                if (labtest.currentAdmissionDisplayMember.hiv) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('HIV')
                }
                if (labtest.currentAdmissionDisplayMember.heartPatient) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('Heart Patient')
                }
                if (labtest.currentAdmissionDisplayMember.diabetes) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('Diabetes')
                }
                if (labtest.currentAdmissionDisplayMember.copd) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('COPD')
                }
                if (labtest.currentAdmissionDisplayMember.hypertension) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('Hypertension')
                }
                if (labtest.currentAdmissionDisplayMember.renalCondition) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('Renal Condition')
                }
                if (labtest.currentAdmissionDisplayMember.immunocompromized) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('Immunocomprized')
                }
                if (labtest.currentAdmissionDisplayMember.maligancy) {
                    labtest.currentAdmissionDisplayMember.symptomsArray.push('Maligancy')
                }
                labtest.currentAdmissionDisplayMember.symptoms = labtest.currentAdmissionDisplayMember.symptomsArray.join(', ');
                labtest.currentAdmissionDisplayMember.emergencyDetails = "";
                if (labtest.currentAdmissionDisplayMember.emergencyContactName != null) {
                    labtest.currentAdmissionDisplayMember.emergencyDetails.concat(labtest.currentAdmissionDisplayMember.emergencyContactName);
                }
                if (labtest.currentAdmissionDisplayMember.emergencyContactNumber != null) {
                    if (labtest.currentAdmissionDisplayMember.emergencyDetails.length) {
                        labtest.currentAdmissionDisplayMember.emergencyDetails.concat(` (${labtest.currentAdmissionDisplayMember.emergencyContactNumber})`);
                    } else {
                        labtest.currentAdmissionDisplayMember.emergencyDetails.concat(labtest.currentAdmissionDisplayMember.emergencyContactNumber);
                    }
                }
                $("#admissionDisplay").modal({ backdrop: 'static', keyboard: false });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labtest.closeAdmissionDetailsModal = () => {
            $("#admissionDisplay").modal('hide');
            labtest.currentAdmissionDisplayMember = null;
        }

        labtest.resultConfirmedTabSelected = () => {
            labtest.markAll = false;
            labtest.retrievePagingService = PagingService.initialize();
            labtest.getResultConfirmedList();
        }

        labtest.getResultConfirmedList = () => {
            labtest.criteria = { limit: labtest.retrievePagingService.limit, offset: labtest.retrievePagingService.offSet, search: labtest.search };
            let resultConfirmedList = labtest.resultConfirmedList;
            Mask.show();
            PagingService.getNextPage(CovidService.retrieveResultConfirmedList, labtest.criteria, resultConfirmedList, null).then((response) => {
                labtest.resultConfirmedList = response;
                labtest.resultConfirmedList.forEach((result) => {
                    result.labTestGeneratedNumber = result.labTestNumber && result.labTestNumber != 'null' ? `${result.labTestId}(${result.labTestNumber})` : result.labTestId;
                });
                labtest.markAll ? labtest.selectMarkAll(labtest.resultConfirmedList) : null;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.printResultConfirmed = () => {
            Mask.show();
            labtest.retrieveMarkedMembersList('covid19_lab_test_retrieve_result_confirmed_list_all', labtest.resultConfirmedList).then(() => {
                const ids = labtest.markedMembersList.map(result => result.labCollectionId).join();
                Mask.show();
                CovidService.downloadLabTestReportPdf(ids).then((res) => {
                    if (res.data !== null && navigator.msSaveBlob) {
                        return navigator.msSaveBlob(new Blob([res.data], { type: "application/pdf;charset=UTF-8'" }));
                    }
                    var a = $("<a style='display: none;'/>");
                    var url = window.URL.createObjectURL(new Blob([res.data], { type: "application/pdf;charset=UTF-8'" }));
                    a.attr("href", url);
                    a.attr("download", "Lab_Test_Report_" + new Date().getTime() + ".pdf");
                    $("body").append(a);
                    a[0].click();
                    window.URL.revokeObjectURL(url);
                    a.remove();
                    labtest.markedMembersList = [];
                    labtest.resultConfirmedTabSelected();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(() => {
                    Mask.hide();
                });
            }, GeneralUtil.showMessageOnApiCallFailure).finally(() => {
                Mask.hide();
            });
        }

        labtest.archiveMembers = () => {
            Mask.show();
            labtest.retrieveMarkedMembersList('covid19_lab_test_retrieve_result_confirmed_list_all', labtest.resultConfirmedList).then(() => {
                const ids = labtest.markedMembersList.map(member => member.labCollectionId);
                Mask.show();
                QueryDAO.execute({
                    code: 'covid19_lab_test_archive_members',
                    parameters: {
                        ids: ids
                    }
                }).then(() => {
                    toaster.pop('success', 'Members archived successfully');
                    labtest.markedMembersList = [];
                    labtest.resultConfirmedTabSelected();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(() => {
                    Mask.hide();
                })
            }, GeneralUtil.showMessageOnApiCallFailure).finally(() => {
                Mask.hide();
            })
        }

        labtest.retrieveMarkedMembersList = (code, list) => {
            return new Promise((resolve, reject) => {
                if (labtest.markAll) {
                    QueryDAO.execute({
                        code: code,
                        parameters: {
                            searchText: labtest.search,
                            healthInfra: labtest.filteredHealthInfra,
                            collectionDate: labtest.filteredCollectionDate ? moment(labtest.filteredCollectionDate).format('DD-MM-YYYY') : null
                        }
                    }).then((response) => {
                        labtest.markedMembersList = response.result;
                        Array.isArray(labtest.markedMembersList) && labtest.markedMembersList.length ? resolve() : reject({ data: { message: 'Please select a member first' } });
                    }).catch((error) => {
                        reject(error);
                    });
                } else if (Array.isArray(list)) {
                    labtest.markedMembersList = list.filter((member) => {
                        return member.markedForAction;
                    });
                    Array.isArray(labtest.markedMembersList) && labtest.markedMembersList.length ? resolve() : reject({ data: { message: 'Please select a member first' } });
                }
            })
        }

        labtest.selectMarkAll = (list) => {
            if (labtest.markAll) {
                list.forEach((member) => {
                    if (!member.checkBoxDisabled) {
                        member.markedForAction = true;
                    }
                });
            } else {
                list.forEach((member) => {
                    member.markedForAction = false;
                });
            }
        }

        labtest.selectMarkedForAction = (action) => {
            if (!action) {
                labtest.markAll = false;
            }
        }

        labtest.searchChanged = () => {
            switch (labtest.selectedTab) {
                case 'sample-collection-tab':
                    labtest.sampleCollectionTabSelected();
                    break;
                case 'sample-receive-tab':
                    labtest.sampleReceiveTabSelected();
                    break;
                case 'result-tab':
                    labtest.resultTabSelected();
                    break;
                case 'indeterminate-tab':
                    labtest.indeterminateTabSelected();
                    break;
                case 'result-confirmed-tab':
                    labtest.resultConfirmedTabSelected()
                    break;
            }
        }

        labtest.filterCollectionTab = () => {
            labtest.sampleCollectionList = [];
            labtest.markAll = false;
            labtest.retrieveDistinctWardNameForCollection();
            labtest.retrievePagingService = PagingService.initialize();
            labtest.getSampleCollectionList();
        }

        labtest.filterReceiveTab = () => {
            labtest.sampleReceiveList = [];
            labtest.markAll = false;
            labtest.retrieveDistinctWardNameForReceive();
            labtest.retrievePagingService = PagingService.initialize();
            labtest.getSampleReceiveList();
        }

        labtest.filterResultTab = () => {
            labtest.resultList = [];
            labtest.markAll = false;
            labtest.retrieveDistinctWardNameForResult();
            labtest.retrievePagingService = PagingService.initialize();
            labtest.getResultList();
        }

        labtest.retrieveDistinctHealthInfraForReceiveTab = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_lab_test_dashboard_distinct_health_infra_sample_receive',
                parameters: {}
            }).then((response) => {
                labtest.distinctReceiveHealthInfras = response.result.map(result => result.name_in_english);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.retrieveDistinctHealthInfraForResultTab = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_lab_test_dashboard_distinct_health_infra_result',
                parameters: {}
            }).then((response) => {
                labtest.distinctResultHealthInfras = response.result.map(result => result.name_in_english);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.retrieveDistinctWardNameForCollection = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_lab_test_dashboard_distinct_ward_name',
                parameters: {}
            }).then((response) => {
                labtest.distinctWards = response.result.map(result => result.ward_name);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.retrieveDistinctWardNameForReceive = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_lab_test_dashboard_distinct_ward_name_receive',
                parameters: {
                    healthInfra: labtest.filteredHealthInfra || null
                }
            }).then((response) => {
                labtest.distinctWards = response.result.map(result => result.ward_name);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.retrieveDistinctWardNameForResult = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_lab_test_dashboard_distinct_ward_name_result',
                parameters: {
                    healthInfra: labtest.filteredHealthInfra || null
                }
            }).then((response) => {
                labtest.distinctWards = response.result.map(result => result.ward_name);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.retrieveHealthInfrastructuresByLocation = () => {
            return QueryDAO.execute({
                code: 'retrieve_covid_lab_test_with_out_user_infra_by_location',
                parameters: {
                    locationId: labtest.districtlocationId,
                    user_id: $rootScope.loggedInUserId || -1
                }
            });
        }

        labtest.retrieveDistrictLocations = () => {
            return QueryDAO.execute({
                code: 'covid19_retrieve_lab_location',
                parameters: {
                    type: ['D', 'C']
                }
            });
        }

        labtest.retrieveDistrictLocationsAndHealthInfrastructure = () => {
            Mask.show();
            labtest.retrieveDistrictLocations().then((response) => {
                labtest.districtLocations = response.result;
                return labtest.retrieveHealthInfrastructuresByLocation();
            }).then((response) => {
                labtest.healthInfrastructureList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labtest.sampleCollectionLocationChanged = () => {
            Mask.show();
            labtest.healthInfraId = null;
            labtest.retrieveHealthInfrastructuresByLocation().then((response) => {
                labtest.healthInfrastructureList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        labtest.isSameHealthInfrastructureChanged = () => {
            labtest.districtlocationId = null;
            labtest.healthInfraId = null;
        }

        labtest.collectionDateChanged = () => {
            labtest.collectionTime = new Date(
                labtest.collectionDate.getFullYear(),
                labtest.collectionDate.getMonth(),
                labtest.collectionDate.getDate(),
                00,
                00
            );
        }

        labtest.receiveDateChanged = () => {
            labtest.receiveTime = new Date(
                labtest.receiveDate.getFullYear(),
                labtest.receiveDate.getMonth(),
                labtest.receiveDate.getDate(),
                00,
                00
            );
        }

        labtest.resultDateChanged = () => {
            labtest.resultTime = new Date(
                labtest.resultDate.getFullYear(),
                labtest.resultDate.getMonth(),
                labtest.resultDate.getDate(),
                00,
                00
            );
        }

        labtest.transferDateChanged = () => {
            labtest.transferTime = new Date(
                labtest.transferDate.getFullYear(),
                labtest.transferDate.getMonth(),
                labtest.transferDate.getDate(),
                00,
                00
            )
        }

        labtest.checkCollectionTimeValidity = () => {
            labtest.checkTimeValidity(labtest.collectionDate, labtest.collectionTime, 'sampleCollectionForm', 'collectionTime');
        }

        labtest.checkReceiveTimeValidity = () => {
            labtest.checkTimeValidity(labtest.receiveDate, labtest.receiveTime, 'sampleReceiveForm', 'receiveTime');
        }

        labtest.checkResultTimeValidity = () => {
            labtest.checkTimeValidity(labtest.resultDate, labtest.resultTime, 'resultForm', 'resultTime');
        }

        labtest.checktransferTimeValidity = () => {
            labtest.checkTimeValidity(labtest.transferDate, labtest.transferTime, 'transferSampleForm', 'transferTime');
        }

        labtest.checkTimeValidity = (selectedDate, selectedTime, formName, formField) => {
            if (selectedDate) {
                const date = new Date(
                    selectedDate.getFullYear(),
                    selectedDate.getMonth(),
                    selectedDate.getDate(),
                    selectedTime.getHours(),
                    selectedTime.getMinutes(),
                );
                if (date > moment()) {
                    labtest[formName][formField].$setValidity('time', false)
                }
            } else {
                toaster.pop('error', 'Please select date first');
            }
        }

        labtest.getDate = (date, time) => {
            return new Date(
                date.getFullYear(),
                date.getMonth(),
                date.getDate(),
                time.getHours(),
                time.getMinutes(),
            );
        }

        labtest.cancel = () => {
            $("#sampleCollection").modal('hide');
            $("#sampleReceive").modal('hide');
            $("#resultModal").modal('hide');
            $("#transferSample").modal('hide');
            $("#editResultModal").modal('hide');
            labtest.districtlocationId = null;
            labtest.healthInfraId = null;
            labtest.resetSampleCollection();
            labtest.resetSampleReceive();
            labtest.resetResult();
            labtest.transferSampleForm.$setPristine();
        }

        labtest.resetSampleCollection = () => {
            labtest.currentSampleCollectionMember = {}
            labtest.showIsSameHealthInfrastructure = null;
            labtest.isSameHealthInfrastructure = null;
            labtest.sampleCollectionForm.$setPristine();
        }

        labtest.resetSampleReceive = () => {
            labtest.markedMembersList = [];
            labtest.currentSampleReceiveStatus = null;
            labtest.labTestNumber = null;
            labtest.rejectionRemarks = null;
            labtest.sampleReceiveForm.$setPristine();
        }

        labtest.resetResult = () => {
            labtest.currentResultMember = {};
            labtest.resultMode = null;
            labtest.result = null;
            labtest.labName = null;
            labtest.resultForm.$setPristine();
        }

        labtest.clearDateFilter = () => {
            labtest.filteredCollectionDate = null;
            if (labtest.selectedTab === 'sample-receive-tab') {
                labtest.sampleReceiveList = [];
                labtest.markAll = false;
                labtest.retrievePagingService = PagingService.initialize();
                labtest.getSampleReceiveList();
            } else if (labtest.selectedTab === 'result-tab') {
                labtest.resultList = [];
                labtest.markAll = false;
                labtest.retrievePagingService = PagingService.initialize();
                labtest.getResultList();
            }
        }

        labtest.clearHealthInfraFilter = () => {
            labtest.filteredHealthInfra = null;
            if (labtest.selectedTab === 'sample-receive-tab') {
                labtest.sampleReceiveList = [];
                labtest.markAll = false;
                labtest.retrievePagingService = PagingService.initialize();
                labtest.getSampleReceiveList();
            } else if (labtest.selectedTab === 'result-tab') {
                labtest.resultList = [];
                labtest.markAll = false;
                labtest.retrievePagingService = PagingService.initialize();
                labtest.getResultList();
            }
        }

        labtest.clearWardFilter = () => {
            labtest.filteredWard = null;
            if (labtest.selectedTab === 'sample-receive-tab') {
                labtest.sampleReceiveList = [];
                labtest.markAll = false;
                labtest.retrieveDistinctWardNameForReceive();
                labtest.retrievePagingService = PagingService.initialize();
                labtest.getSampleReceiveList();
            } else if (labtest.selectedTab === 'result-tab') {
                labtest.resultList = [];
                labtest.markAll = false;
                labtest.retrieveDistinctWardNameForResult();
                labtest.retrievePagingService = PagingService.initialize();
                labtest.getResultList();
            } else if (labtest.selectedTab === 'sample-collection-tab') {
                labtest.sampleCollectionTabSelected();
            }
        }

        labtest.drillDown = () => {
            labtest.addReportPermission(['covid19_lab_test_pen']);
            labtest.openReport('covid19_lab_test_pen', 2)
        }

        labtest.getCollection = () => {
            labtest.addReportPermission(['userwise_sample_info']);
            labtest.openReport('userwise_sample_info', 2)
        }

        labtest.addReportPermission = (codes) => {
            codes.forEach((code) => {
                let state = `techo.report.view/{"id":"${code}","type":"code","queryParams":null}`;
                if ($sessionStorage.asldkfjlj) {
                    $sessionStorage.asldkfjlj[state] = true;
                } else {
                    $sessionStorage.asldkfjlj = {};
                    $sessionStorage.asldkfjlj[state] = true;
                }
            });
        }

        labtest.openReport = (code, locationId) => {
            let temp = `techo.report.view({"id":"${code}","type":"code","queryParams":{"location_id":"${locationId}"}})`;
            let parameters = JSON.parse(temp.substring(temp.indexOf('(') + 1, temp.length - 1));
            let state = temp.substring(0, temp.indexOf('(')) + '/' + angular.toJson(parameters);
            if ($sessionStorage.asldkfjlj) {
                $sessionStorage.asldkfjlj[state] = true;
            } else {
                $sessionStorage.asldkfjlj = {};
                $sessionStorage.asldkfjlj[state] = true;
            }
            let url = $state.href(temp.substring(0, temp.indexOf('(')), parameters, { inherit: false, absolute: false });
            sessionStorage.setItem('linkClick', 'true')
            window.open(url, '_blank');
        }

        labtest.init();
    }
    angular.module('imtecho.controllers').controller('LabTestController', LabTestController);
})();
