(function () {
    function CovidTravellersScreening(Mask, AuthenticateService, APP_CONFIG, toaster) {
        var covidscreening = this;
        covidscreening.filesStack = [];
        covidscreening.uploadFile = {
            singleFile: true,
            testChunks: false,
            allowDuplicateUploads: false,
            chunkSize: 10 * 1024 * 1024,
            headers: {
                Authorization: 'Bearer ' + AuthenticateService.getToken()
            },
            uploadMethod: 'POST',
            permanentErrors: [404, 500, 501, 400]
        };

        covidscreening.upload = function ($file, $event, $flow) {
            covidscreening.responseMessage = {};
            if (($file.getExtension() === 'xls' || $file.getExtension() === 'xlsx')
                // && covidscreening.uploadFile.dateFormate
            ) {
                delete covidscreening.errorMessage;
                covidscreening.isError = false;

                covidscreening.isFormatError = false;
                $flow.opts.target = APP_CONFIG.apiPath + '/covid/uploadsheet?dateFormat=' + covidscreening.uploadFile.dateFormate;
            } else {
                covidscreening.isError = true;
                // if (!covidscreening.uploadFile.dateFormate) {
                //     toaster.pop('error', 'Please select Date format');
                // }
                // else {
                toaster.pop('error', 'Please select correct file to upload!');
                // }
                $flow.cancel();
                return false;
            }
        };

        covidscreening.uploadFn = function ($files, $event, $flow) {
            if (covidscreening.filesStack.includes($flow.files[0].uniqueIdentifier)) {
                toaster.pop('error', 'Duplicate files not allowed');
                $flow.cancel();
                Mask.hide();
            } else {
                covidscreening.filesStack.push($flow.files[0].uniqueIdentifier);
                Mask.show();
                covidscreening.flow = ($flow);
                if (!covidscreening.isFormatError) {
                    $flow.upload();
                    covidscreening.isUploading = true;
                } else {
                    $flow.cancel();
                    Mask.hide();
                }
                Mask.hide()
            }
        };

        covidscreening.getUploadResponse = function ($file, $message, $flow) {
            Mask.hide();
            if ($message !== null && ($message.length === 0 || $message !== '')) {
                covidscreening.error = false;
                covidscreening.operationDone = true;
            } else {
                covidscreening.error = true;
                covidscreening.operationDone = false;
            }
            covidscreening.isUploading = false;
        };

        covidscreening.uploadError = function ($file, $message, $flow) {
            toaster.pop('error', JSON.parse($message).message);
        }

    }
    angular.module('imtecho.controllers').controller('CovidTravellersScreening', CovidTravellersScreening);
})();
