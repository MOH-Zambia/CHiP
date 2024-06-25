(function () {
    function StockManagementController(StockConfigDAO, QueryDAO, Mask, GeneralUtil, AuthenticateService, $uibModal,PagingForQueryBuilderService, toaster) {
        let ctrl = this;

        ctrl.init = function () {
            ctrl.listOfInstitutions = [];
            ctrl.listOfRequestsPending = [];
            ctrl.listOfRequestsApproved = [];
            ctrl.listOfRequestsRejected = [];
            ctrl.tempArray = [];
            ctrl.searchText = '';
            ctrl.fetchList(true);
            ctrl.selectedTab = 0;
            ctrl.pagingService = PagingForQueryBuilderService.initialize();
        }

        ctrl.fetchList = function () {
            AuthenticateService.getLoggedInUser().then(function (user) {
                Mask.show();
                ctrl.user = user;
                let queryDto = {
                    code: 'retrieve_health_infra_for_user',
                    parameters: {
                        userId: user.data.id
                    }
                };

                QueryDAO.execute(queryDto).then(function (res) {
                    ctrl.selectedInfrastructure = res.result[0];
                    ctrl.user.healthInfraId = ctrl.selectedInfrastructure.id;
                    ctrl.searchPending(true);
                    Mask.hide();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    ctrl.fetchUsers(ctrl.user.data.id)
                    Mask.hide();
                })
            })
        }

        ctrl.searchPending = function (reset) {
            Mask.show();
            if(reset){
                ctrl.listOfRequestsPending= [];
                ctrl.tempArray = [];
                ctrl.pagingService.resetOffSetAndVariables();
            }
            let dto = {
                code: 'fetch_stock_requests_by_infra_id',
                parameters: {
                    infraId: ctrl.selectedInfrastructure?.id ? ctrl.selectedInfrastructure.id : null,
                    status : 'REQUESTED',
                    limit : ctrl.pagingService.limit ,
                    offset : ctrl.pagingService.offSet
                }
            };
           
            ctrl.pagingService.getNextPage(QueryDAO.execute, dto, ctrl.tempArray, null ).then((response) => {
                if (response.length === 0 || response.length === ctrl.tempArray.length) {
                    ctrl.pagingService.allRetrieved = true;
                }else{
                    ctrl.pagingService.allRetrieved = false;
                }
                ctrl.tempArray = response.map(element => {
                    if (typeof element.medicine_data === 'string') {
                      element.medicine_data = JSON.parse(element.medicine_data);
                    }
                    return element;
                  });
                 
                ctrl.listOfRequestsPending = ctrl.tempArray;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.searchApproved = function (reset) {
            Mask.show();
            if(reset){
                ctrl.listOfRequestsApproved= [];
                ctrl.tempArray = [];
                ctrl.pagingService.resetOffSetAndVariables();
            }
            let dto = {
                code: 'fetch_stock_requests_by_infra_id',
                parameters: {
                    infraId: ctrl.selectedInfrastructure?.id ? ctrl.selectedInfrastructure.id : null,
                    status : 'APPROVED',
                    limit : ctrl.pagingService.limit ,
                    offset : ctrl.pagingService.offSet
                }
            };

            ctrl.pagingService.getNextPage(QueryDAO.execute, dto, ctrl.tempArray).then((response) => {
               
                if (response.length === 0 || response.length === ctrl.tempArray.length) {
                    ctrl.pagingService.allRetrieved = true;
                }else{
                    ctrl.pagingService.allRetrieved = false;
                }
                ctrl.tempArray = response.map(element => {
                    if (typeof element.medicine_data === 'string') {
                      element.medicine_data = JSON.parse(element.medicine_data);
                    }
                    return element;
                  });
                 
                ctrl.listOfRequestsApproved = ctrl.tempArray;
               
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });

        }

        ctrl.searchRejected = function (reset) {
            Mask.show();
            if(reset){
                ctrl.listOfRequestsRejected= [];
                ctrl.tempArray = [];
                ctrl.pagingService.resetOffSetAndVariables();
            }
            let dto = {
                code: 'fetch_stock_requests_by_infra_id',
                parameters: {
                    infraId: ctrl.selectedInfrastructure?.id ? ctrl.selectedInfrastructure.id : null,
                    status : 'REJECTED',
                    limit : ctrl.pagingService.limit ,
                    offset : ctrl.pagingService.offSet
                }
            };

            ctrl.pagingService.getNextPage(QueryDAO.execute, dto, ctrl.tempArray).then((response) => {
               
                if (response.length === 0 || response.length === ctrl.tempArray.length) {
                    ctrl.pagingService.allRetrieved = true;
                }else{
                    ctrl.pagingService.allRetrieved = false;
                }
                ctrl.tempArray = response.map(element => {
                    if (typeof element.medicine_data === 'string') {
                      element.medicine_data = JSON.parse(element.medicine_data);
                    }
                    return element;
                  });
                 
                ctrl.listOfRequestsRejected = ctrl.tempArray;
               
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });

        }

        ctrl.openModal = function (user) {
            $uibModal.open({
                templateUrl: 'app/manage/stockmanagement/views/stock.approval.modal.html',
                controller: 'SMModalController',
                controllerAs: 'mdctrl',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                resolve: {
                    data: function () {
                        return user;
                    },
                    healthInfraId: function () {
                        return ctrl.selectedInfrastructure.id
                    },
                    loggedUser : function(){
                        return ctrl.user;
                    },
                    save: function () {
                        return ctrl.onSubmit;
                    },
                    Mask: function () {
                        return Mask;
                    },
                    StockConfigDAO: function () {
                        return StockConfigDAO;
                    },
                    fetch: function () {
                        return ctrl.searchPending;
                    }
                }
            });
        }

        ctrl.openInventoryModal = function(){
            $uibModal.open({
                templateUrl: 'app/manage/stockmanagement/views/stock.inventory.modal.html',
                controller: 'StockUpdateModalController',
                controllerAs: 'mdctrl',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                resolve: {
                    user : function(){
                        return ctrl.user;
                    },
                    Mask: function () {
                        return Mask;
                    },
                    StockConfigDAO: function () {
                        return StockConfigDAO;
                    },
                    userList : function (){
                        return ctrl.userList;
                    },
                    refresh : function (){
                        return ctrl.searchPending;
                    },
                    fetch: function () {
                        return ctrl.searchPending;
                    }
                }
            });
        }

        ctrl.fetchUsers = function (user_id){
            let dto = {
                code : 'fetch_users_for_inventory_list',
                parameters : {
                    user_id : user_id
                }
            }

            QueryDAO.execute(dto).then(function (res) {
                ctrl.userList = res.result;
                Mask.hide();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {  
                Mask.hide();
            })
        }



        ctrl.filteredResults = function (array){
            const filteredData = array.filter(item => {
                const usernameMatch = item.username.toLowerCase().includes(ctrl.searchText.toLowerCase());
                const medicineMatch = item.medicine_data.some(medicine => 
                    medicine.medicine_name.toLowerCase().includes(ctrl.searchText.toLowerCase())
                );
                return usernameMatch || medicineMatch;
            });
        
            return filteredData;
        }

        ctrl.exportToExcel = function(index) {
            let date = new Date().getTime();
            let tableId;
            let filename;
            let removeColumnIndex = null;

            if (index == 0) {
                tableId = 'pending';
                filename = "PENDING_REQUESTS_" + date + ".xlsx";
                removeColumnIndex = 3; 
            } else if (index == 1) {
                tableId = 'approved';
                filename = "APPROVED_REQUESTS_" + date + ".xlsx";
            } else if (index == 2) {
                tableId = 'rejected';
                filename = "REJECTED_REQUESTS_" + date + ".xlsx";
                removeColumnIndex = 3; 
            }

         
            var table = document.getElementById(tableId);
            var wb = XLSX.utils.book_new();
            var ws = XLSX.utils.table_to_sheet(table);
            var data = XLSX.utils.sheet_to_json(ws, { header: 1 });

            if (removeColumnIndex !== null) {
                
                data = data.map(row => {
                    row.splice(removeColumnIndex, 1); 
                    return row;
                });
            }
            if(index == 0) {
                data[0][3] = 'Requested Quantities'
                for (let i = 1; i < data.length; i++) {
                    let user = ctrl.filteredResults(ctrl.listOfRequestsPending)[i - 1];
                    let medicines = user.medicine_data.map(medicine => medicine.medicine_name).join(', ');
                    let quantities = user.medicine_data.map(medicine => medicine.medicineQuantity).join(', ');
        
                    data[i][2] = medicines;
                    data[i][3] = quantities;
                }
            }
            if (index == 1) {
              
                for (let i = 1; i < data.length; i++) {
                    let user = ctrl.filteredResults(ctrl.listOfRequestsApproved)[i - 1];
                    let medicines = user.medicine_data.map(medicine => medicine.medicine_name).join(', ');
                    let quantities = user.medicine_data.map(medicine => medicine.approved_qty).join(', ');
        
                    data[i][2] = medicines;
                    data[i][3] = quantities;
                }
            }
            else if (index ==2) {
                data[0][3] = 'Rejection Reasons'
                for (let i = 1; i < data.length; i++) {
                    let user = ctrl.filteredResults(ctrl.listOfRequestsRejected)[i - 1];
                    let medicines = user.medicine_data.map(medicine => medicine.medicine_name).join(', ');
                    let reasons = user.medicine_data.map(medicine => medicine.reason).join(', ');
        
                    data[i][2] = medicines;
                    data[i][3] = reasons;
                }
            }    
        
            ws = XLSX.utils.aoa_to_sheet(data);
            XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
            XLSX.writeFile(wb, filename);
        };

        ctrl.onSubmit = function (user) {
            Mask.show()
            StockConfigDAO.updateStock(user.medicine_data, ctrl.selectedInfrastructure.id, ctrl.user.data.id).then(() => {

            }).finally(() => {
                Mask.hide();
            })
        }

        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('StockManagementController', StockManagementController);
})();

(function () {
    function SMModalController(StockConfigDAO, data, loggedUser, fetch, $uibModalInstance, Mask, healthInfraId,toaster) {
        let mdctrl = this;
        mdctrl.loaded = false;
        mdctrl.valid = true;

        mdctrl.init = function () {
            mdctrl.data = data;
            mdctrl.loaded = true;
            mdctrl.Mask = Mask;
            mdctrl.StockConfigDAO = StockConfigDAO;
            mdctrl.fetch = fetch;
            mdctrl.loggedUser = loggedUser;
        };
        
        mdctrl.cancel = function () {
            mdctrl.data.medicine_data.forEach((item) => {
                item.showReason = false;
            })
            $uibModalInstance.close();
        };

        mdctrl.isSaveButtonDisabled = function () {
            return mdctrl.data.medicine_data.some(function (item) {
                return item.approvedQuantity > item.medicineQuantity || item.approvedQuantity < 0;
            });
        };

        mdctrl.showReason = function(item) {
            item.showReason = !item.showReason;
        }

        mdctrl.save = function (user) {
            Mask.show();
            let validQuantities = true;
            let acknowledgedReqs = 0;
            let rejectedReqs = 0;
            user.medicine_data.forEach((el) => {
                el.id = user.id;
                el.approvedBy = user.user_id;
                el.approvedQuantity = parseInt(el.approvedQuantity);
                if (el.approvedQuantity < 0 || el.approvedQuantity > el.medicineQuantity) {
                    validQuantities = false;
                    mdctrl.cancel();
                    Mask.hide();
                    mdctrl.fetch(true);
                }

                if (el.approvedQuantity === null || el.approvedQuantity == undefined || isNaN(el.approvedQuantity))
                    el.approvedQuantity = 0;
                delete el.medicine_name;
                if(el.approvedQuantity > 0)
                    acknowledgedReqs++;
                if(el.reason.length > 0)
                    rejectedReqs++;
            }
            )

            if (validQuantities)
                mdctrl.StockConfigDAO.updateStock(user.medicine_data, healthInfraId, userId = mdctrl.loggedUser.data.id).then(() => {
                }).finally(() => {
                    toaster.pop('success', "Number of Requests Acknowledged : "+ acknowledgedReqs + ", Number of Requests Rejected : " + rejectedReqs);
                    mdctrl.fetch(true);
                    Mask.hide();
                    mdctrl.cancel();
                })
        }

        mdctrl.init();
    }
    angular.module('imtecho.controllers').controller('SMModalController', SMModalController);
})();

(function () {
    function StockUpdateModalController(StockConfigDAO,QueryDAO,user,userList,$uibModalInstance, Mask,toaster, fetch) {
        let mdctrl = this;  
        mdctrl.loaded = false;
        mdctrl.valid = true;

        mdctrl.init = function () {
            mdctrl.user = user;
            mdctrl.loaded = true;
            mdctrl.Mask = Mask;
            mdctrl.fetch = fetch;
            mdctrl.StockConfigDAO = StockConfigDAO;
            mdctrl.userList = userList
            mdctrl.medicineList = []
           
        };

        mdctrl.cancel = function () {
            $uibModalInstance.close();
        };

        mdctrl.fetchMeds = function(user_id){
            let dto = {
                code : 'fetch_medicine_for_user',
                parameters : {
                    user_id : user_id
                }
            }
            QueryDAO.execute(dto).then(function (res) {
                mdctrl.medicineList = res.result;
                if(mdctrl.medicineList.length == 0)
                    toaster.pop('info', 'No medicines found for user')
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                return []   ``
            }).finally(() => {
                Mask.hide();
            })
        }

        mdctrl.updateInventory = function(medicine, qty){
            Mask.show();
            medicine.approvedBy = mdctrl.user.data.id;
            medicine.healthInfraId = mdctrl.user.healthInfraId;
            let obj = {
                approvedBy : mdctrl.user.data.id,
                healthInfraId : mdctrl.user.healthInfraId,
                requestedBy : medicine.requested_by,
                medicineId : medicine.medicine_id,
                approvedQuantity : qty
            }
            StockConfigDAO.updateInventory(obj).then(()=>{
                toaster.pop('success','Inventory has been updated')
            }).finally(()=> {
                Mask.hide();
                mdctrl.fetch(true);
                mdctrl.cancel();
            })
        }

        mdctrl.init();
    }
    angular.module('imtecho.controllers').controller('StockUpdateModalController', StockUpdateModalController);
})();