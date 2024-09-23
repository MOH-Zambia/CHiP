(function () {
    const as = angular.module("imtecho");
    as.config(['$stateProvider', '$urlRouterProvider', 'LZ_CONFIG', 'ENV',
        function ($stateProvider, $urlRouterProvider, LZ_CONFIG, ENV) {
            // For unmatched routes
            $urlRouterProvider.otherwise('/');
            // Application routes
            $stateProvider
                .state('login', {
                    url: '/',
                    title: 'Login',
                    templateUrl: 'app/login/views/login.html',
                    controller: 'LoginController as login',
                    resolve: load([
                        'login.controller',
                        'bootstrap',
                        'formvalidation.directive',
                        'generalutil.service',
                        'emptylabel.filter'
                    ])
                })
                .state('logindownload', {
                    url: '/download',
                    title: 'Login Download',
                    templateUrl: 'app/login/views/login-download.html',
                    controller: 'LoginDownloadController as login',
                    resolve: load([
                        'login-download.controller',
                        'bootstrap',
                        'formvalidation.directive'
                    ])
                })
                .state('info', {
                    url: '/info',
                    title: 'App Info',
                    templateUrl: 'app/login/views/info.html',
                    controller: 'InfoController as info',
                    resolve: load([
                        'info.controller',
                        'formvalidation.directive',
                        'mobilenumber.filter',
                        'auto-focus.directive',
                        'limitTo.directive',
                        'info.service'
                    ])
                })
                .state('resetpassword', {
                    url: '/forgotpassword',
                    title: 'Forgot Password',
                    templateUrl: 'app/login/views/forget-password.html',
                    controller: 'ForgetPasswordController as forgetpass',
                    resolve: load([
                        'user.service',
                        'forget-password.controller',
                        'bootstrap',
                        'formvalidation.directive'
                    ])
                })

                .state('techo', {
                    url: "/techo",
                    abstract: true,
                    templateUrl: 'app/common/views/layout.html',
                    controller: 'LayoutController as layout',
                    resolve: load([
                        'bootstrap',
                        'uibootstrap',
                        'layout.controller',
                        'roles.service',
                        'titlecase.filter',
                        'datesuffix.filter',
                        'formvalidation.directive',
                        'generalutil.service',
                        'paging-for-form-configurator-query.service',
                        'medplat-form.util',
                        'chosen',
                        'confirmation.modal',
                        'data-persist.service',
                        'tableFixer',
                        'customjs',
                        'alert.modal',
                        'numbers-only.directive',
                        'location.directive',
                        'location.service',
                        'printthis',
                        'firePath',
                        'isolateform.directive',
                        'emptylabel.filter',
                        'update-password.modal.controller',
                        'user.service',
                        'dynamicview.directive',
                        'map-to-array.filter',
                        'selectize',
                        'trustashtml',
                        'datePicker.directive',
                        'alphabetonly.directive',
                        'removespaces.directive',
                        'yes-or-no.filter',
                        'gender.filter',
                        'sd-score.filter',
                        'query.service',
                        'locationName.filter',
                        'ngFlow',
                        'unsafe.filter',
                        'daterangepicker.directive',
                        'limitTo.directive',
                        'a-redirect',
                        'sort.directive',
                        'update-user-profile.controller',
                        'role.service',
                        'user.constants',
                        'update-password.modal.controller',
                        'infrastructure.directive',
                        'selectize.generator',
                        'generate-dynamic-template.directives',
                        'listvalue.modal',
                        'search.directive',
                        'search.constants',
                        'qr-code-scan.modal.controller',
                        'map.modal.controller',
                        'immunisation.directive'
                    ])
                })
                .state('techo.dashboard', {
                    url: '/dashboard',
                    abstract: true,
                    template: '<ui-view></ui-view>'
                })
                .state('techo.admin', {
                    url: "/admin",
                    abstract: true,
                    template: '<ui-view></ui-view>'
                })
                .state('techo.manage', {
                    url: "/manage",
                    abstract: true,
                    template: '<ui-view></ui-view>'
                })
                .state('techo.fieldsupportofficer', {
                    url: "/fso",
                    abstract: true,
                    template: '<ui-view></ui-view>'
                })
                .state('techo.fieldsupportofficer.absentusers', {
                    url: '/absentusers',
                    title: 'Manage absent users',
                    templateUrl: 'app/fieldsupportofficer/views/manageAbsentUsers.html',
                    controller: 'ManageAbsentUsersController as manageabsentuserscontroller',
                    resolve: load([
                        'manageabsentusers.controller',
                        'paging.service'
                    ])
                })
                .state('techo.training', {
                    url: "/training",
                    abstract: true,
                    template: '<ui-view></ui-view>'
                })
                .state('techo.manage.menu', {
                    url: "/menu",
                    title: 'Manage Menu',
                    templateUrl: 'app/admin/menufeature/views/menu-feature-config.html',
                    controller: 'MenuConfigController as menuconfig',
                    resolve: load([
                        'menu-feature-config.controller',
                        'menu-config.service',
                        'user.service',
                        'role.service',
                        'selectize.generator'
                    ])
                })
                .state('techo.manage.user', {
                    url: '/user/:id',
                    title: 'Manage user',
                    templateUrl: 'app/manage/users/views/manage-user.html',
                    controller: 'ManageUserController as usercontroller',
                    resolve: load([
                        'manage-user.controller',
                        'user.service',
                        'role.service',
                        'user.constants',
                        'update-password.modal.controller',
                        'limitTo.directive'
                    ])
                })
                .state('techo.manage.users', {
                    url: '/users',
                    title: 'List of Users',
                    templateUrl: 'app/manage/users/views/users.html',
                    controller: 'UsersController as userscontroller',
                    resolve: load([
                        'users.controller',
                        'user.service',
                        'languagename.filter',
                        'statecapitalize.filter',
                        'user.constants',
                        'ngInfiniteScroll',
                        'paging.service',
                        'role.service',
                        'alasql'
                    ])
                })
                .state('techo.manage.announcement', {
                    url: '/announcement/:id',
                    title: 'Add announcement',
                    templateUrl: 'app/manage/announcement/views/manage-announcement.html',
                    controller: 'ManageAnnouncementController as ctrl',
                    resolve: load([
                        'manage-announcement.controller',
                        'announcement.service',
                    ])
                })
                .state('techo.manage.announcements', {
                    url: '/announcements',
                    title: 'List of announcements',
                    templateUrl: 'app/manage/announcement/views/announcements.html',
                    controller: 'AnnouncementsController as announcementscontroller',
                    resolve: load([
                        'announcements.controller',
                        'announcement.service',
                        'paging.service'
                    ])
                })
                .state('techo.manage.memberinformation', {
                    url: '/memberinformation/:uniqueHealthId',
                    title: 'Member Information',
                    templateUrl: 'app/manage/views/member-information.html',
                    controller: 'MemberInfoController as memberInfo',
                    params: {
                        uniqueHealthId: null
                    },
                    resolve: load([
                        'memberinfo.controller',
                        'anganwadi.service',
                        'authentication.service'
                    ])
                })
                .state('techo.manage.familyinformation', {
                    url: '/familyinformation/:familyId',
                    title: 'Family Information',
                    templateUrl: 'app/manage/views/family-information.html',
                    controller: 'FamilyInfoController as familyInfo',
                    params: {
                        familyId: null
                    },
                    resolve: load([
                        'familyinfo.controller',
                        'query.controller',
                        'query.service'
                    ])
                })
                // .state('techo.manage.userinformation', {
                //     url: '/userinformation',
                //     title: 'User Information',
                //     templateUrl: 'app/manage/userinformation/views/user-information.html',
                //     controller: 'UserInfoController as userInfo',
                //     resolve: load([
                //         'user-information.controller',
                //         'query.controller',
                //         'query.service'
                //     ])
                // })
                // .state('techo.manage.memberserviceregister', {
                //     url: '/serviceregister',
                //     title: 'Member Service Register',
                //     templateUrl: 'app/manage/memberserviceregister/views/member-service-register.html',
                //     controller: 'MemberServiceRegisterController as memberServiceInfo',
                //     resolve: load([
                //         'member-service-register.controller',
                //         'member-service-register.constant',
                //         'member-lmp-service-register.controller',
                //         'member-anc-service-register.controller',
                //         'member-child-service-register.controller',
                //         'member-wpd-service-register.controller',
                //         'member-pnc-service-register.controller',
                //         'query.controller',
                //         'query.service',
                //         'paging.service',
                //         'alasql',
                //     ])
                // })
                .state('techo.manage.searchfeature', {
                    url: '/searchFeature/:uniqueHealthId',
                    title: 'Helpdesk Tool - Search',
                    templateUrl: 'app/manage/helpdesktool/views/help-desk-search.html',
                    controller: 'SearchFeatureController as searchInfo',
                    params: { familyId: { value: null } },
                    resolve: load([
                        'help-desk-search.controller',
                        'help-desk-edit.modal.controller',
                        'query.controller',
                        'anganwadi.service',
                        'query.service',
                        'timeline-config.service',
                        'help-desk.constant',
                        'authentication.service',
                        'help-desk.service',
                        'family-qr-code.service'
                    ])
                })
                .state('techo.manage.mobilemangementinfo', {
                    url: '/mobileManagementInfo',
                    title: 'Mobile management',
                    templateUrl: 'app/manage/mobileManagement/views/mobile-management.html',
                    controller: 'MobileManagementController as mobileManageInfo',
                    resolve: load([

                        'query.controller',
                        'anganwadi.service',
                        'query.service',
                        'authentication.service',
                        'mobile-management.controller'
                    ])
                })
                .state('techo.manage.mobilelibrary', {
                    url: '/mobileLibrary',
                    title: 'Mobile Library',
                    templateUrl: 'app/manage/mobilelibrary/views/mobile-library.html',
                    controller: 'MobileLibraryController as mobileLibrary',
                    resolve: load([
                        'help-desk-search.controller',
                        'query.controller',
                        'anganwadi.service',
                        'query.service',
                        'authentication.service',
                        'mobile-library.controller',
                        'role.service',
                        'mobile-library.service'
                    ])
                })
                .state('techo.manage.usergeoservices', {
                    url: '/viewGeoServices',
                    title: 'View Geo Services',
                    templateUrl: 'app/manage/geoservices/views/view-user-geo-services.html',
                    controller: 'ViewGeoServicesController as viewGeoServices',
                    resolve: load([
                        'help-desk-search.controller',
                        'query.controller',
                        'anganwadi.service',
                        'query.service',
                        'authentication.service',
                        'view-user-geo-services.controller',
                        'role.service',
                        'mobile-library.service',
                    ])
                })
                .state('techo.manage.servicedeliverylocation', {
                    url: '/servicedeliverylocation',
                    title: 'Place of Service Delivery',
                    templateUrl: 'app/manage/servicedeliverylocation/views/service-delivery-location.html',
                    controller: 'ServiceDeliveryLocationController as serviceDeliveryLocation',
                    resolve: load([
                        'help-desk-search.controller',
                        'query.controller',
                        'anganwadi.service',
                        'query.service',
                        'authentication.service',
                        'service-delivery-location.controller',
                        'service-delivery-line-list.controller',
                        'location.service',
                        'role.service',
                        'mobile-library.service',
                    ])
                })
                .state('techo.manage.rchregister', {
                    url: '/rchregister',
                    title: 'Rch register',
                    templateUrl: 'app/manage/rchregister/views/rch-register.html',
                    controller: 'RchRegisterController as rchRegister',
                    resolve: load([
                        'rch-register.controller',
                        'member-service-register.constant',
                        'authentication.service',
                        'ngInfiniteScroll',
                        'paging.service',
                        'rch-register.service',
                        'report.service'
                    ])
                })
                .state('techo.manage.uploadDocument', {
                    url: '/uploadDocument',
                    title: 'Upload Document',
                    templateUrl: 'app/manage/uploaddocument/views/upload-document.html',
                    controller: 'UploadDocumentController as uploadDocument',
                    resolve: load([
                        'help-desk-search.controller',
                        'query.controller',
                        'anganwadi.service',
                        'query.service',
                        'authentication.service',
                        'mobileLibrary.controller',
                        'role.service',
                        'mobile-library.service',
                        'upload-document.controller'
                    ])
                })
                // .state('techo.manage.pncSearch', {
                //     url: '/pnc/search',
                //     title: 'PNC Institution Form',
                //     templateUrl: 'app/manage/facilitydataentry/pnc/views/pnc-search.html',
                //     controller: 'PncSearchController as pncsearchcontroller',
                //     resolve: load([
                //         'pnc-search.controller',
                //         'pnc.service',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //         'anganwadi.service'
                //     ])
                // })
                // .state('techo.manage.pnc', {
                //     url: '/pnc/:id',
                //     title: 'Manage PNC visit',
                //     templateUrl: 'app/manage/facilitydataentry/pnc/views/manage-pnc.html',
                //     controller: 'ManagePncController as managepnccontroller',
                //     resolve: load([
                //         'manage-pnc.controller',
                //         'pnc.service',
                //         'anganwadi.service',
                //         'selectize.generator'
                //     ])
                // })
                .state('techo.manage.fpChangeSearch', {
                    url: '/fpchange/search',
                    title: 'Family Planning Service Visit',
                    templateUrl: 'app/manage/facilitydataentry/familyplanning/views/family-planning-search.html',
                    controller: 'FpChangeSearch as fpchangesearch',
                    resolve: load([
                        'family-planning-search.controller',
                        'iucd-removal.modal.controller',
                        'change-family-planning-method.modal.controller',
                        'authentication.service',
                        'ngInfiniteScroll',
                        'paging-for-query-builder.service',
                        'familyplanning.filter'
                    ])
                })
                .state('techo.manage.childServiceSearch', {
                    url: '/childservice/search',
                    title: 'Child Service Visit',
                    templateUrl: 'app/manage/facilitydataentry/childservice/views/child-service-search.html',
                    controller: 'ChildServiceSearchController as childservicesearchcontroller',
                    resolve: load([
                        'child-service-search.controller',
                        'child-service.service',
                        'authentication.service',
                        'ngInfiniteScroll',
                        'paging.service',
                        'anganwadi.service'
                    ])
                })
                .state('techo.manage.childservice', {
                    url: '/childservice/:id',
                    title: 'Manage Child Service Visit',
                    templateUrl: 'app/manage/facilitydataentry/childservice/views/manage-child-service.html',
                    controller: 'ManageChildServiceController as managechildservicecontroller',
                    resolve: load([
                        'manage-child-service.controller',
                        'child-service.service',
                        'anganwadi.service',
                        'selectize.generator'
                    ])
                })
                .state('techo.manage.wpdSearch', {
                    url: '/wpd/search',
                    title: 'Institutional Delivery Reg. Form',
                    templateUrl: 'app/manage/facilitydataentry/wpd/views/wpd-search.html',
                    controller: 'WpdSearchController as queform',
                    resolve: load([
                        'wpd-search.controller',
                        'wpd.service',
                        'authentication.service',
                        'ngInfiniteScroll',
                        'paging.service',
                    ])
                })
                .state('techo.manage.wpd', {
                    url: '/wpd/:id',
                    title: 'Manage WPD',
                    templateUrl: 'app/manage/facilitydataentry/wpd/views/manage-wpd.html',
                    controller: 'ManageWpdController as managewpdcontroller',
                    resolve: load([
                        'manage-wpd.controller',
                        'wpd.service',
                        'selectize.generator',

                    ])
                })
                // .state('techo.manage.sicklecellSearch', {
                //     url: '/sicklecell/search',
                //     title: 'Sickle Cell Screening',
                //     templateUrl: 'app/manage/facilitydataentry/sicklecell/views/sicklecell-search.html',
                //     controller: 'SicklecellSearchController as sicklecellsearch',
                //     resolve: load([
                //         'sicklecell-search.controller',
                //         'sicklecell.constants',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //     ])
                // })
                // .state('techo.manage.outPatientTreatmentSearch', {
                //     url: '/outpatienttreatment/search',
                //     title: 'Out-Patient Treatment (OPD)',
                //     templateUrl: 'app/manage/facilitydataentry/outpatienttreatment/views/out-patient-treatment-search.html',
                //     controller: 'OutPatientTreatmentSearch as outPatientTreatmentSearch',
                //     resolve: load([
                //         'out-patient-treatment-search.controller',
                //         'out-patients.constants',
                //         'out-patient.service',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //     ])
                // })
                // .state('techo.manage.optTreatmentForm', {
                //     url: '/opt/treatmentform/:id',
                //     title: 'OPT Treatment Form',
                //     templateUrl: 'app/manage/facilitydataentry/outpatienttreatment/views/out-patient-treatment.html',
                //     controller: 'OutPatientTreatment as outPatientTreatment',
                //     resolve: load([
                //         'out-patient-treatment.controller',
                //         'out-patients.constants',
                //         'out-patient.service',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //     ])
                // })
                // .state('techo.manage.optMedicinesForm', {
                //     url: '/opt/medicinesform/:id',
                //     title: 'OPT Medicines Form',
                //     templateUrl: 'app/manage/facilitydataentry/outpatienttreatment/views/out-patient-treatment.html',
                //     controller: 'OutPatientTreatment as outPatientTreatment',
                //     resolve: load([
                //         'out-patient-treatment.controller',
                //         'out-patients.constants',
                //         'out-patient.service',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service'
                //     ])
                // })
                // .state('techo.manage.sicklecell', {
                //     url: '/sicklecell/:id',
                //     title: 'Sickle Cell Screening',
                //     templateUrl: 'app/manage/facilitydataentry/sicklecell/views/sicklecell.html',
                //     controller: 'SicklecellController as sicklecell',
                //     resolve: load([
                //         'sicklecell.controller',
                //         'sicklecell.service',
                //         'sicklecell.constants',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //     ])
                // })
                .state('techo.manage.pregregedit', {
                    url: '/pregnancyregistration/edit',
                    title: 'Pregnancy Registration Verification',
                    templateUrl: 'app/manage/pregnancyregistration/views/preg-reg-edit.html',
                    controller: 'PregnancyRegistration as pregreg',
                    resolve: load([
                        'preg-reg-edit.controller',
                        'preg-reg-edit-modal.controller',
                        'authentication.service',
                        'ngInfiniteScroll',
                        'paging.service',
                    ])
                })
                // .state('techo.manage.markchiranjeevi', {
                //     url: '/markchiranjeevi',
                //     title: 'Chiranjeevi Deliveries Updation',
                //     templateUrl: 'app/manage/views/mark-chiranjeevi.html',
                //     controller: 'MarkChiranjeevi as markchiranjeevi',
                //     resolve: load([
                //         'mark-chiranjeevi.controller',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //     ])
                // })
                // .state('techo.manage.cerebralpalsysearch', {
                //     url: '/cerebralpalsy/search',
                //     title: 'Suspected CP List',
                //     templateUrl: 'app/manage/suspectedcp/views/cerebral-palsy-search.html',
                //     controller: 'CerebralPalsySearchController as cerebralpalsysearch',
                //     resolve: load([
                //         'cerebral-palsy-search.controller',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //         'anganwadi.service'
                //     ])
                // })
                // .state('techo.manage.cerebralpalsy', {
                //     url: '/cerebralpalsy/:id',
                //     title: 'Suspected CP Child Details',
                //     templateUrl: 'app/manage/suspectedcp/views/cerebral-palsy.html',
                //     controller: 'CerebralPalsyController as cerebralpalsy',
                //     resolve: load([
                //         'cerebral-palsy.controller',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //         'anganwadi.service'
                //     ])
                // })
                .state('techo.manage.childscreeninglist', {
                    url: '/childscreening',
                    title: 'Child Screening List',
                    templateUrl: 'app/manage/childscreening/views/child-screening-list.html',
                    controller: 'ChildScreeningListController as childscreeninglist',
                    resolve: load([
                        'child-screening-list.controller',
                        'ngInfiniteScroll',
                        'child-screening.service',
                        'paging.service'
                    ])
                })
                .state('techo.manage.childscreening', {
                    url: '/childscreening/:action/:id',
                    title: '',
                    templateUrl: 'app/manage/childscreening/views/child-screening.html',
                    controller: 'ChildScreeningController as childscreening',
                    resolve: load([
                        'child-screening.controller',
                        'child-screening.service',
                    ])
                })
                .state('techo.manage.laboratorytests', {
                    url: '/laboratorytests/:id',
                    title: 'Laboratory Tests Update',
                    templateUrl: 'app/manage/childscreening/views/laboratory-tests.html',
                    controller: 'LaboratoryTestsController as laboratorytests',
                    resolve: load([
                        'laboratory-tests.controller',
                        'child-screening.service'
                    ])
                })
                .state('techo.manage.medicines', {
                    url: '/medicines/:id',
                    title: 'Medicines given as per protocol',
                    templateUrl: 'app/manage/childscreening/views/medicines.html',
                    controller: 'MedicinesController as medicinescontroller',
                    resolve: load([
                        'medicines.controller',
                        'child-screening.service'
                    ])
                })
                .state('techo.manage.role', {
                    url: '/roles',
                    title: 'Manage Role',
                    templateUrl: 'app/admin/role/views/role.html',
                    controller: 'RoleController as rolecontroller',
                    resolve: load([
                        'roles.controller',
                        'menu-config.service',
                        'role.service',
                        'role.modal.controller',
                        'user.constants',
                        'statecapitalize.filter'
                    ])
                })
                .state('techo.manage.notification', {
                    url: '/notification',
                    title: 'Notification configuration',
                    templateUrl: 'app/admin/applicationmanagement/notification/views/notification.html',
                    controller: 'NotificationController as notificationcontroller',
                    resolve: load([
                        'notification.controller',
                        'notification.service',
                        'statecapitalize.filter',
                        'selectize.generator',
                        'syncWithServerService',
                        'authentication.service'
                    ])
                })
                .state('techo.manage.addNotificationConfiguration', {
                    url: '/admin/applicationmanagement/notification/add',
                    title: 'Add Notification configuration',
                    templateUrl: 'app/admin/applicationmanagement/notification/views/manage-notification.html',
                    controller: 'AddNotificationConfigurationController as addnotificationcontroller',
                    resolve: load([
                        'notification.controller',
                        'manage-notification.controller',
                        'notification.service',
                        'statecapitalize.filter'
                    ])
                })
                .state('techo.training.scheduled', {
                    url: '/all',
                    title: 'Training Schedule',
                    templateUrl: 'app/training/trainingschedule/views/scheduled-training.html',
                    controller: 'ScheduledTrainingCtrl as scheduledTraining',
                    resolve: load([
                        'scheduled-training.controller',
                        'training-schedule.service',
                        'topicCoverage.service',
                        'reschedule-training.modal.controller',
                        'common.service',
                        'constant.service',
                        'course.service',
                        'paging-for-query-builder.service'
                    ])
                })
                .state('techo.training.schedule', {
                    url: '/schedule',
                    title: 'Schedule Training',
                    templateUrl: 'app/training/trainingschedule/views/training-schedule.html',
                    controller: 'TrainingScheduleCtrl as trainingSchedule',
                    resolve: load([
                        'training-schedule.controller',
                        'training-schedule.service',
                        'course.service',
                        'role.service',
                        'datePicker.directive',
                        'attendee-selection.modal.controller'
                    ])
                })
                .state('techo.home', {
                    url: "/home",
                    template: '<ui-view></ui-view>'
                })
                .state('techo.dashboard.fhs', {
                    url: '/fhs',
                    title: ENV.implementation === 'dnhdd' ? 'Family Folder Dashboard' : 'FHS Dashboard',
                    templateUrl: 'app/fhs/dashboard/views/fhs-dashboard.html',
                    controller: 'FhsDashboardController as fhsdashboard',
                    resolve: load([
                        'fhs-dashboard.controller',
                        'fhs-dashboard.service',
                        'alasql',
                        'ngmap'
                    ])
                })

                .state('techo.dashboard.fhsreport', {
                    url: '/fhsreport/:locationId/:userId',
                    title: 'FHS Report',
                    templateUrl: 'app/fhs/dashboard/views/fhs-report.html',
                    controller: 'FhsReportController as fhsreport',
                    params: {
                        userId: null
                    },
                    resolve: load([
                        'fhs-report.controller',
                        'fhs-dashboard.service'
                    ])
                })
                .state('techo.dashboard.webtasks', {
                    url: '/webtasks/:id',
                    title: '',
                    templateUrl: 'app/manage/webtasks/views/webtasks.html',
                    // controller: 'WebTasksController as webtasks',
                    resolve: load([

                    ])
                })
                .state('techo.training.dashboard', {
                    url: '/dashboard',
                    title: 'My Training Dashboard',
                    templateUrl: 'app/training/mytrainingdashboard/views/dashboard.html',
                    controller: 'DashboardCtrl as dashboard',
                    resolve: load([
                        'dashboard.controller',
                        'training-schedule.service',
                        'topicCoverage.service',
                        'common.service',
                        'ngInfiniteScroll',
                        'paging.service'
                    ])
                })
                .state('techo.training.dashboardDetails', {
                    url: '/dashboarddetails/:trainerId/:trainingId/:trainingDate',
                    title: 'Training Dashboard Details',
                    templateUrl: 'app/training/mytrainingdashboard/views/dashboard-details.html',
                    controller: 'DashboardDetailsCtrl as dashboardDetails',
                    resolve: load([
                        'dashboard-details.controller',
                        'training-schedule.service',
                        'attendance.service',
                        'topicCoverage.service',
                        'reason-topic.modal.controller',
                        'reason-attendance.modal.controller'
                    ])
                })
                .state('techo.training.traineeStatus', {
                    url: '/traineestatus?{queryParams:json}',
                    params: { queryParams: null },
                    title: 'Trainee Status',
                    templateUrl: 'app/training/traineestatus/views/trainee-status.html',
                    controller: 'TraineeStatusCtrl as traineeStatusCtrl',
                    resolve: load([
                        'trainee-status.controller',
                        'training-schedule.service',
                        'common.service'
                    ])
                })
                .state('techo.training.editTraineeStatus', {
                    url: '/edittraineestatus/:trainingId',
                    title: 'Mark Training Completion',
                    templateUrl: 'app/training/traineestatus/views/edit-trainee-status.html',
                    controller: 'EditTraineeStatusCtrl as editTraineeStatusCtrl',
                    params: {
                        paramOne: { flag: false }
                    },
                    resolve: load([
                        'edit-trainee-status.controller',
                        'training-schedule.service'
                    ])
                })
                .state('techo.manage.uploadlocation', {
                    url: '/uploadlocation',
                    title: 'Upload Location',
                    templateUrl: 'app/manage/uploadlocation/views/upload-location.html',
                    controller: 'UploadLocationController as uploadLocationCtrl',
                    resolve: load([
                        'upload-location.controller',
                        'upload-location.service'
                    ])
                })
                .state('techo.report', {
                    url: '/report',
                    template: '<ui-view></ui-view>',
                    abstract: true
                })
                .state('techo.report.config', {
                    url: '/config/:id',
                    title: 'Report Config',
                    templateUrl: 'app/admin/report/views/report-layout.html',
                    controller: 'ReportLayoutController as rl',
                    resolve: load([
                        'report-layout.controller',
                        'report.service',
                        'group.service',
                        'selectize.generator',
                        'user.service',
                        'jq-sortable.directive',
                        'paging.service'
                    ])
                })
                .state('techo.report.view', {
                    url: '/view/:id?from_link&type&{queryParams:json}',
                    params: {
                        queryParams: null
                    },
                    templateUrl: 'app/admin/report/views/report-view.html',
                    controller: 'ReportViewController as rv',
                    resolve: load([
                        'report.service',
                        'dynamicview.directive',
                        'report-view.controller',
                        'ngInfiniteScroll',
                        'paging.service',
                        'reportfieldutil.service',
                        'alasql',
                        'selectize.generator',
                        'user.service'
                    ])
                })
                .state('techo.report.all', {
                    url: '/all',
                    title: 'List of Reports',
                    templateUrl: 'app/admin/report/views/reports.html',
                    controller: 'ReportController as report',
                    resolve: load([
                        'report.service',
                        'reports.controller',
                        'group.service',
                        'paging.service',
                        'syncWithServerService'
                    ])
                })
                .state('techo.report.familyreport', {
                    url: '/familyreport',
                    title: 'Family Report',
                    templateUrl: 'app/manage/familyreport/views/family-report-view.html',
                    controller: 'FamilyReportViewController as familyreport',
                    resolve: load([
                        'report.service',
                        'family-report-view.controller',
                        'paging.service',
                        'ngInfiniteScroll'
                    ])
                })
                .state('techo.report.groups', {
                    url: '/groups',
                    title: 'Groups',
                    templateUrl: 'app/admin/report/views/report-group.html',
                    controller: 'ReportGroupController as reportGroup',
                    resolve: load([
                        'report.service',
                        'report-group.controller',
                        'group.service',
                        'report-group.modal.controller'

                    ])
                })
                // .state('techo.manage.districtperformancedashboard', {
                //     url: '/districtperformancedashboard',
                //     title: 'District Factsheet',
                //     templateUrl: 'app/manage/districtperformancedashboard/views/district-performance-dashboard.html',
                //     controller: 'DistrictPerformanceDashboardController as districtPerformanceDashboardCtrl',
                //     resolve: load([
                //         'districtPerformanceDashboardCtrl.controller',
                //         'number-format.filter',
                //         'show-tooltip',
                //         'district-performance-dashboard.service',
                //         'district-performance-dashboard.constants'
                //     ])
                // })
                .state('techo.manage.courselist', {
                    url: '/courselist',
                    title: 'Course',
                    templateUrl: 'app/training/courselist/views/course-list.html',
                    controller: 'CourseListController as courselistcontroller',
                    resolve: load([
                        'course.service',
                        'course-list.controller'
                    ])
                })
                .state('techo.manage.course', {
                    url: '/course/:id',
                    title: 'Manage Course',
                    templateUrl: 'app/training/courselist/views/course.html',
                    controller: 'CourseController as coursecontroller',
                    resolve: load([
                        'course.controller',
                        'update-course.modal.controller',
                        'update-module.modal.controller',
                        'authentication.service',
                        'course.service',
                        'course.constant',
                        'auto-focus.directive',
                        'role.service',
                        'constant.service',
                        'document.service',
                        'sohElementConfiguration.service',
                        'push-notification.service'
                    ])
                })
                .state('techo.training.questionsetlist', {
                    url: '/question-set-list/:refId/:refType',
                    title: 'Question Set Configuration',
                    templateUrl: 'app/training/questionconfiguration/views/question-set-list.html',
                    controller: 'QuestionSetListController as questionSetListController',
                    resolve: load([
                        'question-list.controller',
                        'course.service'
                    ])
                })
                .state('techo.training.questionset', {
                    url: '/question-set/:id/:refId/:refType',
                    title: 'Manage Question Set Configuration',
                    templateUrl: 'app/training/questionconfiguration/views/question-set.html',
                    controller: 'QuestionSetController as questionSetController',
                    resolve: load([
                        'question-set.controller',
                        'course.service'
                    ])
                })
                .state('techo.training.question', {
                    url: '/question/:id/:refId/:refType',
                    title: 'Manage Question Configuration',
                    templateUrl: 'app/training/questionconfiguration/views/configure-question.html',
                    controller: 'ConfigureQuestionController as configureQuestionController',
                    resolve: load([
                        'question.controller',
                        'course.service',
                        'reverseIterate.filter',
                        'statecapitalize.filter',
                        'document.service',
                        'sohElementConfiguration.service',
                    ])
                })
                .state('techo.manage.lmsdashboard', {
                    url: '/lmsdashboard',
                    title: 'LMS Dashboard',
                    templateUrl: 'app/training/dashboard/views/lms-dashboard.html',
                    controller: 'LMSDashboardController as lms',
                    resolve: load([
                        'lms-dashboard.controller',
                        'paging-for-query-builder.service'
                    ])
                })
                .state('techo.notification', {
                    url: '/event',
                    abstract: true,
                    template: '<ui-view></ui-view>'
                })
                .state('techo.notification.config', {
                    url: '/config/:id',
                    title: 'Event Configuration',
                    templateUrl: 'app/admin/applicationmanagement/event/views/manage-event-config.html',
                    controller: 'EventConfigurationController as eventConfig',
                    resolve: load([
                        'manage-event-config.controller',
                        'mobile-type-event-config.modal.controller',
                        'event-config.service',
                        'ckeditor.directive',
                        'notification.service',
                        'form.service',
                        'jq-sortable.directive',
                        'push-notification.service'
                    ])
                })
                .state('techo.notification.all', {
                    url: '/all',
                    title: 'Events Configuration',
                    templateUrl: 'app/admin/applicationmanagement/event/views/event-configs.html',
                    controller: 'EventConfigurationsController as eventConfigs',
                    resolve: load([
                        'event-configs.controller',
                        'event-config.service',
                        'notification.service',
                        'syncWithServerService',
                        'event-exception.modal.controller'
                    ])
                })
                .state('techo.manage.anganwadi', {
                    url: '/anganwadilist',
                    title: 'List of Anganwadis',
                    templateUrl: 'app/manage/anganwadi/views/anganwadi.html',
                    controller: 'AnganwadiListController as anganwadilistController',
                    resolve: load([
                        'anganwadi.service',
                        'anganwadi.controller',
                        'anganwadi.constant',
                        'paging.service',
                        'ngInfiniteScroll',
                    ])
                })
                .state('techo.manage.edit-anganwadi', {
                    url: '/anganwadi/:id',
                    title: 'Manage Location',
                    templateUrl: 'app/manage/anganwadi/views/manage-anganwadi.html',
                    controller: 'AnganwadiController as anganwadiController',
                    resolve: load([
                        'anganwadi.service',
                        'manage-anganwadi.controller',
                        'anganwadi.constant',
                        'numbers-only.directive',
                        'limitTo.directive'
                    ])
                })
                .state('techo.manage.location', {
                    url: '/location',
                    title: 'Manage Location',
                    templateUrl: 'app/manage/locations/views/location.html',
                    controller: 'LocationController as locationctrl',
                    resolve: load([
                        'location.controller',
                        'location.service',
                        'edit-location.controller'
                    ])
                })
                .state('techo.manage.edit-location', {
                    url: '/editlocation/:id',
                    title: 'Edit Location',
                    templateUrl: 'app/manage/locations/views/edit-location.html',
                    controller: 'EditLocationController as editlocationctrl',
                    resolve: load([
                        'edit-location.controller',
                        'location.service'
                    ]),
                    params: { location: null }
                })
                .state('techo.manage.add-location', {
                    url: '/addlocation',
                    title: 'Add Location',
                    templateUrl: 'app/manage/locations/views/add-location.html',
                    controller: 'AddLocationController as addlocationctrl',
                    resolve: load([
                        'add-location.controller',
                        'location.service',
                        'auto-focus.directive'
                    ])
                })
                .state('techo.manage.query', {
                    url: '/query',
                    title: 'Query master',
                    templateUrl: 'app/admin/applicationmanagement/querybuilder/views/query.html',
                    controller: 'QueryController as querycontroller',
                    resolve: load([
                        'query.controller',
                        'query.service',
                        'syncWithServerService'
                    ])
                })
                .state('techo.querymanagement', {
                    url: '/querymanagement',
                    title: 'Query Management Tool',
                    templateUrl: 'app/admin/applicationmanagement/querymanagement/views/query-management.html',
                    controller: 'QueryManagement as querymanagement',
                    resolve: load([
                        'query.controller',
                        'query.service',
                        'query-management.controller',
                        'query-management.service',
                        'authentication.service',
                        'ngInfiniteScroll',
                        'report.service',
                        'paging.service'
                    ])
                })
                .state('techo.manage.manageTranslation', {
                    url: '/manageTranslation',
                    title: 'Manage Translation',
                    templateUrl: 'app/admin/managetranslation/views/manage-translation.html',
                    controller: 'TranslationController as translator',
                    resolve: load([
                        'manage-translation.controller',
                        'app.controller',
                        'language.controller',
                        'label.controller',
                        'label-edit.controller',
                        'toggle-state.controller',
                        'translation.service',
                        'ngInfiniteScroll',
                        'paging-for-query-builder.service',
                    ])
                })
                .state('techo.manage.translator-label', {
                    url: '/translatorLabel',
                    title: 'Labels Translation',
                    templateUrl: 'app/admin/labelstranslation/views/label-translator.html',
                    controller: 'TranslatorLabelController as translatorLabel',
                    resolve: load([
                        'label-translator.controller',
                        'internationalization.service',
                        'paging.service',
                        'ngInfiniteScroll',
                    ])
                })
                .state('techo.manage.valuesnmultimedia', {
                    url: '/valuesnmultimedia',
                    title: 'Values And Multimedia',
                    templateUrl: 'app/admin/valuesandmultimedia/views/values-and-multi-media.html',
                    controller: 'ValueNMultimediaController as vnm',
                    resolve: load([
                        'values-and-multi-media.controller',
                        'multi-media-player.controller'
                    ])
                })
                .state('techo.manage.duplicateMemberVerification', {
                    url: '/duplicateMemberVerification',
                    title: 'Duplicate Member Verification',
                    templateUrl: 'app/manage/duplicatememberverification/views/duplicate-member-verification.html',
                    controller: 'DuplicateMemberVerificationController as dmv',
                    resolve: load([
                        'duplicate-member-verification.controller',
                        'authentication.service',
                        'ngInfiniteScroll',
                        'paging.service'
                    ])
                })
                // .state('techo.manage.familymoving', {
                //     url: '/familymoving',
                //     title: 'Family Moving',
                //     templateUrl: 'app/manage/familymoving/views/family-moving.html',
                //     controller: 'FamilyMovingController as fm',
                //     resolve: load([
                //         'family-moving.controller',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //         'anganwadi.service'
                //     ])
                // })
                // .state('techo.manage.verifiedfamilymoving', {
                //     url: '/verifiedfamilymoving',
                //     title: 'Verified Family Moving',
                //     templateUrl: 'app/manage/familymoving/views/family-moving.html',
                //     controller: 'FamilyMovingController as fm',
                //     resolve: load([
                //         'family-moving.controller',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //         'anganwadi.service'
                //     ])
                // })
                // .state('techo.manage.fhsworkbargraph', {
                //     url: '/fhsworkprogress',
                //     title: 'FHS WORK PROGRESS',
                //     templateUrl: 'app/manage/fhsworkprogress/views/fhs-verification-work-graph.html',
                //     controller: 'FhsWorkProgress as fwp',
                //     resolve: load([
                //         'fhs-verification-work-graph.controller'
                //     ])
                // })
                // .state('techo.manage.rchdatamigration', {
                //     url: '/rchdatamigration',
                //     title: 'RCH DATA MIGRATION',
                //     templateUrl: 'app/manage/views/rchDataMigration.html',
                //     controller: 'RchDataMigrationCtrl as rdm',
                //     resolve: load([
                //         'rchdatamigration.controller'
                //     ])
                // })
                // .state('techo.manage.createsync', {
                //     url: '/createsync',
                //     title: 'Create RCH Data Sync Request',
                //     templateUrl: 'app/manage/views/rchDataMigrationCreation.html',
                //     controller: 'RchDataMigrationCreationCtrl as rdmc',
                //     resolve: load([
                //         'rchdatamigrationcreation.controller',
                //         'rchdatamigrationcreationmodal.controller'
                //     ]),
                //     params: { userId: null }
                // })
                // .state('techo.manage.ancformquestions', {
                //     url: '/ancformquestions/:id',
                //     templateUrl: 'app/manage/facilitydataentry/anc/views/anc-form-questions.html',
                //     controller: 'AncFormQuestionsController as ancque',
                //     title: 'ANC Service Visit',
                //     resolve: load([
                //         'anc-form-questions.controller',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //         'anc-form-questions.service',
                //         'selectize.generator',
                //         'selectize.generator',
                //     ])
                // })
                // .state('techo.manage.ancformquestionsdynamic', {
                //     url: '/ancformquestionsdynamic/:id',
                //     templateUrl: 'app/manage/facilitydataentry/anc/dynamic/views/anc-form-questions.html',
                //     controller: 'AncFormQuestionsController as ctrl',
                //     title: 'ANC Service Visit',
                //     resolve: load([
                //         'anc-form-questions-dynamic.controller',
                //         'authentication.service',
                //         'ngInfiniteScroll',
                //         'paging.service',
                //         'anc-form-questions.service',
                //         'selectize.generator',
                //         'selectize.generator',
                //     ])
                // })
                // .state('techo.manage.pncdynamic', {
                //     url: '/pncdynamic/:id',
                //     templateUrl: 'app/manage/facilitydataentry/pnc/dynamic/views/manage-pnc.html',
                //     controller: 'ManagePncController as ctrl',
                //     title: 'PNC Service Visit',
                //     resolve: load([
                //         'manage-pnc-dynamic.controller',
                //         'pnc.service',
                //         'anganwadi.service'
                //     ])
                // })
                // .state('techo.manage.childservicedynamic', {
                //     url: '/childservicedynamic/:id',
                //     templateUrl: 'app/manage/facilitydataentry/childservice/dynamic/views/manage-child-service.html',
                //     controller: 'ManageChildServiceController as ctrl',
                //     title: 'Child Service Visit',
                //     resolve: load([
                //         'manage-child-service-dynamic.controller',
                //         'child-service.service',
                //     ])
                // })
                // .state('techo.manage.sicklecelldynamic', {
                //     url: '/sicklecelldynamic/:id',
                //     title: 'Sickle Cell Screening',
                //     templateUrl: 'app/manage/facilitydataentry/sicklecell/dynamic/views/sicklecell.html',
                //     controller: 'SicklecellController as ctrl',
                //     resolve: load([
                //         'sicklecell-dynamic.controller',
                //         'sicklecell.service',
                //     ])
                // })
                .state('techo.manage.facilityPerformancedynamic', {
                    url: '/facilityperformancedynamic',
                    title: 'Facility Performance',
                    templateUrl: 'app/manage/facilitydataentry/facilityperformance/dynamic/views/facility-performance.html',
                    controller: 'FacilityPerformanceController as ctrl',
                    resolve: load([
                        'facility-performance-dynamic.controller',
                        'facility-performance.service'
                    ])
                })
                .state('techo.manage.medicinesdynamic', {
                    url: '/medicinesdynamic/:id',
                    title: 'Medicines given as per protocol',
                    templateUrl: 'app/manage/childscreening/dynamic/views/medicines.html',
                    controller: 'MedicinesController as ctrl',
                    resolve: load([
                        'medicines-dynamic.controller',
                        'child-screening.service'
                    ])
                })
                .state('techo.manage.laboratorytestsdynamic', {
                    url: '/laboratorytestsdynamic/:id',
                    title: 'Laboratory Tests Update',
                    templateUrl: 'app/manage/childscreening/dynamic/views/laboratory-tests.html',
                    controller: 'LaboratoryTestsController as ctrl',
                    resolve: load([
                        'laboratory-tests-dynamic.controller',
                        'child-screening.service'
                    ])
                })
                .state('techo.manage.childscreeningdynamic', {
                    url: '/childscreeningdynamic/:action/:id',
                    title: '',
                    templateUrl: 'app/manage/childscreening/dynamic/views/child-screening.html',
                    controller: 'ChildScreeningController as ctrl',
                    resolve: load([
                        'child-screening-dynamic.controller',
                        'child-screening.service'
                    ])
                })
                .state('techo.manage.managelocationtypedynamic', {
                    url: '/managelocationtypedynamic/:id',
                    title: 'Manage Location Type',
                    templateUrl: 'app/manage/locationtype/dynamic/views/manage-location-type.html',
                    controller: 'ManageLocationTypeController as ctrl',
                    resolve: load([
                        'manage-location-type-dynamic.controller',
                        'query.service',
                        'location.service',
                    ])
                })
                .state('techo.manage.staffsmsconfigdynamic', {
                    url: '/staffsmsconfigdynamic/:id',
                    title: '',
                    templateUrl: 'app/manage/staffsmsconfig/dynamic/views/manage-staff-sms-config.html',
                    controller: 'ManageStaffSmsConfigController as ctrl',
                    resolve: load([
                        'manage-staff-sms-config-dynamic.controller',
                        'staff-sms-config.service',
                        'user.service',
                        'role.service'
                    ])
                })
                .state('techo.manage.healthinfrastructures', {
                    url: '/healthinfrastructures',
                    templateUrl: 'app/manage/healthfacilitymapping/views/health-infrastructure.html',
                    title: 'Health Facility Mapping',
                    controller: 'HealthInfrastructureController as healthInfrastructure',
                    resolve: load([
                        'health-infrastructure.controller',
                        'query.service',
                        'ngInfiniteScroll',
                        'hospital-type-display-name.filter',
                        'health-infrastructure-service',
                        'paging-for-query-builder.service'
                    ])
                })
                .state('techo.manage.healthinfrastructure', {
                    url: '/healthinfrastructure/:id',
                    title: 'Health Infrastructure',
                    templateUrl: 'app/manage/healthfacilitymapping/views/manage-health-infrastructure.html',
                    controller: 'ManageHealthInfrastructure as hi',
                    resolve: load([
                        'manage-health-infrastructure.controller',
                        'query.service',
                        'location.service',
                        'health-infrastructure-service'
                    ])
                })
                // .state('techo.manage.covid19healthinfrastructures', {
                //     url: '/covid-19/healthinfrastructures',
                //     templateUrl: 'app/manage/healthfacilitymapping/views/health-infrastructure.html',
                //     title: 'COVID-19 : Manage Health Infrastructure',
                //     controller: 'HealthInfrastructureController as healthInfrastructure',
                //     resolve: load([
                //         'health-infrastructure.controller',
                //         'facility-linking.modal.controller',
                //         'query.service',
                //         'ngInfiniteScroll',
                //         'hospital-type-display-name.filter',
                //         'health-infrastructure-service'
                //     ])
                // })
                // .state('techo.manage.covid19healthinfrastructure', {
                //     url: '/covid-19/healthinfrastructure/:id',
                //     title: 'COVID-19 : Manage Health Infrastructure',
                //     templateUrl: 'app/manage/healthfacilitymapping/views/manage-health-infrastructure.html',
                //     controller: 'ManageHealthInfrastructure as hi',
                //     resolve: load([
                //         'manage-health-infrastructure.controller',
                //         'facility-linking.modal.controller',
                //         'query.service',
                //         'location.service',
                //         'health-infrastructure-service'
                //     ])
                // })
                .state('techo.manage.allservicedashboard', {
                    url: '/allservicedashboard',
                    title: 'All service Dashboard',
                    templateUrl: 'app/manage/allservicedashboard/views/all-service-dashboard-main-page.html',
                    controller: 'AllServiceDashboardMainPageController as ctrl',
                    abstract: true,
                    resolve: load([
                        'all-service-controller-main-page.controller'
                    ])
                })
                .state('techo.manage.allservicedashboard.householddashboard', {
                    url: '',
                    title: 'All Service Dashboard',
                    templateUrl: 'app/manage/allservicedashboard/views/household-dashboard.html',
                    controller: 'HouseholdDashboardController as ctrl',
                    resolve: load([
                        'household-dashboard.controller'
                    ])
                })
                .state('techo.manage.allservicedashboard.pwdashboard', {
                    url: '',
                    title: 'All Service Dashboard',
                    templateUrl: 'app/manage/allservicedashboard/views/pregnant-women-dashboard.html',
                    controller: 'PregnantWomenDashboardController as ctrl',
                    resolve: load([
                        'pregnant-women-dashboard.controller'
                    ])
                })
                .state('techo.manage.allservicedashboard.u5dashboard', {
                    url: '',
                    title: 'All Service Dashboard',
                    templateUrl: 'app/manage/allservicedashboard/views/under-5-dashboard.html',
                    controller: 'Under5DashboardController as ctrl',
                    resolve: load([
                        'under-5-dashboard.controller'
                    ])
                })
                .state('techo.manage.allservicedashboard.malariadashboard', {
                    url: '',
                    title: 'All Service Dashboard',
                    templateUrl: 'app/manage/allservicedashboard/views/malaria-dashboard.html',
                    controller: 'MalariaDashboardController as ctrl',
                    resolve: load([
                        'malaria-dashboard.controller'
                    ])
                })
                .state('techo.manage.allservicedashboard.tbdashboard', {
                    url: '',
                    title: 'All Service Dashboard',
                    templateUrl: 'app/manage/allservicedashboard/views/tuberculosis-dashboard.html',
                    controller: 'TuberculosisDashboardController as ctrl',
                    resolve: load([
                        'tuberculosis-dashboard.controller'
                    ])
                })
                .state('techo.manage.allservicedashboard.coviddashboard', {
                    url: '',
                    title: 'All Service Dashboard',
                    templateUrl: 'app/manage/allservicedashboard/views/covid-dashboard.html',
                    controller: 'CovidDashboardController as ctrl',
                    resolve: load([
                        'covid-dashboard.controller'
                    ])
                })
                .state('techo.manage.allservicedashboard.hivdashboard', {
                    url: '',
                    title: 'All Service Dashboard',
                    templateUrl: 'app/manage/allservicedashboard/views/hiv-dashboard.html',
                    controller: 'HivDashboardController as ctrl',
                    resolve: load([
                        'hiv-dashboard.controller'
                    ])
                })
                // .state('techo.manage.ancSearch', {
                //     url: '/ancsearch', 
                //     title: 'ANC Service Visit',
                //     templateUrl: 'app/manage/facilitydataentry/anc/views/anc-search.html',
                //     controller: 'ANCSearchController as queform',
                //     resolve: load([
                //         'anc-search.controller',
                //         'anc-form-questions.service',
                //         'wpd.service',
                //         'ngInfiniteScroll',
                //         'paging.service'

                //     ])
                // })
                // .state('techo.manage.servermanage', {
                //     url: '/servermanage',
                //     title: 'Server management',
                //     templateUrl: 'app/admin/applicationmanagement/servermanagement/views/server-management.html',
                //     controller: 'ServerManagementController as servermanagecontroller',
                //     resolve: load([
                //         'server-management.controller',
                //         'servermanage.service'
                //     ])
                // })
                // .state('techo.manage.migrations', {
                //     url: '/migrations?selectedIndex&locationId',
                //     params: {
                //         selectedIndex: {
                //             value: '0'
                //         },
                //         locationId: {
                //             value: null
                //         }
                //     },
                //     title: 'Manage Migrations',
                //     templateUrl: 'app/manage/membermigration/views/migrations.html',
                //     controller: 'MigrationsController as migrations',
                //     resolve: load([
                //         'migrations.controller',
                //         'ngInfiniteScroll',
                //         'migration.service',
                //         'search-members.controller',
                //         'paging.service'
                //     ])
                // })
                .state('techo.manage.migrationInfomation', {
                    url: '/memberInformation/:memberId?migrationId&locationId',
                    title: 'Manage Migration',
                    params: {
                        locationId: {
                            value: undefined
                        }
                    },
                    templateUrl: 'app/manage/membermigration/views/manage-similar-members.html',
                    controller: 'ManageSimilarMembersController as sm',
                    resolve: load([
                        'ngInfiniteScroll',
                        'mark-as-lfu.modal.controller',
                        'manage-similar-members.controller',
                        'migration.service'
                    ])
                })
                .state('techo.manage.facilityPerformance', {
                    url: '/facilityperformance',
                    title: 'Facility Performance',
                    templateUrl: 'app/manage/facilitydataentry/facilityperformance/views/facility-performance.html',
                    controller: 'FacilityPerformanceController as facilityPerformanceController',
                    resolve: load([
                        'facility-performance.controller',
                        'facility-performance.service'
                    ])
                })
                .state('techo.manage.managevolunteers', {
                    url: '/managevolunteers',
                    title: 'Manage Volunteers',
                    templateUrl: 'app/manage/views/manage-volunteers.html',
                    controller: 'ManageVolunteersController as managevolunteerscontroller',
                    resolve: load([
                        'manage-volunteers.controller',
                        'manage-volunteers.service'
                    ])
                })
                // .state('techo.manage.manage-widgets', {
                //     url: '/widgets',
                //     title: 'Manage Widgets',
                //     templateUrl: 'app/admin/applicationmanagement/widgetmanagement/views/widget-management.html',
                //     controller: 'ManageWidgetsController as manageWidgetsController',
                //     resolve: load([
                //         'widget-management.controller',
                //         'notification.service',
                //         'statecapitalize.filter',
                //         'selectize.generator'
                //     ])
                // })
                // .state('techo.manage.expectedTarget', {
                //     url: '/expectedtarget',
                //     title: 'Location Wise Expected Target',
                //     templateUrl: 'app/manage/administration/locationwiseexpectedtarget/views/expected-target.html',
                //     controller: 'ExpectedTargetController as expectedTargetController',
                //     resolve: load([
                //         'expected-target.controller',
                //         'expected-target.service',
                //         'alasql'
                //     ])
                // })
                .state('techo.manage.searchMembers', {
                    url: '/searchMembers/:migrationId',
                    title: 'Search Members',
                    templateUrl: 'app/common/views/search-members.html',
                    controller: 'SearchMembersController as searchMembers',
                    resolve: load([
                        'ngInfiniteScroll',
                        'search-members.controller',
                        'migration.service',
                        'paging.service'
                    ])
                })
                .state('techo.manage.userhealthapproval', {
                    url: '/userhealthapproval',
                    title: 'State Of Health User Approval',
                    templateUrl: 'app/manage/sohuserapproval/views/soh-user-approval.html',
                    controller: 'UserHealthApprovalsController as uha',
                    resolve: load([
                        'soh-user-approval.controller',
                        'soh-user-approve.modal.controller',
                        'soh-user-approval.service',
                        'soh-user-disapprove.modal.controller'
                    ])
                })

                // .state('techo.manage.queryexcelsheetgenerator', {
                //     url: '/queryexcelsheetgenerator',
                //     title: 'Generate Excel Sheet',
                //     templateUrl: 'app/admin/applicationmanagement/queryexcelsheetgenerator/views/query-excel-sheet-generator.html',
                //     controller: 'ExcelGenereatorController as excelGenereatorController',
                //     resolve: load([
                //         'query-excel-sheet-generator.controller',
                //         'query.service',
                //         'report.service',
                //     ])
                // })

                .state('techo.manage.staffsmsconfig', {
                    url: '/staffsmsconfig/:id',
                    title: 'Add Staff Sms Config',
                    templateUrl: 'app/manage/staffsmsconfig/views/manage-staff-sms-config.html',
                    controller: 'ManageStaffSmsConfigController as staffSmsConfig',
                    resolve: load([
                        'user.service',
                        'manage-staff-sms-config.controller',
                        'role.service',
                        'authentication.service',
                        'query.service',
                        'staff-sms-config.service',
                        'dynamicview.directive',
                        'staff-sms-config.constant'
                    ])
                })
                .state('techo.manage.staffsmsconfigs', {
                    url: '/staffsmsconfigs',
                    title: 'List Of Staff Sms',
                    templateUrl: 'app/manage/staffsmsconfig/views/staff-sms-config.html',
                    controller: 'StaffSmsController as staffSmsConf',
                    resolve: load([
                        'staff-sms-config.controller',
                        'authentication.service',
                        'staff-sms-config.service',
                        'user-list.modal.controller'
                    ])
                })


                .state('techo.manage.systemconfigs', {
                    url: 'systemconfigs',
                    title: 'System Config List',
                    templateUrl: 'app/admin/applicationmanagement/systemconfig/views/system-config.html',
                    controller: 'SystemConfigListController as ctrl',
                    resolve: load([
                        'system-config.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.systemconfig', {
                    url: '/admin/applicationmanagement/systemconfig/:key',
                    title: 'Manage System Config',
                    templateUrl: 'app/admin/applicationmanagement/systemconfig/views/manage-system-config.html',
                    controller: 'ManageSystemConfigController as ctrl',
                    resolve: load([
                        'manage-system-config.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.dynamicform', {
                    url: '/dynamicform/:formId',
                    title: 'Dynamic Form Builder',
                    templateUrl: 'app/admin/dynamicformbuilder/views/dynamic-form.html',
                    controller: 'DynamicFormBuilderController as dFormCtrl',
                    resolve: load([
                        'dynamic-form.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.dynamicformconfig', {
                    url: '/dynamicformconfig/:formConfigId/:formId',
                    title: 'Dynamic Form Builder',
                    templateUrl: 'app/admin/dynamicformbuilder/views/manage-dynamic-form.html',
                    controller: 'ManageDynamicFormBuilderController as mdFormCtrl',
                    resolve: load([
                        'manage-dynamic-form.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.sohElementConfiguration', {
                    url: '/sohelementconfiguration?selectedTab',
                    params: {
                        selectedTab: {
                            value: '0'
                        }
                    },
                    title: 'SoH Element Configuration',
                    templateUrl: 'app/admin/soh/views/element-configuration.html',
                    controller: 'SohElementConfiguration as sohElementConfiguration',
                    resolve: load([
                        'sohElementConfiguration.controller',
                        'sohElementConfiguration.service',
                        'query.service',
                    ])
                })
                .state('techo.manage.manageSohElementConfiguration', {
                    url: '/sohelementconfiguration/manage/:id',
                    title: 'Manage SoH Element Configuration',
                    templateUrl: 'app/admin/soh/views/manage-element-configuration.html',
                    controller: 'ManageSohElementConfiguration as manageSohElementConfiguration',
                    resolve: load([
                        'manageSohElementConfiguration.controller',
                        'sohElementConfiguration.service',
                        'query.service',
                        'reverseIterate.filter',
                        'sohelement.constants',
                        'document.service'
                    ])
                })
                .state('techo.manage.manageSohChartConfiguration', {
                    url: '/sohchartconfiguration/manage/:id',
                    title: 'Manage SoH Chart Configuration',
                    templateUrl: 'app/admin/soh/views/manage-chart-configuration.html',
                    controller: 'ManageSohChartConfiguration as ctrl',
                    resolve: load([
                        'manageSohChartConfiguration.controller',
                        'sohElementConfiguration.service',
                        'query.service'
                    ])
                })
                .state('techo.manage.manageSohElementModuleConfiguration', {
                    url: '/sohelementmoduleconfiguration/manage/:id',
                    title: 'Manage SoH Element Module Configuration',
                    templateUrl: 'app/admin/soh/views/manage-element-module-configuration.html',
                    controller: 'ManageSohElementModuleConfiguration as ctrl',
                    resolve: load([
                        'manageSohElementModuleConfiguration.controller',
                        'sohElementConfiguration.service',
                        'query.service'
                    ])
                })
                .state('techo.manage.sohApp', {
                    url: '/sohApplication',
                    title: 'State Of Health Application',
                    templateUrl: 'app/admin/soh/views/soh-application.html',
                    controller: 'SohApp as ctrl',
                    resolve: load([
                        'sohApp.controller'
                    ])
                })
                // .state('techo.manage.wards', {
                //     url: '/wards',
                //     templateUrl: 'app/manage/rchdatapush/wards/views/wards.html',
                //     title: 'Manage Location Wards',
                //     controller: 'WardController as ctrl',
                //     resolve: load([
                //         'ward.controller',
                //         'query.service',
                //         'ngInfiniteScroll'
                //     ])
                // })
                // .state('techo.manage.ward', {
                //     url: '/ward/:id',
                //     templateUrl: 'app/manage/rchdatapush/wards/views/manage-wards.html',
                //     title: 'Manage Location Wards',
                //     controller: 'ManageWardController as ctrl',
                //     resolve: load([
                //         'manage-ward.controller',
                //         'query.service',
                //         'location.service',
                //     ])
                // })
                // .state('techo.manage.rchLocations', {
                //     url: '/rchLocation',
                //     title: 'RCH Locations',
                //     templateUrl: 'app/manage/rchdatapush/rchlocations/views/rch-location.html',
                //     controller: 'RchLocationController as ctrl',
                //     resolve: load([
                //         'rch-location.controller',
                //         'query.service',
                //         'ngInfiniteScroll',
                //     ])
                // })
                .state('techo.manage.featureUsage', {
                    url: '/featureusage',
                    templateUrl: 'app/admin/featureusage/views/feature-usage-new.html',
                    title: 'Feature Usage Analytics',
                    controller: 'FeatureUsageController as ctrl',
                    resolve: load([
                        'feature-usage.controller',
                        'query.service',
                        'roles.service',
                        'feature-usage.constant'
                    ])
                })
                // .state('techo.manage.featureSync', {
                //     url: '/applicationmanagement/featureSync',
                //     templateUrl: 'app/admin/applicationmanagement/featuresync/views/feature-sync.html',
                //     title: 'Manage Feature Syncing',
                //     controller: 'FeatureSyncController as featureCtrl',
                //     resolve: load([
                //         'feature-sync.controller',
                //         'paging.service',
                //         'ngInfiniteScroll',
                //     ])
                // })
                // .state('techo.manage.syncServerManage', {
                //     url: '/applicationmanagement/syncServerManage',
                //     templateUrl: 'app/admin/applicationmanagement/syncServerManage/views/sync-server-manage.html',
                //     title: 'Sync Server Manage',
                //     controller: 'syncServerManageController as syncServerCtrl',
                //     resolve: load([
                //         'syncServerManage.controller',
                //     ])
                // })
                .state('techo.manage.manageOpdLabTest', {
                    url: '/labTestList',
                    title: 'OPD Lab Test List',
                    templateUrl: 'app/admin/manageopd/opd/views/lab-test-list.html',
                    controller: 'LabTestList as labTestConfiguration',
                    resolve: load([
                        'labTestList.controller',
                        'paging.service'
                    ])
                })
                .state('techo.manage.opdLabTest', {
                    url: '/manageLabTest/:id',
                    title: 'Manage OPD Lab Test',
                    templateUrl: 'app/admin/manageopd/opd/views/lab-test-manage.html',
                    controller: 'LabTestManage as manageLabTest',
                    resolve: load([
                        'manageLabTest.controller',
                        'paging.service',
                        'labTest.service'
                    ])
                })
                .state('techo.manage.dtcInterface', {
                    url: '/covid-19/dtcInterface',
                    title: 'COVID-19 - DTC Interface',
                    templateUrl: 'app/manage/covid19/dtcinterface/views/dtc-interface.html',
                    controller: 'DtcInterface as ctrl',
                    resolve: load([
                        'dtc-interface.controller',
                        'query.service',
                        'ngInfiniteScroll',
                    ])
                })
                .state('techo.manage.searchcovidtechomembers', {
                    url: '/covid-19/search',
                    title: 'Search Techo Members',
                    templateUrl: 'app/manage/covid19/hospitaladmission/views/search-covid-member.html',
                    controller: 'SearchCovidController as searchcovid',
                    resolve: load([
                        'search-covid-member.controller',
                        'authentication.service',
                        'ngInfiniteScroll',
                        'paging.service',
                    ])
                })
                .state('techo.manage.covidtravellers', {
                    url: '/covid-19/covidtravellers',
                    title: 'Covid Travellers Screening',
                    templateUrl: 'app/manage/covid19/travellerscreening/views/traveller-screening.html',
                    controller: 'CovidTravellersScreening as covidscreening',
                    resolve: load([
                        'traveller-screening.controller',
                        'covid.service',
                        'authentication.service'
                    ])
                })
                .state('techo.manage.covidcases', {
                    url: '/covid-19/covidcases',
                    title: 'COVID-19 Contact Tracing',
                    templateUrl: 'app/manage/covid19/contacttracing/views/contact-tracing.html',
                    controller: 'CovidCasesController as covidCasesCtrl',
                    resolve: load([
                        'contact-tracing.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.manageCovidCases', {
                    url: '/covid-19/manageCovidCases/:id',
                    title: 'Manage COVID-19 Cases',
                    templateUrl: 'app/manage/covid19/contacttracing/views/manage-contact-tracing.html',
                    controller: 'ManageCovidCasesController as manageCovidCasesCtrl',
                    resolve: load([
                        'manage-contact-tracing.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.manageCovidTravelHistory', {
                    url: '/covid-19/managecovidtravelhistory/:contactId',
                    title: 'Manage COVID-19 Travel History',
                    templateUrl: 'app/manage/covid19/contacttracing/views/manage-travel-history.html',
                    controller: 'ManageCovidTravelHistoryController as manageCovidTravelHistoryCtrl',
                    resolve: load([
                        'manage-travel-history.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.covidAdmission', {
                    url: '/covid-19/covidadmission',
                    templateUrl: 'app/manage/covid19/hospitaladmission/views/admission.html',
                    title: 'Hospital Admission',
                    controller: 'CovidTravellersAdmission as covidAdmissionctrl',
                    resolve: load([
                        'admission.controller',
                        'query.service',
                        'covid.service',
                        'daily-checkup.modal.controller',
                        'paging.service',
                        'ngInfiniteScroll',
                        'discharge.modal.controller',
                        'refer-in-admit.modal.controller'
                    ])
                })
                .state('techo.manage.covidLabTestEntry', {
                    url: '/covid-19/covidlabtestentry',
                    templateUrl: 'app/manage/covid19/opdlabtest/views/opd-lab-test.html',
                    title: 'OPD Lab Test Entry',
                    controller: 'CovidLabTestEntry as covidLabTestEntryCtrl',
                    resolve: load([
                        'opd-lab-test.controller',
                        'query.service',
                        'covid.service',
                        'paging.service',
                        'ngInfiniteScroll',
                    ])
                })
                .state('techo.manage.labTestAdmin', {
                    url: '/covid-19/labtestadmin',
                    templateUrl: 'app/manage/covid19/labtestadmin/views/lab-test-admin.html',
                    title: 'COVID-19 Lab Test Admin',
                    controller: 'LabTestAdminController as lbtCtrl',
                    resolve: load([
                        'lab-test-admin.controller',
                        'edit-admission.modal.controller',
                        'edit-opd-lab-test.modal.controller',
                        'trasfer-hospital.modal.controller',
                        'query.service',
                        'covid.service',
                        'paging.service',
                    ])
                })
                .state('techo.manage.104calls', {
                    url: '/covid-19/104calls',
                    title: '104 Calls',
                    templateUrl: 'app/manage/covid19/104call/views/104-calls.html',
                    controller: 'Calls104Controller as calls104Ctrl',
                    resolve: load([
                        '104-calls.controller',
                        'query.service',
                        'ngInfiniteScroll',
                        'paging.service',
                    ])
                })
                .state('techo.manage.manage104Calls', {
                    url: '/covid-19/manage104calls/:id',
                    title: 'Manage 104 Calls',
                    templateUrl: 'app/manage/covid19/104call/views/manage-104-calls.html',
                    controller: 'Manage104CallsController as manage104CallsCtrl',
                    resolve: load([
                        'manage-104-calls.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.emodashboard', {
                    url: '/covid-19/emodashboard',
                    title: 'Covid2019 Suspect List',
                    templateUrl: 'app/manage/covid19/suspectedlist/views/suspected-list.html',
                    controller: 'EmoDashboardController as emo',
                    resolve: load([
                        'suspected-list.controller',
                        'covid.service',
                        'query.service',
                        'ngInfiniteScroll',
                        'paging.service',
                    ])
                })
                .state('techo.manage.labtest', {
                    url: '/covid-19/labtest',
                    title: 'Lab',
                    templateUrl: 'app/manage/covid19/labtest/views/labtest-dashboard.html',
                    controller: 'LabTestController as labtest',
                    resolve: load([
                        'labtest-dashboard.controller',
                        'covid.service',
                        'query.service',
                        'ngInfiniteScroll',
                        'paging.service',
                    ])
                })
                .state('techo.manage.labinfrastructure', {
                    url: '/covid-19/labinfrastructure',
                    title: 'Manage Lab Infrastructure',
                    templateUrl: 'app/manage/covid19/labinfrastructure/views/lab-infras.html',
                    controller: 'Labinfrastructures as labinfrastructures',
                    resolve: load([
                        'lab-infras.controller',
                        'query.service',
                    ])
                })
                .state('techo.manage.updatelabinfrastructure', {
                    url: '/covid-19/labinfrastructure/:id',
                    title: 'Manage Lab Infrastructure',
                    templateUrl: 'app/manage/covid19/labinfrastructure/views/update-lab-infras.html',
                    controller: 'Labinfrastructure as labinfrastructure',
                    resolve: load([
                        'update-lab-infras.controller',
                        'query.service',
                    ])
                })
                .state('techo.manage.idspFormS', {
                    url: '/idsp/form-s',
                    title: 'IDSP Form S',
                    templateUrl: 'app/manage/idsp/views/form-s.html',
                    controller: 'IDSPFormS as ctrl',
                    resolve: load([
                        'idspFormS.controller',
                        'query.service',
                        'idsp.service',
                        'idspFormS.constants'
                    ])
                })
                // .state('techo.manage.systemcode', {
                //     url: '/systemcode',
                //     title: 'System Codes',
                //     templateUrl: 'app/manage/systemcode/views/manage-codes.html',
                //     controller: 'SystemCodeController as ctrl',
                //     resolve: load([
                //         'manage-codes.controller',
                //         'query.service',
                //         'servermanage.service',
                //         'manage-codes.service',
                //         'edit-code.modal.controller'
                //     ])
                // })
                .state('techo.manage.covid19Dashboard', {
                    url: '/covid-19/dashboard',
                    title: 'COVID-19 Rapid Response Dashboard',
                    templateUrl: 'app/manage/covid19/rapidresponsedashboard/views/rapid-response-dashboard.html',
                    controller: 'Covid19DashboardController as covid19Dashboardctrl',
                    resolve: load([
                        'rapid-response-dashboard.controller',
                        'query.service',
                    ])
                })
                .state('techo.manage.symptomaticMembersHeatmap', {
                    url: '/covid-19/symptomaticMembersHeatmap',
                    title: "Spatial Distribution Of Cases",
                    templateUrl: 'app/manage/covid19/symptomaticmembersheatmap/views/symptomatic-members-heatmap.html',
                    controller: 'SymptomaticMembersHeatmapController as heatMapCtrl',
                    resolve: load([
                        'symptomatic-members-heatmap.controller',
                        'query.service',
                        'alasql'
                    ])
                })

                .state('techo.manage.covid19AdmissionReport', {
                    url: '/covid-19/form-s/:id',
                    title: 'Patient Case Sheet',
                    templateUrl: 'app/manage/covid19/hospitaladmission/views/admission-report.html',
                    controller: 'Covid19AdmissionReport as ctrl',
                    resolve: load([
                        'admission-report.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.locationClusterManagement', {
                    url: '/covid-19/locationClusterManagement',
                    title: 'COVID 19 Cluster Management',
                    templateUrl: 'app/manage/covid19/locationcluster/views/location-cluster.html',
                    controller: 'LocationClusterMangementCtrl as locationClusterMangementCtrl',
                    resolve: load([
                        'location-cluster.controller',
                        'query.service'
                    ])
                })
                .state('techo.manage.manageLocationClusterManagement', {
                    url: '/covid-19/manageLocationClusterManagement/:id',
                    title: 'COVID 19 Cluster Management',
                    templateUrl: 'app/manage/covid19/locationcluster/views/manage-location-cluster.html',
                    controller: 'ManagelocationClusterMangement as manageLocationClusterMangementCtrl',
                    resolve: load([
                        'manage-location-cluster.controller',
                        'query.service',
                        'user.service'
                    ])
                }).state('techo.admin.genericForm', {
                    url: '/dynamicForm?{config:json}',
                    params: { config: {} },
                    templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/views/medplat-form-generic.html',
                    controller: 'GenericFormController as ctrl',
                    title: 'Form',
                    resolve: load([
                        'medplat-form-generic.controller',
                        'ngInfiniteScroll',
                        'medplat-form-v2.service',
                        'immunisation.service'
                    ])
                })
                // .state('techo.manage.updateFamilyAreaList', {
                //     url: '/update-family-area',
                //     title: 'Update Family Area List',
                //     templateUrl: 'app/manage/administration/updatefamilyarea/views/update-family-area-list.html',
                //     controller: 'UpdateFamilyAreaList as ctrl',
                //     resolve: load([
                //         'update-family-area-list.controller',
                //         'query.service',
                //         'ngInfiniteScroll',
                //     ])
                // })
                .state('techo.admin.medplatForms', {
                    url: '/medplat-forms',
                    title: 'Form Configurator',
                    templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/views/medplat-forms.html',
                    controller: 'MedplatForms as ctrl',
                    resolve: load([
                        'medplat-forms.controller',
                        'medplat-form.service',
                        'medplat-form-v2.service',
                        'statecapitalize.filter',
                        'medplat-form-flyway.controller'
                    ])
                })
                .state('techo.admin.medplatForm', {
                    url: '/medplat-form/form/:uuid',
                    templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/views/medplat-form-V2.html',
                    title: 'Manage Form V2',
                    controller: 'MedplatFormV2 as ctrl',
                    resolve: load([
                        'medplat-form-v2.controller',
                        'medplat-form.directives',
                        'medplat-form.modals',
                        'medplat-form-v2.service',
                        'query.service',
                        'ui.ace',
                        'ui.tree',
                        'dndLists'
                    ])
                })
                .state('techo.admin.medplatFormWebLayout', {
                    url: '/medplat-form/form/web-layout/:uuid',
                    templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/views/medplat-form-web-layout.html',
                    title: 'Configure Form Web Layout',
                    controller: 'MedplatFormWebLayout as ctrl',
                    resolve: load([
                        'medplat-form-web-layout.controller',
                        'medplat-form-web-layout.directives',
                        'medplat-form-web-layout.modals',
                        'medplat-form.service',
                        'medplat-form-v2.service',
                        'ui.ace',
                        'dndLists'
                    ])
                })
                .state('techo.admin.medplatFormMobileLayout', {
                    url: '/medplat-form/form/mobile-layout/:uuid',
                    templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/views/medplat-form-mobile-layout.html',
                    title: 'Configure Mobile Layout',
                    controller: 'MedplatFormMobileLayout as ctrl',
                    resolve: load([
                        'medplat-form-mobile-layout.controller',
                        'medplat-form.service',
                        'dndLists'
                    ])
                })
                .state('techo.manage.healthInfrastructureType', {
                    url: '/health-infrastructure-type/:id',
                    title: 'Health Infrastructure Type Mapping',
                    templateUrl: 'app/manage/healthfacilitymapping/views/manage-health-infrastructure-type.html',
                    controller: 'ManageHealthInfrastructureType as ctrl',
                    resolve: load([
                        'manage-health-infrastructure-type.controller',
                        'query.service',
                        'location.service',
                        'update-health-infrastructure-mapping.controller'
                    ])
                })
                .state('techo.manage.memberInfoChangeAuditLog', {
                    url: '/member-info-change-audit-log',
                    title: 'Member Details Audit Log',
                    templateUrl: 'app/manage/helpdesktool/views/member-information-change-audit-log.html',
                    controller: 'MemberInfoChangeAuditLogController as ctrl',
                    resolve: load([
                        'member-information-change-audit-log.controller',
                        'query.service',
                        'document.service',
                        'ngInfiniteScroll',
                    ])
                })
                .state('techo.manage.reportoffline', {
                    url: '/report-offline',
                    title: 'Download Report Offline',
                    templateUrl: 'app/manage/reportoffline/views/report-offline.html',
                    controller: 'ReportOfflineCtrl as reportOfflineCtrl',
                    resolve: load([
                        'report-offline.controller',
                        'report-offline.constant',
                        'report.service',
                        'servermanage.service'
                    ])
                    // }).state('techo.manage.performancedashboard', {
                    //     url: '/dashboardpoc',
                    //     title: 'Performance Dashboard',
                    //     templateUrl: 'app/manage/performancedashboard/views/performance-dashboard.html',
                    //     controller: 'DashboardController as dashboardCtrl',
                    //     resolve: load([
                    //         'performance-dashboard.controller',
                    //         'performance-dashboard.constant',
                    //         'query.service',
                    //         'location.service',
                    //     ])
                })
                .state('techo.manage.mobileFeatureManagement', {
                    url: '/mobile-feature-management',
                    title: 'Mobile Feature Management',
                    templateUrl: 'app/manage/mobileFeatureManagement/views/mobile-feature-management.html',
                    controller: 'MobileFeatureManagementController as ctrl',
                    resolve: load([
                        'mobile-feature-management.controller',
                        'query.controller',
                        'query.service',
                        'authentication.service',
                        'mobile-feature.modal.controller',
                    ])
                })
                .state('techo.manage.mobileMenuManagement', {
                    url: '/mobile-menu-management',
                    title: 'Mobile Menu Management',
                    templateUrl: 'app/manage/mobileMenuManagement/views/mobile-menu-management.html',
                    controller: 'MobileMenuManagementController as ctrl',
                    resolve: load([
                        'mobile-menu-management.controller',
                        'query.controller',
                        'query.service',
                        'authentication.service',
                    ])
                })
                .state('techo.manage.mobileMenuConfig', {
                    url: '/mobile-menu-config/:id',
                    title: 'Mobile Menu Configuration',
                    templateUrl: 'app/manage/mobileMenuManagement/views/mobile-menu-config.html',
                    controller: 'MobileMenuConfigController as ctrl',
                    resolve: load([
                        'mobile-menu-config.controller',
                        'query.controller',
                        'query.service',
                        'authentication.service',
                        'dndLists',
                        'update-feature.modal.controller',
                    ])
                })
                .state('techo.manage.locationtype', {
                    url: '/locationtype',
                    title: 'Location Type',
                    templateUrl: 'app/manage/locationtype/views/location-type.html',
                    controller: 'LocationTypeController as locationTypeCtrl',
                    resolve: load([
                        'location-type.controller',
                        'query.service',
                        'location.service',
                    ])
                })
                .state('techo.manage.managelocationtype', {
                    url: '/managelocationtype/:id',
                    title: 'Manage Location Type',
                    templateUrl: 'app/manage/locationtype/views/manage-location-type.html',
                    controller: 'ManageLocationTypeController as manageLocationTypeCtrl',
                    resolve: load([
                        'manage-location-type.controller',
                        'query.service',
                        'location.service',
                    ])
                })
                // .state('techo.manage.uploaduser', {
                //     url: '/uploadUser',
                //     title: 'Upload User',
                //     templateUrl: 'app/manage/uploaduser/views/upload-user.html',
                //     controller: 'UploadUserController as ctrl',
                //     resolve: load([
                //         'upload-user.controller',
                //         'location.service',
                //         'upload-user.service',
                //         'roles.service',
                //         'authentication.service',
                //     ])
                // })
                .state('techo.manage.pushnotificationtype', {
                    url: '/push/type',
                    title: 'List of Push Notification Type',
                    templateUrl: 'app/admin/pushnotification/views/push-type.html',
                    controller: 'PushNotificationTypeController as ctrl',
                    resolve: load([
                        'push-type.controller',
                        'push-notification.service'
                    ])
                }).state('techo.manage.managepushnotificationtype', {
                    url: '/push/type/:id',
                    title: 'Manage Push Notification Type',
                    templateUrl: 'app/admin/pushnotification/views/manage-push-type.html',
                    controller: 'ManagePushNotificationTypeController as ctrl',
                    resolve: load([
                        'manage-push-type.controller',
                        'push-notification.service',
                        'document.service'
                    ])
                }).state('techo.manage.pushnotification', {
                    url: '/push',
                    title: 'List of Push Notification',
                    templateUrl: 'app/admin/pushnotification/views/push-notification.html',
                    controller: 'PushNotificationController as ctrl',
                    resolve: load([
                        'push-notification.controller',
                        'push-notification.service',
                        'paging.service'
                    ])
                }).state('techo.manage.managepushnotification', {
                    url: '/push/:id',
                    title: 'Manage Push Notification',
                    templateUrl: 'app/admin/pushnotification/views/manage-push-notification.html',
                    controller: 'ManagePushNotificationController as ctrl',
                    resolve: load([
                        'manage-push-notification.controller',
                        'push-notification.service',
                        'push-notification.constant'
                    ])
                })
                .state('techo.manage.smstype', {
                    url: '/sms-type-list',
                    title: 'SMS Type List',
                    templateUrl: 'app/manage/smstype/views/sms-type-list.html',
                    controller: 'SmsTypeListController as smsTypeListController',
                    resolve: load([
                        'sms-type-list.controller',
                        'sms-type.service'
                    ])
                })
                .state('techo.manage.smstypemanage', {
                    url: '/sms-type/:type',
                    title: 'Manage SMS Type',
                    templateUrl: 'app/manage/smstype/views/sms-type-manage.html',
                    controller: 'SmsTypeManageController as smsTypeManageController',
                    resolve: load([
                        'sms-type.controller',
                        'sms-type.service'
                    ])
                })


                // .state('techo.manage.utdashboard', {
                //     url: '/utdashboard',
                //     title: 'Demographics Dashboard',
                //     templateUrl: 'app/manage/utdashboard/views/ut-dashboard.html',
                //     controller: 'UTDashboardController as utCntrl',
                //     resolve: load([
                //         'ut-dashboard.controller',
                //         'authentication.service',
                //         'expected-target.service',
                //         'generalutil.service',
                //         'query.service'
                //     ])
                // })
                .state('techo.manage.lmsdashboardv2', {
                    url: '/lmsdashboardv2',
                    title: 'LMS Dashboard V2',
                    templateUrl: 'app/training/dashboard/views/lms-dashboard-v2-new.html',
                    controller: 'LMSDashboardControllerV2New as lms',
                    resolve: load([
                        'lms-dashboard-v2-new.controller',
                        'paging-for-query-builder.service',
                        'authentication.service',
                        'user.service',
                        'role.service',
                        'alasql'
                    ])
                })
                .state('techo.manage.deathDetails', {
                    url: '/deathdetails',
                    templateUrl: 'app/manage/deathdetails/views/death-details.html',
                    title: 'Death Details',
                    controller: 'DeathDetailsController as ctrl',
                    resolve: load([
                        'death-details.controller',
                        'alasql'
                    ])
                })

                // .state('techo.manage.severeanemia', {
                //     url: '/severeanemia/:id',
                //     title: 'Manage Severe Anemia',
                //     templateUrl: 'app/manage/severeanemia/views/manage-severe-anemia.html',
                //     controller: 'ManageSevereAnemiaController as manageSevereAnemiaCtrl',
                //     resolve: load([
                //         'manage-severe-anemia.controller',
                //         'ncd.service',
                //         'authentication.service',
                //         'manage-severe-anemia.service'
                //     ])
                // })
                .state('techo.manage.stockmanagement', {
                    url: '/stockManagement',
                    title: 'Medicine Stock Management',
                    templateUrl: 'app/manage/stockmanagement/views/stock.management.dashboard.html',
                    controller: 'StockManagementController as ctrl',
                    resolve: load([
                        'stock.management.dashboard.controller',
                        'stock.management.service',
                        'paging-for-query-builder.service'
                    ])
                }).state('techo.manage.monthlyreportingform', {
                    url: '/monthlyreportingform/:id',
                    title: 'Monthly Reporting Form',
                    templateUrl: 'app/manage/monthlyreportingform/views/monthly-reporting-form.html',
                    controller: 'MonthlyReportingForm as ctrl',
                    resolve: load([
                        'monthly-reporting-form.controller',
                        'monthly-reporting-form.associations'
                    ])
                }).state('techo.manage.monthlyreportingformsearch', {
                    url: '/monthlyreportingformsearch',
                    title: 'Monthly Reporting Form Search',
                    templateUrl: 'app/manage/monthlyreportingform/views/monthly-reporting-form-search.html',
                    controller: 'MonthlyReportingFormSearch as ctrl',
                    resolve: load([
                        'monthly-reporting-form-search.controller',
                        'user.service',
                        'paging.service'
                    ])
                }).state('techo.manage.monthlyfacilityreportingform', {
                    url: '/monthlyfacilityreportingform/:id',
                    title: 'Monthly Facility Report',
                    templateUrl: 'app/manage/monthlyfacilityreportingform/views/monthly-facility-reporting-form.html',
                    controller: 'MonthlyFacilityReportingForm as ctrl',
                    resolve: load([
                        'monthly-facility-reporting-form.controller',
                        'monthly-reporting-form.associations'
                    ])
                }).state('techo.manage.monthlyfacilityreportingformsearch', {
                    url: '/monthlyfacilityreportingformsearch',
                    title: 'Monthly Facility Report Search',
                    templateUrl: 'app/manage/monthlyfacilityreportingform/views/monthly-facility-reporting-search.html',
                    controller: 'MonthlyFacilityReportingFormSearch as ctrl',
                    resolve: load([
                        'monthly-facility-reporting-form-search.controller',
                        'user.service',
                        'paging.service',
                        'manualsync.service'
                    ])
                }).state('techo.manage.integrateddailyregister', {
                    url: '/integrated-daily-register/:id',
                    title: 'Integrated Daily Activities Register',
                    templateUrl: 'app/manage/integrateddailyactivityregister/views/integrated-daily-activity-register.html',
                    controller: 'DailyActivityRegister as ctrl',
                    resolve: load([
                        'integrated-daily-activity-register',
                        'form.associations'
                    ])
                }).state('techo.manage.integrateddailyregistersearch', {
                    url: '/integreated-daily-register-search',
                    title: 'Integrated Daily Activities Register Search',
                    templateUrl: 'app/manage/integrateddailyactivityregister/views/integrated-daily-activity-register-search.html',
                    controller: 'DailyActivityRegisterSearch as ctrl',
                    resolve: load([
                        'integrated-daily-activity-register-search',
                        'user.service',
                        'paging.service'
                    ])
                }).state('techo.manage.zonalcollationformsearch', {
                    url: '/zonal-collation-form',
                    title: 'Zonal Collation Form Search',
                    templateUrl: 'app/manage/zonalcollationform/views/zonal-collation-form-search.html',
                    controller: 'ZonalCollationFormSearch as ctrl',
                    resolve: load([
                        'zonal-collation-form-search',
                        'user.service',
                        'paging.service'
                    ])
                }).state('techo.manage.zonalcollationform', {
                    url: '/zonal-collation-form/:id',
                    title: 'Zonal Collation Form',
                    templateUrl: 'app/manage/zonalcollationform/views/zonal-collation-form.html',
                    controller: 'ZonalCollationForm as ctrl',
                    resolve: load([
                        'zonal-collation-form',
                        'form-associations-zcf'
                    ])
                }).state('techo.manage.bcgsurveyform', {
                    url: '/bcgsurveyform',
                    title: 'BCG Survey Form',
                    templateUrl: 'app/manage/bcgsurveyform/views/bcg-survey-form.html',
                    controller: 'BcgSurveyForm as ctrl',
                    resolve: load([
                        'bcg-survey.service',
                        'bcg-survey-form.controller',
                        'paging-for-query-builder.service',
                        'authentication.service',
                        'user.service',
                        'role.service',
                        'alasql',
                        'query.service',
                        'paging.service',
                    ])
                }).state('techo.manage.servicevisitedit', {
                    url: '/formService',
                    title: 'Service Visit Details',
                    templateUrl: 'app/manage/formservice/views/formList.html',
                    controller: 'FormListController as ctrl',
                    resolve: load([
                        'paging-for-query-builder.service',
                        'authentication.service',
                        'user.service',
                        'role.service',
                        'alasql',
                        'query.service',
                        'paging.service',
                        'formList.controller'
                    ])
                }).state('techo.manage.userdetails', {
                    url: '/formService/userDetails/:formName/:locationId/:fromDate/:toDate',
                    title: 'User Details',
                    templateUrl: 'app/manage/formservice/views/userDetails.html',
                    controller: 'UserDetailsController as ctrl',
                    resolve: load([
                        'paging-for-query-builder.service',
                        'authentication.service',
                        'user.service',
                        'role.service',
                        'alasql',
                        'query.service',
                        'paging.service',
                        'userDetails.controller',
                        'ngInfiniteScroll'
                    ])
                }).state('techo.manage.service.visit', {
                    url: '/bcgsurveyform/:memberId/:bcgId',
                    title: 'BCG Survey Fill Form',
                    templateUrl: 'app/manage/bcgsurveyform/views/bcg-survey-fill-form.html',
                    controller: 'BcgSurveyFillForm as bcgForm',
                    resolve: load([
                        'bcg-survey.service',
                        'bcg-survey-fill-form.controller',
                        'paging-for-query-builder.service',
                        'authentication.service',
                        'user.service',
                        'role.service',
                        'alasql',
                        'query.service',
                        'paging.service'
                    ])
                })

            function load(srcs, callback, fetchUser, fetchConstant) {
                let depObj = {
                    deps: ['$ocLazyLoad', '$q', '$http', '$templateCache',
                        function ($ocLazyLoad, $q, $http, $templateCache) {
                            let deferred = $q.defer();
                            let promise = false;
                            srcs = angular.isArray(srcs) ? srcs : srcs.split(/\s+/);
                            if (!promise) {
                                promise = deferred.promise;
                            }
                            angular.forEach(srcs, function (src) {
                                promise = promise.then(function () {
                                    if (LZ_CONFIG[src]) {
                                        let srcArray = [];
                                        let promiseArray = [];
                                        let srcArrayFromConstants = LZ_CONFIG[src];
                                        srcArrayFromConstants = angular.isArray(srcArrayFromConstants) ? _.flatten(srcArrayFromConstants) : [srcArrayFromConstants];
                                        angular.forEach(srcArrayFromConstants, function (srcString) {
                                            if (srcString.startsWith('$templateCache:')) {
                                                srcString = srcString.replace('$templateCache:', '');
                                                if (!$templateCache.get(srcString)) {
                                                    let templatePromise = $http.get(srcString).then(function (response) {
                                                        $templateCache.put(srcString, response.data);
                                                    });
                                                    promiseArray.push(templatePromise);
                                                }
                                            } else {
                                                srcArray.push(srcString);
                                            }
                                        });
                                        promiseArray.push($ocLazyLoad.load(srcArray));
                                        return $q.all(promiseArray);
                                    } else {
                                        return $ocLazyLoad.load(src);
                                    }
                                });
                            });
                            deferred.resolve();
                            return callback ? promise.then(function () {
                                return callback();
                            }) : promise;
                        }]
                };
                if (fetchUser != null && fetchUser) {
                    depObj.User = ['AuthenticateService', '$rootScope',
                        function (AuthenticateService, $rootScope) {
                            return AuthenticateService.getLoggedInUser().catch(function () {
                                $rootScope.logOut();
                            });
                        }];
                }
                return depObj;
            }
        }]);
    as.run(function ($rootScope) {
        $rootScope.getGender = function (gender) {
            let g;
            switch (gender) {
                case 'M':
                    g = 'Male';
                    break;
                case 'F':
                    g = 'Female'
                    break;
                case 'T':
                    g = 'Transgender'
                    break;
            }
            return g;
        }
    })
}());