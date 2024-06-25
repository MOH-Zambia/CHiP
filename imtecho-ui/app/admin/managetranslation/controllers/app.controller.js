(function (angular) {
  function AppController(languages, GeneralUtil, toaster, $uibModalInstance, $uibModal, TranslationDAO, $filter, Mask) {
    appController = this;
    
   
    appController.refresh = function () {
      Mask.show();
      TranslationDAO.getAllApps().then((res) => {
        appController.appList = res;
        for(app of appController.appList){
          for(lang of languages){
            if(app.language === lang.id){
              app.languagevalue = lang.languageValue;
            }
          }
        }
        appController.appList = appController.orderList();
        appController.init();
      }, (error) => {
        GeneralUtil.showMessageOnApiCallFailure(error);
      }).finally(() => {
        Mask.hide();
      })
    }

    appController.orderList = () => {
      let sorted = [];
      sorted = $filter('orderBy')(appController.appList, ['appValue']);
      return sorted;
    };
    appController.refresh();

    appController.init = () => {
      appController.editFlag = false;
      appController.languageList = languages
      if (appController.appList.length > 0) {
        appController.showFields = false
      } else {
        appController.showFields = true
      }
    }
   
   

    appController.addApp = function () {
      appController.editFlag = false;
      appController.clearValues();
      appController.toggleFields();
    }



    appController.saveApp = function (app) {
      appController.form.$setSubmitted();
      if (appController.form.$valid) {
        Mask.show();
        
        app.appKey = app.appKey.toUpperCase();
        let appDto = { ...app, isActive: true }

        if (!appController.editFlag) {
          TranslationDAO.createApp(appDto).then(() => {
            appController.refresh();
            toaster.pop('success', 'App added successfully')
          }, (error) => {
            GeneralUtil.showMessageOnApiCallFailure(error);
          }).finally(() => {
            Mask.hide();
          })
        } else {
          appDto = { ...appDto, id: appController.editId, isActive: appController.prevState }
          TranslationDAO.updateApp(appDto).then(() => {
            toaster.pop('success', 'App updated successfully');
            appController.refresh();
          }, (error) => {
            GeneralUtil.showMessageOnApiCallFailure(error);
          }).finally(() => { Mask.hide(); })
        }
        appController.toggleFields();
      }
    }

    appController.edit = function (app) {
      appController.editId = app.id
      appController.prevState = app.isActive
      appController.appForm = {
        appValue: app.appValue,
        appKey: app.appKey,
        language: app.language
      }
      if (!appController.showFields) {
        appController.toggleFields();
      }
      appController.editFlag = true
    }

    appController.cancel = function () {
      appController.clearValues();
      appController.toggleFields();
    }

    appController.toggleActive = function (app) {
      let modalInstance = $uibModal.open({
        templateUrl: 'app/common/views/confirmation.modal.html',
        controller: 'ConfirmModalController',
        windowClass: 'cst-modal',
        size: 'med',
        resolve: {
          message: function () {
            return "Are you sure you want to change the state from " + (app.isActive === true ? 'Active' : 'Inactive') + ' to ' + (!app.isActive === true ? 'Active' : 'Inactive') + '? ';
          }
        }
      });
      modalInstance.result.then(function () {
        Mask.show();
        let newState = !app.isActive
        app.isActive = newState;
        TranslationDAO.updateApp(app).then(() => {
          toaster.pop('success', 'State changed successfully')
          appController.refresh();
        }, (error) => {
          GeneralUtil.showMessageOnApiCallFailure(error);
        }).finally(() => {
          Mask.hide();
        })

      }, function () { });

    }

    appController.toggleFields = function () {
      appController.showFields = !appController.showFields
    }

    appController.clearValues = function () {
      appController.appForm = {
        appValue: "",
        appKey: "",
      }
    }



    appController.close = function () {
      $uibModalInstance.close();
    }
  }
  angular.module('imtecho.controllers').controller('AppController', AppController);
})(window.angular);