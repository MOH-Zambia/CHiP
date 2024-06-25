(function () {
    function ConfigureQuestionController(Mask, GeneralUtil, QueryDAO, $stateParams, toaster, $state, $uibModal, AuthenticateService, APP_CONFIG, DocumentDAO, SohElementConfigurationDAO, $q, CourseService) {
        let ctrl = this;
        ctrl.questionSetObj = {};
        ctrl.refId = $stateParams.refId;
        ctrl.refType = $stateParams.refType;
        ctrl.allowedImageExtns = ['jpg', 'png', 'jpeg'];
        ctrl.allowedVideoExtns = ['mp4', 'avi', 'mpg', '3gp', 'mov'];
        ctrl.allowedAudioExtns = ['m4a', 'flac', 'mp3', 'wav', 'wma', 'aac'];
        ctrl.allowedPdfExtns = ['pdf'];
        ctrl.filePayload = {};
        ctrl.isFileUploading = {};
        ctrl.isFileRemoving = {};
        ctrl.isFileUploadProcessing = {};
        // MAX FILE SIZE IN BYTES (DECIMAL)
        ctrl.maxImageSize = 1000000; // 1MB
        ctrl.maxVideoSize = 50000000; // 50MB
        ctrl.maxPdfSize = 5000000; // 5MB
        ctrl.maxAudioSize = 10000000; // 10MB

        ctrl.fileUploadOptions = {
            singleFile: true,
            testChunks: false,
            allowDuplicateUploads: false,
            simultaneousUploads: 1,
            chunkSize: 10 * 1024 * 1024 * 1024,
            headers: {
                Authorization: 'Bearer ' + AuthenticateService.getToken()
            },
            uploadMethod: 'POST'
        };

        ctrl.onFileAdded = function ($file, $event, $flow, prefix, type) {
            ctrl.responseMessage = {};
            if (type === 'VIDEO') {
                if (!ctrl.allowedVideoExtns.includes($file.getExtension())) {
                    ctrl.filePayload[prefix].isError = true;
                    ctrl.filePayload[prefix].errorMessage = `Only video file types can be uploaded: ${ctrl.allowedVideoExtns.join(', ')}`;
                    $event.preventDefault();
                    return false;
                }
            } else if(type === 'PDF') {
                if (!ctrl.allowedPdfExtns.includes($file.getExtension())) {
                    ctrl.filePayload[prefix].isError = true;
                    ctrl.filePayload[prefix].errorMessage = `Only pdf file types can be uploaded: ${ctrl.allowedPdfExtns.join(', ')}`;
                    $event.preventDefault();
                    return false;
                }
            } else if (type === 'AUDIO') {
                if (!ctrl.allowedAudioExtns.includes($file.getExtension())) {
                    ctrl.filePayload[prefix].isError = true;
                    ctrl.filePayload[prefix].errorMessage = `Only audio file types can be uploaded: ${ctrl.allowedAudioExtns.join(', ')}`;
                    $event.preventDefault();
                    return false;
                }
            } else {
                if (!ctrl.allowedImageExtns.includes($file.getExtension())) {
                    ctrl.filePayload[prefix].isError = true;
                    ctrl.filePayload[prefix].errorMessage = `Only image file types can be uploaded: ${ctrl.allowedImageExtns.join(', ')}`;
                    $event.preventDefault();
                    return false;
                }
            }
            delete ctrl.filePayload[prefix].errorMessage;
            ctrl.filePayload[prefix].isError = false;
            ctrl.mediaType = type ? type : 'NONE';
            $flow.opts.target = `${APP_CONFIG.apiPath}/document/uploaddocument/TRAINING/false`;
        };

        ctrl.onFileSubmitted = function ($files, $event, $flow, prefix) {
            let sizeErr = false;
            switch (ctrl.mediaType) {
                case 'IMAGE':
                    if($files[0].size > ctrl.maxImageSize) {
                        ctrl.popSizeError(ctrl.maxImageSize);
                        $flow.cancel();
                        sizeErr = true;
                    }
                    break;
                case 'VIDEO':
                    if($files[0].size > ctrl.maxVideoSize) {
                        ctrl.popSizeError(ctrl.maxVideoSize);
                        $flow.cancel();
                        sizeErr = true;
                    }
                    break;
                case 'PDF':
                    if($files[0].size > ctrl.maxPdfSize) {
                        ctrl.popSizeError(ctrl.maxPdfSize);
                        $flow.cancel();
                        sizeErr = true;
                    }
                    break;
                case 'AUDIO':
                    if($files[0].size > ctrl.maxAudioSize) {
                        ctrl.popSizeError(ctrl.maxAudioSize);
                        $flow.cancel();
                        sizeErr = true;
                    } else {
                        ctrl.scenario.audio.isAudioWithControls = false;
                        ctrl.audioControls = "NO";
                    }
                    break;
            }
            if (!$files || $files.length === 0 || sizeErr) {
                return;
            }

            Mask.show();
            AuthenticateService.refreshAccessToken().then(function () {
                $flow.opts.headers.Authorization = 'Bearer ' + AuthenticateService.getToken();
                ctrl.filePayload[prefix].flow = ($flow);
                $flow.upload();
                if (!ctrl.filePayload[prefix].isError) {
                    ctrl.isFileUploading[prefix] = true;
                    $files.forEach(file => ctrl.isFileUploadProcessing[prefix][file.name] = true)
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        ctrl.popSizeError = (maxSize) => {
            toaster.pop('info', `${ctrl.mediaType} file size must be less than or equal to ${maxSize/1000000}MB`);
            return;
        }

        ctrl.onFileSuccess = function ($file, $message, $flow, dataObj, prefix) {
            ctrl.isFileUploading[prefix] = false;
            ctrl.isFileUploadProcessing[prefix][$file.name] = false;
            let fileDetails = {};
            try {
                fileDetails = JSON.parse($message);
            } catch (error) {
                console.log(error);
            }
            dataObj.mediaId = fileDetails.id;
            dataObj.mediaExtension = fileDetails.extension;
            dataObj.mediaName = fileDetails.actualFileName;
        };

        ctrl.onFileError = function ($file, $message, prefix) {
            ctrl.isFileUploading[prefix] = false;
            ctrl.isFileUploadProcessing[prefix][$file.name] = false;
            ctrl.filePayload[prefix].flow.files = ctrl.filePayload[prefix].flow.files.filter(e => e.name !== $file.name);
            toaster.pop('danger', 'Error in file upload!');
        };

        function _removeFile(dataObj, prefix, fileName) {
            if (ctrl.filePayload[prefix].flow && ctrl.filePayload[prefix].flow.files) {
                ctrl.filePayload[prefix].flow.files = ctrl.filePayload[prefix].flow.files
                    .filter(e => e.name !== fileName);
            }
            dataObj.mediaId = null;
            dataObj.mediaExtension = null;
            dataObj.mediaName = null;
            ctrl.isFileUploadProcessing[prefix] = {};
        }

        ctrl.onRemoveFile = function (dataObj, prefix, fileName) {
            if (dataObj.mediaId) {
                ctrl.isFileRemoving[prefix][fileName] = true;
                DocumentDAO.removeFile(dataObj.mediaId)
                    .then(function () {
                        _removeFile(dataObj, prefix, fileName);
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        ctrl.isFileRemoving[prefix][fileName] = false;
                    });
            } else {
                _removeFile(dataObj, prefix, fileName);
            }
        };

        ctrl.mediaTypeChanged = () => {
            ctrl.onRemoveFile(ctrl.scenario, 'scenario', ctrl.scenario.mediaName);
            if (ctrl.scenario.transcript && ctrl.scenario.transcript.mediaId) {
                ctrl.onRemoveFile(ctrl.scenario.transcript, 'scenariotranscript', ctrl.scenario.transcript.mediaName);
            } else if(ctrl.scenario.mediaType == 'VIDEO') {
                ctrl.scenario.transcript = {
                    mediaId: null,
                    mediaExtension: null,
                    mediaName:null
                }
                _initFileObjectsByKey('scenariotranscript');
            }
        }

        ctrl.uploadAudioChanged = function () {
            if (ctrl.scenario.audio.mediaId) {
                ctrl.onRemoveFile(ctrl.scenario.audio, 'scenarioAudio', ctrl.scenario.audio.mediaName);
            }
        }

        ctrl.audioControlChanged = function () {
            if (ctrl.audioControls == "YES") {
                ctrl.scenario.audio.isAudioWithControls = true;
            } else {
                ctrl.scenario.audio.isAudioWithControls = false;
            }
        }

        ctrl.init = () => {
            ctrl.retrieveQuestionSetById();
        }

        ctrl.retrieveQuestionSetById = function () {
            Mask.show();
            QueryDAO.execute({
                code: 'get_tr_question_set_configuration_by_id',
                parameters: {
                    id: parseInt($stateParams.id)
                }
            }).then((response) => {
                ctrl.questionSetObj = response.result[0];
                ctrl.getQuestionConfigurationById();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        const _initFileObjectsByKey = function (key) {
            ctrl.filePayload[key] = {};
            ctrl.isFileUploading[key] = false;
            ctrl.isFileRemoving[key] = {};
            ctrl.isFileUploadProcessing[key] = {};
        }

        const _deleteFileObjectsByKey = function (key) {
            delete ctrl.filePayload[key];
            delete ctrl.isFileUploading[key];
            delete ctrl.isFileRemoving[key];
            delete ctrl.isFileUploadProcessing[key];
        }

        const _deleteFileObjectsByStartsWithKey = function (startsWithKey) {
            for (const key in ctrl.filePayload) {
                if (key.startsWith(startsWithKey)) {
                    _deleteFileObjectsByKey(key);
                }
            }
        }

        ctrl.getQuestionConfigurationById = function () {
            const promises = [];
            promises.push(QueryDAO.execute({
                code: 'get_tr_question_bank_configuration_by_id',
                parameters: {
                    id: parseInt($stateParams.id)
                }
            }))
            promises.push(CourseService.getCourseById(ctrl.questionSetObj.courseId))
            $q.all(promises).then((responses) => {
                let questionConfiguration = responses[0].result.length > 0 && responses[0].result[0];
                try {
                    if (ctrl.questionSetObj.questionSetTypeName === 'Scenario Based Quiz') {
                        if (!ctrl.scenario) {
                            ctrl.scenario = {};
                            ctrl.filePayload = {};
                            ctrl.isFileUploading = {};
                            ctrl.isFileRemoving = {};
                            ctrl.isFileUploadProcessing = {};
                            _initFileObjectsByKey(`scenario`);
                            _initFileObjectsByKey(`scenarioAudio`);
                        }
                        ctrl.scenario = questionConfiguration && JSON.parse(questionConfiguration['config_json'])[0]
                            || {
                                scenarioTitle: null,
                                scenarioDescription: null,
                                scenarioQuestions: [],
                                audio: {}
                            };
                        if (ctrl.scenario.mediaType === 'VIDEO') {
                            _initFileObjectsByKey('scenariotranscript');
                        }
                        if (ctrl.scenario.audio) {
                            if (ctrl.scenario.audio.mediaId == null) {
                                ctrl.uploadAudio = "NO";
                            } else {
                                ctrl.uploadAudio = "YES";
                                if (ctrl.scenario.audio.isAudioWithControls) {
                                    ctrl.audioControls = "YES";
                                } else {
                                    ctrl.audioControls = "NO";
                                }
                            }
                        } else {
                            ctrl.scenario.audio = {};
                            ctrl.uploadAudio = "NO";
                        }
                        
                    } else {
                        ctrl.sections = questionConfiguration && JSON.parse(questionConfiguration['config_json']) || [];
                    }
                } catch (error) {
                    console.log(error);
                }
                if (ctrl.sections && ctrl.sections.length) {
                    ctrl.sections.forEach((sec, secIndex) => {
                        sec.questions.forEach((que, queIndex) => {
                            if (que.questionType === 'SINGLE_VALUE' || !que.questionType) {
                                que.questionType = 'SINGLE_SELECT';
                            }
                            if (!que.correctAnswerDescription) {
                                que.correctAnswerDescription = 'Yay! you got the correct answer.';
                            }
                            if (!que.incorrectAnswerDescription) {
                                que.incorrectAnswerDescription = 'Oops! you got the wrong answer.';
                            }
                            _initFileObjectsByKey(`sec${secIndex}que${queIndex}`);
                            switch (que.questionType) {
                                case 'SINGLE_SELECT':
                                case 'MULTI_SELECT':
                                    que.options.forEach((opt, optIndex) => _initFileObjectsByKey(`sec${secIndex}que${queIndex}opt${optIndex}`));
                                    break;
                                case 'MATCH_THE_FOLLOWING':
                                    que.lhs.forEach((lhsOpt, lhsOptIndex) => _initFileObjectsByKey(`sec${secIndex}que${queIndex}lhsOpt${lhsOptIndex}`));
                                    que.lhs.forEach((lhsOpt, rhsOptIndex) => _initFileObjectsByKey(`sec${secIndex}que${queIndex}rhsOpt${rhsOptIndex}`));
                                    break;
                                default:
                                    break;
                            }
                        })
                    })
                }
                if (ctrl.scenario && ctrl.scenario.scenarioQuestions.length) {
                    ctrl.scenario.scenarioQuestions.forEach((que, queIndex) => {
                        if (que.questionType === 'SINGLE_VALUE' || !que.questionType) {
                            que.questionType = 'SINGLE_SELECT';
                        }
                        if (!que.correctAnswerDescription) {
                            que.correctAnswerDescription = 'Yay! you got the correct answer.';
                        }
                        if (!que.incorrectAnswerDescription) {
                            que.incorrectAnswerDescription = 'Oops! you got the wrong answer.';
                        }
                        _initFileObjectsByKey(`scenarioque${queIndex}`);
                        switch (que.questionType) {
                            case 'SINGLE_SELECT':
                                que.options.forEach((opt, optIndex) => {
                                    _initFileObjectsByKey(`scenarioque${queIndex}opt${optIndex}`);
                                    _initFileObjectsByKey(`scenarioque${queIndex}opt${optIndex}feedback`);
                                });
                                break;
                            default:
                                break;
                        }
                    })
                }
                ctrl.selectedTestConfig = {};
                try {
                    let parsedTestConfig = responses[1].testConfigJson ? JSON.parse(responses[1].testConfigJson) : {};
                    ctrl.selectedTestConfig = parsedTestConfig[ctrl.questionSetObj.questionSetType];
                } catch (error) {
                    console.log('error while parsing JSON testConfig ::: ', error);
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.addSection = function () {
            if (!ctrl.sections) {
                ctrl.sections = [];
                ctrl.filePayload = {};
                ctrl.isFileUploading = {};
                ctrl.isFileRemoving = {};
                ctrl.isFileUploadProcessing = {};
            }
            ctrl.sections.push({
                sectionTitle: null,
                sectionDescription: null,
                questions: []
            });
        }

        ctrl.removeSection = function (sectionIndex) {
            ctrl.sections.splice(sectionIndex, 1);
            _deleteFileObjectsByStartsWithKey(`sec${sectionIndex}`);
        }

        ctrl.addQuestion = function (sectionIndex) {
            if (sectionIndex != null) {
                if (!ctrl.sections[sectionIndex].questions) {
                    ctrl.sections[sectionIndex].questions = [];
                }
                let questionIndex = ctrl.sections[sectionIndex].questions.push({
                    questionType: 'SINGLE_SELECT',
                    questionTitle: null,
                    correctAnswerDescription: 'Yay! you got the correct answer.',
                    incorrectAnswerDescription: 'Oops! you got the wrong answer.',
                    interactiveFeedbackContent: null,
                    options: [{
                        optionTitle: null,
                        optionValue: null,
                        isCorrect: false
                    }]
                }) - 1
                _initFileObjectsByKey(`sec${sectionIndex}que${questionIndex}`);
                _initFileObjectsByKey(`sec${sectionIndex}que${questionIndex}opt0`);
            } else {
                if (!ctrl.scenario.scenarioQuestions) {
                    ctrl.scenario.scenarioQuestions = [];
                }
                let questionIndex = ctrl.scenario.scenarioQuestions.push({
                    questionType: 'SINGLE_SELECT',
                    questionTitle: null,
                    correctAnswerDescription: 'Yay! you got the correct answer.',
                    incorrectAnswerDescription: 'Oops! you got the wrong answer.',
                    interactiveFeedbackContent: null,
                    options: [{
                        optionTitle: null,
                        optionValue: null,
                        optionFeedback: {feedbackValue: null},
                        isCorrect: false
                    }]
                }) - 1
                _initFileObjectsByKey(`scenarioque${questionIndex}`);
                _initFileObjectsByKey(`scenarioque${questionIndex}opt0`);
                _initFileObjectsByKey(`scenarioque${questionIndex}opt0feedback`);
            }
        }

        ctrl.removeQuestion = function (questionIndex, sectionIndex) {
            if (sectionIndex != null) {
                ctrl.sections[sectionIndex].questions.splice(questionIndex, 1);
                _deleteFileObjectsByStartsWithKey(`sec${sectionIndex}que${questionIndex}`);
            } else {
                ctrl.scenario.scenarioQuestions.splice(questionIndex, 1);
                _deleteFileObjectsByStartsWithKey(`scenarioque${questionIndex}`);
            }
        }

        ctrl.addOption = function (questionIndex, sectionIndex) {
            if (sectionIndex != null) {
                if (!ctrl.sections[sectionIndex].questions[questionIndex].options) {
                    ctrl.sections[sectionIndex].questions[questionIndex].options = [];
                }
                let optionIndex = ctrl.sections[sectionIndex].questions[questionIndex].options.push({
                    optionTitle: null,
                    optionValue: null,
                    isCorrect: false
                }) - 1;
                _initFileObjectsByKey(`sec${sectionIndex}que${questionIndex}opt${optionIndex}`);
            } else {
                if (!ctrl.scenario.scenarioQuestions[questionIndex].options) {
                    ctrl.scenario.scenarioQuestions[questionIndex].options = [];
                }
                let optionIndex = ctrl.scenario.scenarioQuestions[questionIndex].options.push({
                    optionTitle: null,
                    optionValue: null,
                    optionFeedback: {feedbackValue: null},
                    isCorrect: false
                }) - 1;
                _initFileObjectsByKey(`scenarioque${questionIndex}opt${optionIndex}`);
                _initFileObjectsByKey(`scenarioque${questionIndex}opt${optionIndex}feedback`);
            }
        }

        ctrl.removeOption = function (optionIndex, questionIndex, sectionIndex) {
            if (sectionIndex != null) {
                ctrl.sections[sectionIndex].questions[questionIndex].options.splice(optionIndex, 1);
                _deleteFileObjectsByKey(`sec${sectionIndex}que${questionIndex}opt${optionIndex}`);
            } else {
                ctrl.scenario.scenarioQuestions[questionIndex].options.splice(optionIndex, 1);
                _deleteFileObjectsByKey(`scenarioque${questionIndex}opt${optionIndex}`);
                _deleteFileObjectsByKey(`scenarioque${questionIndex}opt${optionIndex}feedback`);
            }
        }

        ctrl.addOptionPair = function (questionIndex, sectionIndex) {
            if (!ctrl.sections[sectionIndex].questions[questionIndex].lhs) {
                ctrl.sections[sectionIndex].questions[questionIndex].lhs = [];
                ctrl.sections[sectionIndex].questions[questionIndex].rhs = [];
            }
            let optionIndex = ctrl.sections[sectionIndex].questions[questionIndex].lhs.push({
                optionTitle: null,
                optionValue: null
            }) - 1;
            ctrl.sections[sectionIndex].questions[questionIndex].rhs.push({
                optionTitle: null,
                optionValue: null
            });
            _initFileObjectsByKey(`sec${sectionIndex}que${questionIndex}lhsOpt${optionIndex}`);
            _initFileObjectsByKey(`sec${sectionIndex}que${questionIndex}rhsOpt${optionIndex}`);
        }

        ctrl.removeOptionPair = function (lhsOptionIndex, questionIndex, sectionIndex) {
            ctrl.sections[sectionIndex].questions[questionIndex].lhs.splice(lhsOptionIndex, 1);
            ctrl.sections[sectionIndex].questions[questionIndex].rhs.splice(lhsOptionIndex, 1);
            _deleteFileObjectsByKey(`sec${sectionIndex}que${questionIndex}lhsOpt${lhsOptionIndex}`);
            _deleteFileObjectsByKey(`sec${sectionIndex}que${questionIndex}rhsOpt${lhsOptionIndex}`);
        }

        ctrl.onQuestionTypeChange = function (questionIndex, sectionIndex, questionType) {
            let question = ctrl.sections[sectionIndex].questions[questionIndex];
            let startsWithKey = `sec${sectionIndex}que${questionIndex}`;
            switch (questionType) {
                case 'SINGLE_SELECT':
                case 'MULTI_SELECT':
                    delete question.answers;
                    delete question.answerPairs;
                    delete question.lhs;
                    delete question.rhs;
                    if (!question.options || question.options.length === 0) {
                        question.options = [{
                            optionTitle: null,
                            optionValue: null,
                            isCorrect: false
                        }];
                        _deleteFileObjectsByStartsWithKey(startsWithKey);
                        _initFileObjectsByKey(`sec${sectionIndex}que${questionIndex}`);
                        _initFileObjectsByKey(`sec${sectionIndex}que${questionIndex}opt0`);
                    }
                    question.options.forEach(option => option.isCorrect = false);
                    break;
                case 'FILL_IN_THE_BLANKS':
                    delete question.options;
                    delete question.mediaId;
                    delete question.mediaExtension;
                    delete question.mediaName;
                    delete question.lhs;
                    delete question.rhs;
                    delete question.answerPairs;
                    question.answers = [];
                    _deleteFileObjectsByStartsWithKey(startsWithKey);
                    break;
                case 'MATCH_THE_FOLLOWING':
                    delete question.mediaId;
                    delete question.mediaId;
                    delete question.mediaExtension;
                    delete question.mediaName;
                    delete question.options;
                    delete question.answers;
                    question.lhs = [{
                        optionTitle: null,
                        optionValue: null
                    }];
                    question.rhs = [{
                        optionTitle: null,
                        optionValue: null
                    }];
                    question.answerPairs = {};
                    _deleteFileObjectsByStartsWithKey(startsWithKey);
                    _initFileObjectsByKey(`sec${sectionIndex}que${questionIndex}lhsOpt0`);
                    _initFileObjectsByKey(`sec${sectionIndex}que${questionIndex}rhsOpt0`);
                    break;
                default:
                    break;
            }
        }

        ctrl.onQuestionBlankAddition = function (questionIndex, sectionIndex) {
            let question = ctrl.sections[sectionIndex].questions[questionIndex];
            if (!question.answers)
                question.answers = [];
            if (!question.questionTitle)
                question.questionTitle = '';
            question.questionTitle += ' _____ ';
            let blankNumber = question.answers.length + 1;
            question.answers.push({
                blankNumber,
                blankValue: null
            });
        }

        ctrl.removeBlankAnswer = function (answerIndex, questionIndex, sectionIndex) {
            ctrl.sections[sectionIndex].questions[questionIndex].answers.splice(answerIndex, 1);
        }

        ctrl.moveLhsOption = function (lhsOptionIndex, questionIndex, sectionIndex, detla) {
            let lhsOptions = ctrl.sections[sectionIndex].questions[questionIndex].lhs;
            GeneralUtil.moveElementOfArrayByIndex(lhsOptions, lhsOptionIndex, detla);
        }

        ctrl.moveRhsOption = function (lhsOptionIndex, questionIndex, sectionIndex, detla) {
            let rhsOptions = ctrl.sections[sectionIndex].questions[questionIndex].rhs;
            GeneralUtil.moveElementOfArrayByIndex(rhsOptions, lhsOptionIndex, detla);
        }

        ctrl.moveRowOption = function (lhsOptionIndex, questionIndex, sectionIndex, detla) {
            ctrl.moveLhsOption(lhsOptionIndex, questionIndex, sectionIndex, detla);
            ctrl.moveRhsOption(lhsOptionIndex, questionIndex, sectionIndex, detla);
        }

        ctrl.action = function () {
            if (ctrl.questionSetObj.questionSetTypeName != 'Scenario Based Quiz') {
                ctrl.questionForm.$setSubmitted();
                ctrl.isValid = true;
                if (ctrl.questionForm.$invalid) {
                    ctrl.isValid = false;
                    return;
                }
                if (ctrl.sections.length === 0) {
                    toaster.pop('error', `Please configure sections`);
                    ctrl.isValid = false;
                    return;
                }
                ctrl.sections.forEach(section => {
                    if (!section.questions || section.questions.length === 0) {
                        toaster.pop('error', `Please add atleast one question in ${section.sectionTitle} section`);
                        ctrl.isValid = false;
                        return;
                    }
                    section.questions.forEach(question => {
                        switch (question.questionType) {
                            case 'SINGLE_SELECT':
                                if (question.options.length < 2) {
                                    toaster.pop('error', `Please add atleast two options in "${question.questionTitle}" question`);
                                    ctrl.isValid = false;
                                    return;
                                } else {
                                    let trueOptions = question.options.filter(option => option.isCorrect);
                                    if (trueOptions.length === 0) {
                                        toaster.pop('error', `Please select correct option in "${question.questionTitle}" question`);
                                        ctrl.isValid = false;
                                        return;
                                    }
                                }
                                break;
                            case 'MULTI_SELECT':
                                if (question.options.length < 2) {
                                    toaster.pop('error', `Please add atleast two options in "${question.questionTitle}" question`);
                                    ctrl.isValid = false;
                                    return;
                                } else {
                                    let trueOptions = question.options.filter(option => option.isCorrect);
                                    if (trueOptions.length < 2) {
                                        toaster.pop('error', `Please select at least two correct options in "${question.questionTitle}" question`);
                                        ctrl.isValid = false;
                                        return;
                                    }
                                }
                                break;
                            case 'FILL_IN_THE_BLANKS':
                                if (question.answers.length === 0) {
                                    toaster.pop('error', `Please add atleast one blank in "${question.questionTitle}" question`);
                                    ctrl.isValid = false;
                                    return;
                                } else {
                                    const regex = /(_____)/g;
                                    const blanks = question.questionTitle.match(regex);
                                    if (blanks.length !== question.answers.length) {
                                        toaster.pop('error', `Number of blanks and answers doesn't match in "${question.questionTitle}" question`);
                                        ctrl.isValid = false;
                                        return;
                                    }
                                }
                                break;
                            case 'MATCH_THE_FOLLOWING':
                                if (question.lhs.length < 3) {
                                    toaster.pop('error', `Please add atleast three pairs in "${question.questionTitle}" question`);
                                    ctrl.isValid = false;
                                    return;
                                }
                                break;
                            default:
                                break;
                        }

                    })
                })
                let allQuestions = [];
                ctrl.sections.map(section => section.questions).forEach(questionsArr => allQuestions = allQuestions.concat(questionsArr));
                ctrl.totalMarks = 0;
                allQuestions.forEach(que => {
                    switch (que.questionType) {
                        case 'SINGLE_SELECT':
                        case 'MULTI_SELECT':
                            ctrl.totalMarks += 1;
                            break;
                        case 'FILL_IN_THE_BLANKS':
                            ctrl.totalMarks += que.answers.length;
                            break;
                        case 'MATCH_THE_FOLLOWING':
                            ctrl.totalMarks += que.lhs.length;
                            break;
                        default:
                            break;
                    }
                })
                let maxId = Math.max.apply(Math, allQuestions.map(question => (question.id != undefined && question.id != null) ? question.id : -1));
                if (maxId < 0) {
                    maxId++;
                }
                ctrl.sections.forEach(section => {
                    section.questions.forEach(question => {
                        if (question.id == undefined || question.id == null) {
                            maxId++;
                            question.id = maxId;
                        }
                        switch (question.questionType) {
                            case 'SINGLE_SELECT':
                            case 'MULTI_SELECT':
                                question.options.forEach(option => option.optionValue = option.optionTitle);
                                break;
                            case 'MATCH_THE_FOLLOWING':
                                question.answerPairs = {};
                                question.lhs.forEach(lhsOption => lhsOption.optionValue = lhsOption.optionTitle);
                                question.rhs.forEach((rhsOption, rhsOptionIndex) => {
                                    rhsOption.optionValue = rhsOption.optionTitle
                                    question.answerPairs[question.lhs[rhsOptionIndex].optionValue] = rhsOption.optionValue;
                                });
                                break;
                            default:
                                break;
                        }
                    })
                })
                ctrl.duplicateSectionsArr = ctrl.checkIfAnyDuplicateSections();
                ctrl.duplicateQuesArr = ctrl.checkIfAnyDuplicateQues();
                ctrl.duplicateOptionsArr = ctrl.checkIfAnyDuplicateOptions();
                if (ctrl.duplicateSectionsArr.length || ctrl.duplicateQuesArr.length || ctrl.duplicateOptionsArr.length) {
                    toaster.pop('error', `Duplicate sections, questions and options are not allowed. Please reconfigure those.`);
                    ctrl.isValid = false;
                    return;
                }
            } else {
                ctrl.scenarioForm.$setSubmitted();
                ctrl.isValid = true;
                if (ctrl.scenarioForm.$invalid) {
                    ctrl.isValid = false;
                    return;
                }
                if (ctrl.scenario.scenarioQuestions.length === 0) {
                    toaster.pop('error', `Please add at least one question`);
                    ctrl.isValid = false;
                    return;
                }
                if (ctrl.uploadAudio == "YES" && ctrl.scenario.audio.mediaId == null) {
                    toaster.pop('error', 'Please upload audio');
                    ctrl.isValid = false;
                    return;
                }
                ctrl.scenario.scenarioQuestions.forEach(question => {
                    switch (question.questionType) {
                        case 'SINGLE_SELECT':
                            if (question.options.length < 2) {
                                toaster.pop('error', `Please add atleast two options in "${question.questionTitle}" question`);
                                ctrl.isValid = false;
                                return;
                            } else {
                                let trueOptions = question.options.filter(option => option.isCorrect);
                                if (trueOptions.length === 0) {
                                    toaster.pop('error', `Please select correct option in "${question.questionTitle}" question`);
                                    ctrl.isValid = false;
                                    return;
                                }
                            }
                            break;
                        default:
                            break;
                    }
                })

                let maxId = Math.max.apply(Math, ctrl.scenario.scenarioQuestions.map(question => (question.id != undefined && question.id != null) ? question.id : -1));
                if (maxId < 0) {
                    maxId++;
                }
                ctrl.totalMarks = 0;
                ctrl.scenario.scenarioQuestions.forEach(que => {
                    if (que.id == undefined || que.id == null) {
                        maxId++;
                        que.id = maxId;
                    }
                    switch (que.questionType) {
                        case 'SINGLE_SELECT':
                            que.options.forEach(option => option.optionValue = option.optionTitle);
                            ctrl.totalMarks += 1;
                            break;
                        default:
                            break;
                    }
                })
                ctrl.duplicateQuesArr = ctrl.checkIfAnyDuplicateQues();
                ctrl.duplicateOptionsArr = ctrl.checkIfAnyDuplicateOptions();
                if (ctrl.duplicateQuesArr.length || ctrl.duplicateOptionsArr.length) {
                    toaster.pop('error', `Duplicate questions and options are not allowed. Please reconfigure those.`);
                    ctrl.isValid = false;
                    return;
                }
            }

            if (ctrl.isValid) {
                if (ctrl.questionSetObj.minimumMarks && (ctrl.totalMarks < ctrl.questionSetObj.minimumMarks)) {
                    let modalInstance = $uibModal.open({
                        templateUrl: 'app/common/views/confirmation.modal.html',
                        controller: 'ConfirmModalController',
                        windowClass: 'cst-modal',
                        size: 'med',
                        resolve: {
                            message: () => {
                                return "You have added less number of questions than Minimum Marks. Are you sure you want to save question set with the lesser number of questions?";
                            }
                        }
                    });
                    modalInstance.result.then(() => {
                        ctrl.saveQuestionConfig(ctrl.totalMarks);
                    }, () => { });
                } else {
                    ctrl.saveQuestionConfig(ctrl.totalMarks);
                }
            }
        }

        ctrl.checkIfAnyDuplicateSections = function () {
            if (!ctrl.sections || ctrl.sections.length === 0) {
                return [];
            }
            let sectionTitleArr = ctrl.sections.map(section => section.sectionTitle);
            return ctrl.sections.map((section, sectionIdx) => sectionTitleArr.indexOf(section.sectionTitle) != sectionIdx ? `secIdx${sectionIdx}` : undefined).filter(x => x);
        }

        ctrl.checkIfAnyDuplicateQues = function () {
            if (ctrl.questionSetObj.questionSetTypeName != 'Scenario Based Quiz') {
                if (!ctrl.sections || ctrl.sections.length === 0) {
                    return [];
                }
                let queTitleDupArr = [];
                ctrl.sections.forEach((section, sectionIdx) => {
                    let queTitleArr = section.questions.map(que => que.questionTitle);
                    queTitleDupArr.push(...section.questions.flatMap((que, queIdx) => {
                        if (queTitleArr.indexOf(que.questionTitle) != queIdx) {
                            return [`secIdx${sectionIdx}`, `secIdx${sectionIdx}queId${que.id}`];
                        }
                        return undefined;
                    }).filter(x => x));
                })
                return queTitleDupArr;
            } else {
                if (!ctrl.scenario || ctrl.scenario.scenarioQuestions.length === 0) {
                    return [];
                }
                let queTitleDupArr = [];
                let queTitleArr = ctrl.scenario.scenarioQuestions.map(que => que.questionTitle);
                queTitleDupArr.push(...ctrl.scenario.scenarioQuestions.flatMap((que, queIdx) => {
                    if (queTitleArr.indexOf(que.questionTitle) != queIdx) {
                        return [`scenario`, `scenarioqueId${que.id}`];
                    }
                    return undefined;
                }).filter(x => x));
                return queTitleDupArr;
            }
        }

        ctrl.checkIfAnyDuplicateOptions = function () {
            if (ctrl.questionSetObj.questionSetTypeName != 'Scenario Based Quiz') {
                if (!ctrl.sections || ctrl.sections.length === 0) {
                    return [];
                }
                let optionTitleDupArr = [];
                ctrl.sections.forEach((section, sectionIdx) => {
                    optionTitleDupArr.push(...section.questions.flatMap((que, queIdx) => {
                        switch (que.questionType) {
                            case 'SINGLE_SELECT':
                            case 'MULTI_SELECT':
                                let optionTitleArr = que.options.map(opt => opt.optionTitle);
                                if (que.options.filter((opt, optIdx) => optionTitleArr.indexOf(opt.optionTitle) != optIdx).length) {
                                    return [`secIdx${sectionIdx}`, `secIdx${sectionIdx}queId${que.id}`];
                                }
                                return undefined;
                            case 'MATCH_THE_FOLLOWING':
                                let lhsOptionTitleArr = que.lhs.map(opt => opt.optionTitle);
                                let rhsOptionTitleArr = que.rhs.map(opt => opt.optionTitle);
                                if (que.lhs.filter((lhsOpt, lhsOptIdx) => lhsOptionTitleArr.indexOf(lhsOpt.optionTitle) != lhsOptIdx).length || que.rhs.filter((rhsOpt, rhsOptIdx) => rhsOptionTitleArr.indexOf(rhsOpt.optionTitle) != rhsOptIdx).length) {
                                    return [`secIdx${sectionIdx}`, `secIdx${sectionIdx}queId${que.id}`];
                                }
                                return undefined;
                            default:
                                return undefined;
                        }
                    }).filter(x => x));
                });
                return optionTitleDupArr;
            } else {
                if (!ctrl.scenario || ctrl.scenario.scenarioQuestions.length === 0) {
                    return [];
                }
                let optionTitleDupArr = [];
                optionTitleDupArr.push(...ctrl.scenario.scenarioQuestions.flatMap((que, queIdx) => {
                    switch (que.questionType) {
                        case 'SINGLE_SELECT':
                            let optionTitleArr = que.options.map(opt => opt.optionTitle);
                            if (que.options.filter((opt, optIdx) => optionTitleArr.indexOf(opt.optionTitle) != optIdx).length) {
                                return [`scenario`, `scenarioqueId${que.id}`];
                            }
                            return undefined;
                        default:
                            return undefined;
                    }
                }).filter(x => x));
                return optionTitleDupArr;
            }
        }

        ctrl.saveQuestionConfig = function (totalMarks) {
            let scenarios = [];
            if(ctrl.scenario){
                scenarios.push(ctrl.scenario);
            }
            let dtoList = [];
            dtoList.push({
                code: 'insert_into_tr_question_bank_configuration',
                parameters: {
                    questionSetId: parseInt($stateParams.id),
                    configJson: JSON.stringify(ctrl.questionSetObj.questionSetTypeName != 'Scenario Based Quiz'?ctrl.sections:scenarios)
                },
                sequence: 1
            })
            dtoList.push({
                code: 'update_total_marks_tr_question_set_configuration',
                parameters: {
                    id: parseInt($stateParams.id),
                    totalMarks
                },
                sequence: 2
            })
            Mask.show();
            QueryDAO.executeAll(dtoList).then(responses => {
                toaster.pop('success', `Question configured successfully`);
                $state.go('techo.training.questionsetlist', { refId: $stateParams.refId, refType: $stateParams.refType });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.setIsCorrectValue = function (optionIndex, questionIndex, sectionIndex) {
            if (sectionIndex != null) {
                let selectedQuestionOptions = ctrl.sections[sectionIndex].questions[questionIndex].options;
                selectedQuestionOptions.forEach((option, index) => {
                    if (index === optionIndex) {
                        option.isCorrect = true;
                    } else {
                        option.isCorrect = false;
                    }
                })
            } else {
                let selectedQuestionOptions = ctrl.scenario.scenarioQuestions[questionIndex].options;
                selectedQuestionOptions.forEach((option, index) => {
                    if (index === optionIndex) {
                        option.isCorrect = true;
                    } else {
                        option.isCorrect = false;
                    }
                })
            }
        }

        ctrl.viewImageModal = function (dataObj) {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/training/questionconfiguration/views/view-image.modal.html',
                controllerAs: 'viewImageModalCtrl',
                controller: function ($uibModalInstance) {
                    let viewImageModalCtrl = this;
                    viewImageModalCtrl.id = dataObj.mediaId;
                    viewImageModalCtrl.title = dataObj.mediaName;

                    const _init = function () {
                        Mask.show();
                        SohElementConfigurationDAO.getFileById(viewImageModalCtrl.id).then(res => {
                            viewImageModalCtrl.isFileUploaded = true;
                            viewImageModalCtrl.attachmentImage = URL.createObjectURL(res.data)
                        }).catch(err => {
                            if (err.status === 404) {
                                toaster.pop('error', "Image not found!");
                            } else {
                                GeneralUtil.showMessageOnApiCallFailure(error);
                            }
                            viewImageModalCtrl.attachmentImage = null;
                        }).finally(() => {
                            Mask.hide();
                        });
                    }

                    viewImageModalCtrl.ok = function () {
                        $uibModalInstance.dismiss('cancel');
                    }

                    _init();
                },
                windowClass: 'cst-modal',
                size: 'xl',
                resolve: {
                }
            });
            modalInstance.result.then(function () { }, function (err) { });
        }

        ctrl.preview = function (index) {
            console.log(ctrl.sections[index]);
            let modalInstance = $uibModal.open({
                templateUrl: 'app/training/courselist/views/quiz-preview.modal.html',
                controllerAs: 'quizPreviewModalCtrl',
                controller: function ($uibModalInstance) {
                    let quizPreviewModalCtrl = this;
                    quizPreviewModalCtrl.section = ctrl.sections[index];

                    const _init = function () {
                        quizPreviewModalCtrl.quesions=[];
                        quizPreviewModalCtrl.section.questions.forEach(question => {
                            if(question.mediaId)
                            {
                                //get file from server
                                SohElementConfigurationDAO.getFileById(question.mediaId).then(res => {
                                    question.attachmentImage = URL.createObjectURL(res.data)
                                }).catch(err => {
                                    question.attachmentImage = null;
                                })
                            }
                            if(question.questionType=="MULTI_SELECT" || question.questionType=="SINGLE_SELECT"){
                                question.options.forEach(option => {
                                    if(option.mediaId)
                                    {
                                        //get file from server
                                        SohElementConfigurationDAO.getFileById(option.mediaId).then(res => {
                                            option.attachmentImage = URL.createObjectURL(res.data)
                                        }).catch(err => {
                                            option.attachmentImage = null;
                                        })
                                    }
                                });
                            }
                            if(question.questionType=="MATCH_THE_FOLLOWING"){
                                question.rhs.forEach(option => {
                                    if(option.mediaId)
                                    {
                                        //get file from server
                                        SohElementConfigurationDAO.getFileById(option.mediaId).then(res => {
                                            option.attachmentImage = URL.createObjectURL(res.data)
                                        }).catch(err => {
                                            option.attachmentImage = null;
                                        })
                                    }
                                });
                                question.lhs.forEach(option => {
                                    if(option.mediaId)
                                    {
                                        //get file from server
                                        SohElementConfigurationDAO.getFileById(option.mediaId).then(res => {
                                            option.attachmentImage = URL.createObjectURL(res.data)
                                        }).catch(err => {
                                            option.attachmentImage = null;
                                        })
                                    }
                                });
                            }
                        });
                    }

                    quizPreviewModalCtrl.ok = function () {
                        $uibModalInstance.dismiss('cancel');
                    }

                    _init();
                },
                windowClass: 'cst-modal',
                size: 'l',
                resolve: {
                }
            });
            modalInstance.result.then(function () { }, function (err) { });
        }

        ctrl.init();

    }
    angular.module('imtecho.controllers').controller('ConfigureQuestionController', ConfigureQuestionController);
})();
