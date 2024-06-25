package com.argusoft.sewa.android.app.util;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static com.argusoft.sewa.android.app.datastructure.SharedStructureData.gpsEnabledForms;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import androidx.core.widget.NestedScrollView;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.constants.FhsConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.FormulaConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.databean.FormulaTagBean;
import com.argusoft.sewa.android.app.databean.MemberAdditionalInfoDataBean;
import com.argusoft.sewa.android.app.databean.OptionDataBean;
import com.argusoft.sewa.android.app.databean.OptionTagBean;
import com.argusoft.sewa.android.app.databean.ValidationTagBean;
import com.argusoft.sewa.android.app.datastructure.PageFormBean;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.dtos.HouseHoldLineListMobileDto;
import com.argusoft.sewa.android.app.mappers.HouseHoldLineListMobileMapper;
import com.argusoft.sewa.android.app.model.FamilyBean;
import com.argusoft.sewa.android.app.model.LoggerBean;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.model.StoreAnswerBean;
import com.argusoft.sewa.android.app.model.UploadFileDataBean;
import com.argusoft.sewa.android.app.morbidities.beans.BeneficiaryMorbidityDetails;
import com.argusoft.sewa.android.app.morbidities.beans.MorbidityAnswerStringBean;
import com.argusoft.sewa.android.app.morbidities.constants.MorbiditiesConstant;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.google.android.material.button.MaterialButton;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @author alpeshkyada
 */
public class DynamicUtils {

    private DynamicUtils() {
        throw new IllegalStateException("Utility Class");
    }

    public static final int HIDDEN_LAYOUT_ID = 2341;
    public static final int BUTTON_YES_NO = -151;
    public static final int BUTTON_OK = -105;
    public static final int BUTTON_HIDE_LOGOUT = -152;
    public static final int BUTTON_RETRY_CANCEL = -153;
    public static final int LOGIN_BUTTON_ALERT = -200;
    public static final int ID_BODY_SCROLL = R.id.bodyScroll; //15001 // for body scroll
    public static final int ID_BODY_LAYOUT = R.id.bodyLayoutContainer; //15002 // for body layout
    public static final int ID_NEXT_BUTTON = R.id.nextButton; //15003 // for next button
    public static final int ID_BACK_BUTTON = 15004; // for back button
    public static final int ID_FOOTER = R.id.footerLayout; //15005
    public static final int ID_OF_CUSTOM_DATE_PICKER = 2152;
    public static final String TAG = "DynamicUtils";

    /**
     * @param binding     questions's binding value
     * @param loopCounter current loop counter of question
     * @param ignore      flag to ignore loop count or not
     * @return question's binding value that is appends in answerString
     */
    public static String getBindingValue(String binding, int loopCounter, boolean ignore) {
        if (binding != null && binding.trim().length() > 0) {
            if (loopCounter != 0 && !ignore) {
                return binding.trim() + "." + loopCounter;
            } else {
                return binding.trim();
            }
        }
        return null;
    }

    /**
     * @param originalId  question id
     * @param loopCounter current loop counter
     * @return return new question of according loop counter
     */
    public static int getLoopId(int originalId, int loopCounter) {
        if (loopCounter > 0 && originalId > 0) {
            return originalId * GlobalTypes.LOOP_FACTOR + loopCounter;
        }
        return originalId;
    }

    public static int getLoopId(QueFormBean queFormBean) {
        if (queFormBean != null && queFormBean.getId() > 0) {
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                return queFormBean.getId() * GlobalTypes.LOOP_FACTOR + queFormBean.getLoopCounter();
            } else {
                return queFormBean.getId();
            }
        } else {
            return 0;
        }
    }

    /**
     * @param loopQuestionId Question Id for next Question
     * @param loopCounter    Loop Counter for current loop
     * @return return original question id according to loop counter
     */
    public static int getOriginalId(int loopQuestionId, int loopCounter) {
        if (loopCounter > 0 && loopQuestionId > 0) {
            return (loopQuestionId / GlobalTypes.LOOP_FACTOR);
        }
        return loopQuestionId;
    }

    /**
     * @param question Question
     * @return return all possible next question number of given question
     */
    public static List<Integer> getNextQuestionIdList(QueFormBean question) {
        List<Integer> nextList = new ArrayList<>();
        if (question.getNext() != null && question.getNext().trim().length() > 0) {
            nextList.add(getLoopId(Integer.parseInt(question.getNext()), question.getLoopCounter()));
        } else {
            List<OptionTagBean> options = question.getOptions();
            if (options != null && !options.isEmpty()) {
                for (OptionTagBean option : options) {
                    if (option.getNext() != null && option.getNext().trim().length() > 0) {
                        nextList.add(getLoopId(Integer.parseInt(option.getNext()), question.getLoopCounter()));
                    }
                }
            }
        }
        return nextList;
    }

    /**
     * @param question Question
     * @return return only one direct next of question
     */
    public static int getNext(QueFormBean question) {
        if (question.getNext() != null && question.getNext().trim().length() > 0) {
            return (getLoopId(Integer.parseInt(question.getNext()), question.getLoopCounter()));
        }
        return -1;
    }

    /**
     * @param next Next Page Question Id
     * @return the page structure on passing question number
     */
    public static PageFormBean getPageFromNext(int next) {
        QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(next);
        if (queFormBean != null) {
            return SharedStructureData.mapIndexPage.get(getLoopId(Integer.parseInt(queFormBean.getPage()), queFormBean.getLoopCounter()));
        }
        return null;
    }

    /**
     * @param queFormBean Question
     * @return question structure of next that travers from all intermediate
     * hidden question or may be intermediate page
     */
    public static QueFormBean setNextVisibleQuestionInSamePage(QueFormBean queFormBean) {
        if (queFormBean != null) {
            int queId = getLoopId(queFormBean.getId(), queFormBean.getLoopCounter());
            PageFormBean currentPage = getPageFromNext(queId);
            queId = getNext(queFormBean);
            while (currentPage != null && currentPage.getListOfQuestion() != null && currentPage.getListOfQuestion().contains(queId)) {
                queFormBean = SharedStructureData.mapIndexQuestion.get(queId);
                if (queFormBean != null) {
                    if (queFormBean.getIshidden().equalsIgnoreCase(GlobalTypes.TRUE)) {
                        applyFormulaForHiddenQuestion(queFormBean, false);
                        queId = getNext(queFormBean);
                    } else {
                        return queFormBean;
                    }
                } else {
                    break;
                }
            }
        }
        return null;
    }

    /**
     * @param question set given question to first question of page in that current question is
     *                 belongs
     */
    public static void setFirstQuestion(QueFormBean question) {
        if (question != null && question.getPage() != null && question.getPage().trim().length() > 0) {
            PageFormBean page = SharedStructureData.mapIndexPage.get(getLoopId(Integer.parseInt(question.getPage()), question.getLoopCounter()));
            if (page != null) {
                page.setFirstQuestionId(getLoopId(question.getId(), question.getLoopCounter()));
            }
        }
    }

    /**
     * @param answer      Answer
     * @param counter     Current Loop counter
     * @param validations Validation Tag Beans for current question
     * @return if is not valid then Validation Message will be returned else null will be returned
     */
    public static String checkValidation(String answer, int counter, List<ValidationTagBean> validations) {
        if (validations != null
                && !validations.isEmpty()) {
            for (ValidationTagBean validation : validations) {
                if (validation.getMethod() != null && validation.getMethod().trim().length() > 0) {
                    String[] split = UtilBean.split(validation.getMethod().trim(), GlobalTypes.KEY_VALUE_SEPARATOR);
                    String validationMessage = null;
                    if (split.length > 0 && split[0] != null) {
                        if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_DIABETES_CONFIRMATION)) {
                            validationMessage = ValidationFormulaUtil.validateDiabetesValue(split, answer, validation);
                        }
                    }
                    if (answer == null || answer.trim().length() == 0
                            || answer.trim().equalsIgnoreCase("null")
                            || answer.trim().equalsIgnoreCase(GlobalTypes.NO_WEIGHT)
                            || answer.trim().equalsIgnoreCase(GlobalTypes.FALSE)) {
                        continue;
                    }
                    if (split.length > 0 && split[0] != null) {
                        if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_ALPHABETIC_NUMERIC_WITH_SPACE)) {
                            //validation for alphanumeric with space
                            validationMessage = ValidationFormulaUtil.alphanumericWithSpace(answer, validation);
                        }
                        if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_NRC_NUMBER_FORMAT)) {
                            //validation for NRC Number
                            validationMessage = ValidationFormulaUtil.nrcNumberFormat(answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_PASSPORT_NUMBER_FORMAT)) { // if formula is 'is_future_date'
                            //isFutureDate-/-1  means validation - answerSeparation - indexOf realComparision of answer separation
                            validationMessage = ValidationFormulaUtil.passportNumberFormat(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_BIRTH_CERTIFICATE_FORMAT)) { // if formula is 'is_future_date'
                            //isFutureDate-/-1  means validation - answerSeparation - indexOf realComparision of answer separation
                            validationMessage = ValidationFormulaUtil.birthCertificateNumberFormat(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_IS_FUTURE_DATE)) { // if formula is 'is_future_date'
                            //isFutureDate-/-1  means validation - answerSeparation - indexOf realComparision of answer separation
                            validationMessage = ValidationFormulaUtil.isFutureDate(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_IS_PAST_DATE)) { // if formula is 'is_past_date'
                            //isPastDate-/-1  means validation - answerSeparation - indexOf realComparision of answer separation
                            validationMessage = ValidationFormulaUtil.isPastDate(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_IS_NOT_TODAY)) { // if formula is 'is_not_today'
                            //isNotToday-/-1  means validation - answerSeparation - indexOf realComparision of answer separation
                            validationMessage = ValidationFormulaUtil.isNotToday(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_IS_DATE_IN)) { // if formula is 'is_date_in'
                            //isDateIn-sub-2-0-2-/-1  means validation -operation-year-month-day- answerSeparation - indexOf realComparision of answer separation
                            validationMessage = ValidationFormulaUtil.isDateIn(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_IS_DATE_OUT)) { // if formula is 'is_date_out'
                            //isDateOut-sub-2-0-2-/-1  means validation -operation-year-month-day- answerSeparation - indexOf realComparision of answer separation
                            validationMessage = ValidationFormulaUtil.isDateOut(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_COMPARE_DATE_WITH_GIVEN_DATE)) {
                            validationMessage = ValidationFormulaUtil.comapreDateWithGivenDate(split, answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_COMPARE_DATE_WITH_GIVEN_DATE_AFTER)) {
                            validationMessage = ValidationFormulaUtil.comapreDateWithGivenDateAfter(split, answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CONTAINS_CHARACTER_PIPELINE)) {
                            // check if text contains character '|'
                            validationMessage = ValidationFormulaUtil.containsCharacterPipeline(answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_GREATER_THEN_0)) {
                            validationMessage = ValidationFormulaUtil.greaterThen0(answer, validation);
                            // added in phase 2
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_GREATER_THAN)) {
                            validationMessage = ValidationFormulaUtil.greaterThan(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_GREATER_THAN_EQUAL)) {
                            validationMessage = ValidationFormulaUtil.greaterThanEq(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_LESS_THAN)) {
                            validationMessage = ValidationFormulaUtil.lessThan(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_LESS_THAN_EQUAL)) {
                            validationMessage = ValidationFormulaUtil.lessThanEq(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_LESS_THAN_EQUAL_RELATED_PROPERTY)) {
                            validationMessage = ValidationFormulaUtil.lessThanEqRelatedProperty(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_GREATER_THAN_EQUAL_RELATED_PROPERTY)) {
                            validationMessage = ValidationFormulaUtil.greaterThanEqRelatedProperty(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_LESS_THAN_RELATED_PROPERTY)) {
                            validationMessage = ValidationFormulaUtil.lessThanRelatedProperty(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_GREATER_THAN_RELATED_PROPERTY)) {
                            validationMessage = ValidationFormulaUtil.greaterThanRelatedProperty(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_IN_BETWEEN_RANGE)) {
                            validationMessage = ValidationFormulaUtil.between(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_INPUT_LENGTH)) {
                            validationMessage = ValidationFormulaUtil.checkInputLength(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_MOBILE_NUMBER)) {
                            validationMessage = ValidationFormulaUtil.mobileNumber(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_MOBILE_NUMBER_ZAMBIA)) {
                            validationMessage = ValidationFormulaUtil.mobileNumberZambia(answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_AADHAAR_NUMBER)) {
                            validationMessage = ValidationFormulaUtil.aadhaarNumber(answer);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_INPUT_LENGTH_RANGE)) {
                            validationMessage = ValidationFormulaUtil.inputLengthRange(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_MAX_LENGTH)) {
                            validationMessage = ValidationFormulaUtil.maxLength(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_LENGTH)) {
                            validationMessage = ValidationFormulaUtil.length(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_ONLY_ONE_HEAD)) {
                            validationMessage = ValidationFormulaUtil.onlyOneHead(validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_HEAD_MEMBER_AGE)) {
                            validationMessage = ValidationFormulaUtil.checkHeadMemberAge(split, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_MARITAL_STATUS)) {
                            validationMessage = ValidationFormulaUtil.maritalStatusValidation(answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_HOF_RELATION_MARITAL_STATUS_WITH_EACH_OTHER)) {
                            validationMessage = ValidationFormulaUtil.checkHofRelationWithMaritalStatus(split, answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_VILLAGE_SELECTION)) {
                            validationMessage = ValidationFormulaUtil.villageSelectionCheck(answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_MOTHER_CHILD_COMPONENT)) {
                            validationMessage = ValidationFormulaUtil.motherChildComponentValidation(answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHILD_VACCINATION)) {
                            validationMessage = ValidationFormulaUtil.vaccinationValidationChild(answer);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_NUMBER_FORMAT)) {
                            validationMessage = ValidationFormulaUtil.checkNumberFormatException(answer);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_SINGLE_E_C_MEMBER_FAMILY)) {
                            validationMessage = ValidationFormulaUtil.checkSingleECMemberFamily();
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_2_DAYS_GAP_DELIVERY_DATE)) {
                            validationMessage = ValidationFormulaUtil.checkDaysGapDeliveryDate(split, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_SERVICE_DATE_FOR_HEALTH_INFRA)) {
                            validationMessage = ValidationFormulaUtil.checkServiceDateForHealthInfra(split, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_SERVICE_DATE_FOR_HOME_VISIT)) {
                            validationMessage = ValidationFormulaUtil.checkServiceDateForHomeVisit(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_INTEGER_ONLY_PLUS)) {
                            validationMessage = ValidationFormulaUtil.checkIntegerPlus(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_FAMILY_PLANNING_DATE)) {
                            validationMessage = ValidationFormulaUtil.familyPlanningDateValidation(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_COMPARE_DATE_BEFORE)) {
                            validationMessage = ValidationFormulaUtil.comapreDateBefore(split, answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_COMPARE_DATE_AFTER)) {
                            validationMessage = ValidationFormulaUtil.comapreDateAfter(split, answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_FOR_GIVEN_SACHETS)) {
                            validationMessage = ValidationFormulaUtil.checkGivenSachets(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_FOR_CONSUMED_SACHETS)) {
                            validationMessage = ValidationFormulaUtil.checkConsumedSachets(split, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_HOF_RELATION_OR_GENDER_WITH_EACH_OTHER)) {
                            validationMessage = ValidationFormulaUtil.checkHofRelationWithGender(split, answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_AGE_FOR_NOT_UNMARRIED)) {
                            validationMessage = ValidationFormulaUtil.checkAgeForNotUnmarried(answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_MEDICINE_DETAIL)) {
                            validationMessage = ValidationFormulaUtil.validateMedicineDetail(answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_WEDDING_DATE)) {
                            validationMessage = ValidationFormulaUtil.validateWeddingDate(split, answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_CHARDHAM_IS_PREGNANT_REL_WITH_GENDER)) {
                            validationMessage = ValidationFormulaUtil.checkChardhamIsPregnantWithGender(split, answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_AADHAR_CONSENT)) {
                            validationMessage = ValidationFormulaUtil.checkAadharConsent(split, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHILD_AGE_WITH_PARENT)) {
                            validationMessage = ValidationFormulaUtil.checkAgeOfChildIsNotGreaterThanParent(counter, answer, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_DATE)) {
                            validationMessage = ValidationFormulaUtil.checkDate(split, answer, counter, validation);
                        } else if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATE_DURATION)) {
                            validationMessage = ValidationFormulaUtil.validateDuration(split, answer, counter, validation);
                        }/* else if (split[0].equalsIgnoreCase(FormulaConstants.AVAILABLE_TABLETS)) {
                            validationMessage = ValidationFormulaUtil.checkAvailableTablets(split, answer, validation);
                        }*/

                        if (validationMessage != null) {
                            return validationMessage;
                        }
                    }// error in split
                }//no validation method
            }// no validation
        }
        return null;
    }

    /**
     * @param queFormBean current hidden question that is apply formula for
     *                    hidden question
     */
    public static void applyFormulaForHiddenQuestion(QueFormBean queFormBean, Boolean isFirstCall) {
        if (queFormBean == null) {
            return;
        }

        if (queFormBean.getFormulas() != null && !queFormBean.getFormulas().isEmpty()) {
            List<FormulaTagBean> formulaTags = queFormBean.getFormulas();
            for (FormulaTagBean formulaTag : formulaTags) {
                if (formulaTag.getFormulavalue() != null && formulaTag.getFormulavalue().trim().length() > 0) {
                    String[] split = UtilBean.split(formulaTag.getFormulavalue().trim(), GlobalTypes.KEY_VALUE_SEPARATOR);
                    switch (split[0].toLowerCase()) {
                        case FormulaConstants.FORMULA_CHECK_FOR_URINE_TEST:
                            if (split.length > 3) {
                                // if formula is 'urineTest' (for BP measurement)
                                HiddenQuestionFormulaUtil.urineTest(split, queFormBean);
                            }
                            break;
                        case FormulaConstants.FORMULA_CHECK_CONTAINS:
                            // if formula is 'checkcontains', check answer of property contains value given
                            HiddenQuestionFormulaUtil.checkContains(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_PNC_CHECK_TEMP:
                            // if formula is 'pncCheckTemp' (for temperature), it converts temperature in celsius (format : T or F-92-3)
                            HiddenQuestionFormulaUtil.pncCheckTemp(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_LESS_THAN:
                            // if formula is 'lessThan', check value is <= provided value
                            HiddenQuestionFormulaUtil.lessThan(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_GREATER_THAN:
                            // if formula is 'greaterThan', check value is <= provided value
                            HiddenQuestionFormulaUtil.greaterThan(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_LESS_THAN_FLOAT_VALUE:
                            // if formula is 'lessThanFloat', check value is <= provided value (accepts decimal values as well)
                            HiddenQuestionFormulaUtil.lessThanFloat(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_LENGTH:
                            // if formula is 'checkLength', check length of value is <= provided value
                            HiddenQuestionFormulaUtil.checkLength(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_REVERSE_FLAG:
                            HiddenQuestionFormulaUtil.setReverseFlag(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_COMPARE_DISEASE_COUNT:
                            // if formula is 'compareDiseaseCount'
                            HiddenQuestionFormulaUtil.compareDiseaseCount(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_LOOP:
                            // if formula is 'CheckLoop'
                            HiddenQuestionFormulaUtil.checkLoop(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_LOOP_BAK_COUNT:
                            HiddenQuestionFormulaUtil.checkLoopBakCount(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_COMPARE_DATE:
                            HiddenQuestionFormulaUtil.compareDate(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_TRUE:
                            //setTrue-isTT1Given-isTT2Condi-isTT2NGiven-weeknumber  leanth 5
                            //setTrue-isTT1Given-isTT2Condi-weeknumber   leanth 4
                            HiddenQuestionFormulaUtil.setTrue(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_MOBIDITY_LIST:
                            // added in phase 3 setmobiditylist-9996
                            HiddenQuestionFormulaUtil.setmobiditylist(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_ANSWER:
                            //for surveyor sheet(set related property for first 2 hidden question)
                            HiddenQuestionFormulaUtil.setAnswer(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CONTAINS:
                            //split-0 contains (for surveyor sheet)
                            HiddenQuestionFormulaUtil.contains(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_DATE_BETWEEN:
                            HiddenQuestionFormulaUtil.dateBetween(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_PROPERTY:
                            //for checking the mentioned property having any required value or not if there is no condition for value checking
                            HiddenQuestionFormulaUtil.checkProperty(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_DISPLAY_AGE:
                            //for checking the mentioned property having any required value or not if there is no condition for value checking
                            HiddenQuestionFormulaUtil.setAgePerDateSelected(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_STRING:
                            //For checking the required property having the mentioned string or not
                            HiddenQuestionFormulaUtil.checkString(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_WEIGHT:
                            HiddenQuestionFormulaUtil.checkWeight(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_MEMBERS_COUNT_CHECK:
                            HiddenQuestionFormulaUtil.membersCountCheck(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_LOOP_CONTAINS:
                            HiddenQuestionFormulaUtil.loopContains(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_BETWEEN:
                            HiddenQuestionFormulaUtil.checkBetween(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_LOOP_CHECK_AGE_BETWEEN:
                            HiddenQuestionFormulaUtil.loopCheckAgeBetween(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_DATE_BETWEEN:
                            //checkDateBetween-0-91-D-lmpDate-serviceDate
                            // this means if the diff between lmpDate and serviceDate is 91 days then it is true else false
                            HiddenQuestionFormulaUtil.checkDateBetween(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_TIME_GAP_IN_WK_DAYS:
                            HiddenQuestionFormulaUtil.checkGapBetweenDatesInWeeksAndDays(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_AREA_QUESTION_VISIBILITY:
                            HiddenQuestionFormulaUtil.setAreaQuestionVisibility(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_FAMILY_REVERIFICATION:
                            HiddenQuestionFormulaUtil.checkFamilyReverification(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_NULL:
                            HiddenQuestionFormulaUtil.isNull(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_PROPERTY_ADD_ALL_OPTION_IN_SUBCENTRE_LIST:
                            HiddenQuestionFormulaUtil.addAllOptionInSubcentreList(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_PROPERTY_CLEAR_SCANNED_AADHAR_DETAILS:
                            HiddenQuestionFormulaUtil.clearScannedAadharDetails(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_DATE_WITHIN:
                            HiddenQuestionFormulaUtil.isDateWithin(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_DATE_OUTSIDE:
                            // if formula is 'is_date_out'
                            HiddenQuestionFormulaUtil.isDateOutside(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_DATE_BETWEEN:
                            // used in wpd form
                            // IsDateBetween-lmpDate-D-168
                            HiddenQuestionFormulaUtil.isDateBetween(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_DATE_IN:
                            // if formula is 'is_date_in'
                            // isDateIn-sub-2-0-2-/-1  means validation -operation-year-month-day- answersepwration - indexof realcomparision of answer seperatopn
                            HiddenQuestionFormulaUtil.isDateIn(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_DATE_OUT:
                            // if formula is 'is_date_out'
                            HiddenQuestionFormulaUtil.isDateOut(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_PRETERM_BIRTH:
                            HiddenQuestionFormulaUtil.checkPretermBirth(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_UPDATE_CURRENT_GRAVIDA:
                            HiddenQuestionFormulaUtil.updateCurrentGravida(split);
                            break;
                        case FormulaConstants.FORMULA_IDENTIFY_HIGH_RISKS_ANC:
                            HiddenQuestionFormulaUtil.identifyHighRiskAnc(split);
                            break;
                        case FormulaConstants.FORMULA_SET_REFERRAL_REASON:
                            HiddenQuestionFormulaUtil.setReferralReason(split);
                            break;
                        case FormulaConstants.FORMULA_SET_CANCER_REFERRAL_REASON:
                            HiddenQuestionFormulaUtil.setCancerReferralReason(split);
                            break;
                        case FormulaConstants.FORMULA_IDENTIFY_HIGH_RISKS_PNC_CHILD:
                            HiddenQuestionFormulaUtil.identifyHighRiskPncChild(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IDENTIFY_HIGH_RISKS_PNC_MOTHER:
                            HiddenQuestionFormulaUtil.identifyHighRiskPncMother(split);
                            break;
                        case FormulaConstants.FORMULA_IDENTIFY_HIGH_RISKS_WPD_CHILD:
                            HiddenQuestionFormulaUtil.identifyHighRiskWpdChild(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_CONTAINS_LOOP:
                            HiddenQuestionFormulaUtil.checkContainsLoop(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_EQUALS_LOOP:
                            HiddenQuestionFormulaUtil.checkEqualsLoop(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_IF_LMP_AVAILABLE:
                            HiddenQuestionFormulaUtil.checkIfLmpIsAvailable(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_PUT_REMAINING_VACCINES:
                            HiddenQuestionFormulaUtil.putRemainingVaccines(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_IF_THIRD_TRIMESTER:
                            HiddenQuestionFormulaUtil.checkIfThirdTrimester(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_AGE_IF_WRONGLY_REGISTERED_AS_PREGNANT:
                            HiddenQuestionFormulaUtil.checkAgeIfWronglyRegistered(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_AGE_LESS_THAN_20:
                            HiddenQuestionFormulaUtil.checkAgeLessThan20(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_IF_ANY_CHILD_EXISIS:
                            HiddenQuestionFormulaUtil.checkIfAnyChildExisits(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_IF_ANY_FEMALE_MARRIED_MEMBER_EXISIS:
                            HiddenQuestionFormulaUtil.checkIfAnyFemaleMarriedMembersExists(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_FAMILY_STATE:
                            HiddenQuestionFormulaUtil.checkFamilyState(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_MEMBER_STATE:
                            HiddenQuestionFormulaUtil.checkMemberState(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_NEW_FAMILY:
                            HiddenQuestionFormulaUtil.checkNewFamily(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CONTACT_GYNECOLOGIST:
                            HiddenQuestionFormulaUtil.contactGynecologist();
                            break;
                        case FormulaConstants.FORMULA_ADD_MOTHER_LIST:
                            HiddenQuestionFormulaUtil.addMotherList(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_ADD_HUSBAND_LIST:
                            HiddenQuestionFormulaUtil.addHusbandList(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_MISOPROSTOL:
                            HiddenQuestionFormulaUtil.checkMisoprostol(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_RESET_PROPERTY:
                            HiddenQuestionFormulaUtil.resetProperty(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_CONTAINS_MULTIPLE:
                            // checkContainsMultiple-1-fadedVision-objVisibleMultipleTimes-visionTowardsBlackboardFaded-glareInVision-retinalMigraineIssues-difficultToDriveAtNight-powerKeepsChanging-redEyeWaterSecretion-currentlyTreated-visionLessThan618
                            HiddenQuestionFormulaUtil.checkContainsMultiple(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_CHIRANJEEVI_ELIGIBILITY:
                            HiddenQuestionFormulaUtil.checkChiranjeeviEligibility(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_ADD_ADDITIONAL_DISCHARGE_QUESTION:
                            HiddenQuestionFormulaUtil.addAdditionDischargeQuestion(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CALCULATE_SD_SCORE:
                            // calculateSDScore-height-weight-gender-SDScoreQuestionId
                            HiddenQuestionFormulaUtil.calculateSDScore(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_NUTRITION_CATEGORY:
                            // calculateSDScore-height-weight-gender-SDScoreQuestionId
                            HiddenQuestionFormulaUtil.setNutritionCategory(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SHOW_ALERT_IF_YES_IN_ANY:
                            // showAlertIfYesInAny-relatedPropertyName1-relatedPropertyName2-relatedPropertyName3
                            // It will take message from datamap of queFormBean
                            HiddenQuestionFormulaUtil.showAlertIfYesInAny(split, queFormBean, isFirstCall);
                            break;
                        case FormulaConstants.FORMULA_CHECK_IF_YES_IN_ANY:
                            HiddenQuestionFormulaUtil.checkIfYesInAny(split, queFormBean, isFirstCall);
                            break;
                        case FormulaConstants.FORMULA_SET_CHILD_GROWTH_CHART_DATA:
                            // setChildGrowthChartData-memberId-currentWeight-serviceDate
                            HiddenQuestionFormulaUtil.setChildGrowthChartData(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_FAMILY_HEAD_IDENTIFIED:
                            // setChildGrowthChartData-memberId-currentWeight-serviceDate
                            HiddenQuestionFormulaUtil.isFamilyHeadIdentified(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_GENDER_BASED_ON_RELATION_WITH_HOF:
                            // setChildGrowthChartData-memberId-currentWeight-serviceDate
                            HiddenQuestionFormulaUtil.setDefaultGenderBasedOnRelationWithHOF(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_GENDER_BY_RELATION_WITH_HOF:
                            HiddenQuestionFormulaUtil.setGenderBasedOnRelationWithHOF(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_FILTER_SELECTED_CHRONIC:
                            HiddenQuestionFormulaUtil.setOnlySelectedChronic(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_HOF_MOB_NUMBER_FOR_MINORS:
                            HiddenQuestionFormulaUtil.setHOFMobileNumberForMinors(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_USER_ONLINE:
                            HiddenQuestionFormulaUtil.isUserOnline(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_MOBILE_NUMBER_VERFICATION_BLOCKED:
                            HiddenQuestionFormulaUtil.isMobileNumberVerificationBlocked(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_MOBILE_NUMBER_VERFIED:
                            HiddenQuestionFormulaUtil.isMobileNumberVerfied(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_OTP_BASED_VERIFICATION_COMPONENT:
                            HiddenQuestionFormulaUtil.setOTPBasedVerificationComponent(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_CHECK_ANY_MEMBER_OTP_VERIFICATION_DONE:
                            HiddenQuestionFormulaUtil.checkAnyMemberOtpVerificationDone(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_APPETITE_TEST_ELIGIBILITY_CHECK:
                            HiddenQuestionFormulaUtil.appetiteTestEligibilityCheck(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IS_CMAM_FOLLOWUPS_PROBLEM:
                            HiddenQuestionFormulaUtil.isCMAMFollowupsProblem(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CALCULATE_TO_BE_GIVEN_SACHETS:
                            // currentWeight-questionId
                            HiddenQuestionFormulaUtil.calculateRUTFSachets(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_SCHOOL_TYPE:
                            HiddenQuestionFormulaUtil.setSchoolType(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_CONTAINS_ANY_LOOP:
                            // CheckContainsAnyLoop-LBIRTH-pregnancyOutcome
                            HiddenQuestionFormulaUtil.checkContainsAnyLoop(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_IS_ANY_VACCINE_GIVEN:
                            HiddenQuestionFormulaUtil.isAnyVaccineGiven(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_TO_CHECK_BP:
                            HiddenQuestionFormulaUtil.checkBpValue(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_IF_CONTAIN_OTHER:
                            HiddenQuestionFormulaUtil.checkIfContainOther(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_MEDICINE_COUNT_CHECK:
                            HiddenQuestionFormulaUtil.memberMedicineCountCheck(queFormBean);
                            break;
                        case FormulaConstants.FORMULA_IDENTIFY_HIGH_RISKS_CHARDHAM_TOURIST:
                            HiddenQuestionFormulaUtil.identifyHighRiskChardhamTourist(split);
                            break;
                        case FormulaConstants.FORMULA_IDENTIFY_HIGH_RISKS_ADOLESCENT:
                            HiddenQuestionFormulaUtil.identifyHighRiskAdolescent(split);
                            break;
                        case FormulaConstants.FORMULA_DISPLAY_HIGH_RISK_DATA:
                            HiddenQuestionFormulaUtil.displayHighRiskData(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SET_ANEMIA_STATUS:
                            HiddenQuestionFormulaUtil.setAnemiaStatus(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_SHOW_ANEMIA_SUGGESTION:
                            HiddenQuestionFormulaUtil.showAnemiaSuggestion(split, queFormBean);
                            break;
                        case FormulaConstants.FORMULA_CHECK_IF_SECOND_TRIMESTER:
                            HiddenQuestionFormulaUtil.checkIfSecondTrimester(queFormBean);
                            break;
                        default:
                            Log.i(TAG, "Formula for Hidden Question Not Handled : " + formulaTag.getFormulavalue());
                            break;
                    }
                } else {
                    Log.i(TAG, "Formula Value is NULL for Hidden Question : " + queFormBean.getId());
                }
            }
        } else {
            List<OptionDataBean> optionDataBeans = UtilBean.getOptionsOrDataMap(queFormBean, false);
            if (queFormBean.getRelatedpropertyname() == null || queFormBean.getRelatedpropertyname().trim().length() == 0) {
                queFormBean.setRelatedpropertyname(optionDataBeans.get(0).getRelatedProperty());
            }

            String relatedPropertyName = queFormBean.getRelatedpropertyname().trim();
            String relatedPropertyValue;
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            relatedPropertyValue = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);
            if (relatedPropertyValue == null || relatedPropertyValue.length() == 0 || relatedPropertyValue.equalsIgnoreCase("null")) {
                relatedPropertyValue = SharedStructureData.relatedPropertyHashTable.get(queFormBean.getRelatedpropertyname().trim());
            }
            OptionDataBean defaultValue = new OptionDataBean();
            if (relatedPropertyValue != null && relatedPropertyValue.length() > 0 && !relatedPropertyValue.equalsIgnoreCase("null")) {
                defaultValue.setKey(relatedPropertyValue);
                int defaultIndex = optionDataBeans.indexOf(defaultValue);
                if (defaultIndex == -1) // key is not Matched
                {
                    defaultValue.setKey(relatedPropertyValue.charAt(0) + "");
                    defaultIndex = optionDataBeans.indexOf(defaultValue);
                }
                if (defaultIndex != -1) {
                    defaultValue = optionDataBeans.get(defaultIndex);
                    String[] split = UtilBean.split(relatedPropertyValue, GlobalTypes.KEY_VALUE_SEPARATOR);
                    if (split.length == 2) {
                        try {
                            SharedStructureData.newBindingForMorbidity = Integer.parseInt(split[1]);
                            queFormBean.setIgnoreNextQueLoop(false);
                        } catch (Exception e) {
                            SharedStructureData.newBindingForMorbidity = 0;
                        }
                    }
                    if (defaultValue.getNext() != null) {
                        queFormBean.setNext(defaultValue.getNext());
                        Log.i(TAG, "Listener Called from formula question : " + getLoopId(queFormBean.getId(), queFormBean.getLoopCounter())
                                + " next is set to :" + getLoopId(Integer.parseInt(queFormBean.getNext() == null ? "-1" : queFormBean.getNext()), queFormBean.getLoopCounter()));
                    } else {
                        Log.i(TAG, "Selected option has no next");
                    }
                } else {
                    Log.i(TAG, "No match Key found");
                }
            } else {
                Log.i(TAG, "No property in relatedProperty table");
            }
        }
    }

    /**
     * @param queFormBean current question
     * @param isValid     question is valid or not that is apply all required
     *                    formula for question
     */
    public static void applyFormula(QueFormBean queFormBean, boolean isValid) {
        if (queFormBean != null && queFormBean.getFormulas() != null && !queFormBean.getFormulas().isEmpty()) {
            List<FormulaTagBean> formulaTags = queFormBean.getFormulas();
            for (FormulaTagBean formulaTag : formulaTags) {
                if (formulaTag.getFormulavalue() != null && formulaTag.getFormulavalue().trim().length() > 0) {
                    String[] split = UtilBean.split(formulaTag.getFormulavalue().trim(), GlobalTypes.KEY_VALUE_SEPARATOR);
                    if (split.length > 0 && split[0] != null) {
                        switch (split[0].toLowerCase()) {
                            case FormulaConstants.FORMULA_ADD_PERIOD:
                                FormulaUtil.addPeriod(split, queFormBean, isValid);
                                break;

                            case FormulaConstants.FORMULA_SET_ANSWER:
                                FormulaUtil.setAnswer(queFormBean);
                                break;

                            case FormulaConstants.FORMULA_CALCULATE_OUT_COME_DATE:
                                FormulaUtil.calculateOutComeDate(queFormBean, isValid);
                                break;

                            case FormulaConstants.FORMULA_SET_SUBTITLE_COLOR:
                                FormulaUtil.setSubtitleColor(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_COLOR:
                                FormulaUtil.setColor(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_DATE_SET:
                                FormulaUtil.setDateSet(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_HINT:
                                FormulaUtil.setHint(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_VALUE_AS_PROPERTY:
                                FormulaUtil.setValueAsProperty(queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_PROPERTY:
                                FormulaUtil.setProperty(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_DEFAULT_PROPERTY:
                                FormulaUtil.setDefaultProperty(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_GET_TIME:
                                //for displaying interview end date n time in survey sheet
                                FormulaUtil.getTime(split);
                                break;

                            case FormulaConstants.FORMULA_FILL_LOCATION:
                                FormulaUtil.fillLocation(split, queFormBean);
                                break;
                            case FormulaConstants.GENERATE_MEMBER_UUID:
                                FormulaUtil.generateMemberUUID(queFormBean);
                                break;
                            case FormulaConstants.GENERATE_MEMBER_UUID_WPD:
                                FormulaUtil.generateMemberUUIDWpd(queFormBean);
                                break;

                            case FormulaConstants.FORMULA_DISPLAY_AGE:
                                FormulaUtil.displayAge(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_PROPERTY_FROM_SCANNED_AADHAR:
                                FormulaUtil.setPropertyFromScannedAadhar(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_PROPERTY_AANGANWADI_ID_FROM_PHC_ID:
                                FormulaUtil.setAanganwadiIdFromPhcId(queFormBean);
                                break;

                            case FormulaConstants.FORMULA_DISPLAY_EARLY_REGISTRATION:
                                FormulaUtil.displayEarlyRegistration(split, queFormBean, isValid);
                                break;

                            case FormulaConstants.FORMULA_RESET_LOOP_PARAMS:
                                FormulaUtil.resetLoopParams();
                                break;

                            case FormulaConstants.FORMULA_UPDATE_LOOP_COUNT:
                                FormulaUtil.updateLoopCount(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_PROPERTY_CLEAR_SCANNED_AADHAR_DETAILS:
                                FormulaUtil.clearScannedAadharDetails(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_IMMUNISATION_WPD:
                                FormulaUtil.setImmunisationWpd(queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_PRE_FILLED_AS_PER_RELATION_WITH_HOF:
                                FormulaUtil.setPreFilledAsPerRelationWithHOF(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_DIABETES_STATUS:
                                FormulaUtil.setDiabetesStatus(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_DNHDD_DIABETES_STATUS:
                                FormulaUtil.setDnhddDiabetesStatus(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_HYPERTENSION_STATUS:
                                FormulaUtil.setHypertensionStatus(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_DNHDD_HYPERTENSION_STATUS:
                                FormulaUtil.setDnhddHypertensionStatus(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_MENTAL_HEALTH_STATUS:
                                FormulaUtil.setMentalHealthStatus(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_CALCULATE_MENTAL_HEALTH_STATUS:
                                FormulaUtil.calculateMentalHealthStatus(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_MEDICINE_ID:
                                FormulaUtil.setMedicineId(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_SET_DEFAULT_PROPERTY_LOOP:
                                FormulaUtil.setDefaultPropertyLoop(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_IDENTIFY_HIGH_RISK:
                                FormulaUtil.identifyHighRisk(split, queFormBean);
                                break;

                            case FormulaConstants.FORMULA_CHECK_MEMBER_SURVEY_ELIGIBILITY:
                                FormulaUtil.checkMemberEligibility(split, queFormBean);
                                break;

                            default:
                                Log.i(TAG, "Formula Not Handled : " + formulaTag.getFormulavalue());
                                break;
                        }
                    }
                } else {
                    Log.i(TAG, "Formula value is null for question : " + queFormBean.getId());
                }
            }
        }
    }

    public static String checkForMorbidity(String question, String answer, String dataMap,
                                           String forWhomMorbidity, String forWhichCondition, String rbAnswerExceptTF) {
        if (dataMap != null && dataMap.trim().length() > 0 && !dataMap.trim().equalsIgnoreCase("null")) {
            String[] splitDataMap = UtilBean.split(dataMap, GlobalTypes.COMMA);
            if (splitDataMap.length > 0) {
                for (String splitData : splitDataMap) {
                    if (splitData != null && splitData.toLowerCase().contains(GlobalTypes.DATA_MAP_MORBIDITY_CONDITION.toLowerCase())) {
                        String[] morbidityCondition = UtilBean.split(splitData, GlobalTypes.DATE_STRING_SEPARATOR);
                        boolean isAnswerNotNull = answer != null && answer.trim().length() > 0 && !answer.trim().equalsIgnoreCase("null");
                        if (morbidityCondition.length == 3) {
                            if (isAnswerNotNull) {
                                // it true matches
                                String[] trueOption = UtilBean.split(morbidityCondition[1], GlobalTypes.KEY_VALUE_SEPARATOR);
                                if (trueOption.length == 3 && answer.trim().equalsIgnoreCase(trueOption[0])) {
                                    if (rbAnswerExceptTF != null) {
                                        SharedStructureData.addItemInLICList(question, rbAnswerExceptTF, forWhomMorbidity);
                                    } else {
                                        SharedStructureData.addItemInLICList(question, GlobalTypes.YES, forWhomMorbidity);
                                    }
                                    return trueOption[1];
                                }
                                // it false matches
                                trueOption = UtilBean.split(morbidityCondition[2], GlobalTypes.KEY_VALUE_SEPARATOR);
                                if (trueOption.length == 3 && answer.trim().equalsIgnoreCase(trueOption[0])) {
                                    SharedStructureData.removeItemFromLICList(question, forWhomMorbidity);
                                    return trueOption[1];
                                }

                            } else {
                                String[] trueOption = UtilBean.split(morbidityCondition[2], GlobalTypes.KEY_VALUE_SEPARATOR);
                                if (trueOption.length == 3) {
                                    SharedStructureData.removeItemFromLICList(question, forWhomMorbidity);
                                    return trueOption[1];
                                }
                            }
                        } else if (morbidityCondition.length == 4) {
                            if (isAnswerNotNull) {
                                // it true matches
                                String[] conditions = UtilBean.split(morbidityCondition[1], "%");
                                String result = checkCondition(answer, conditions, forWhichCondition);

                                String[] trueOption = UtilBean.split(morbidityCondition[2], GlobalTypes.KEY_VALUE_SEPARATOR);
                                if (trueOption.length == 3 && result.trim().equalsIgnoreCase(trueOption[0])) {
                                    if (rbAnswerExceptTF != null) {
                                        SharedStructureData.addItemInLICList(question, rbAnswerExceptTF, forWhomMorbidity);
                                    } else {
                                        SharedStructureData.addItemInLICList(question, answer, forWhomMorbidity);
                                    }
                                    return trueOption[1];
                                }
                                // it false matches
                                trueOption = UtilBean.split(morbidityCondition[3], GlobalTypes.KEY_VALUE_SEPARATOR);
                                if (trueOption.length == 3 && result.trim().equalsIgnoreCase(trueOption[0])) {
                                    SharedStructureData.removeItemFromLICList(question, forWhomMorbidity);
                                    return trueOption[1];
                                }

                            } else {
                                String[] trueOption = UtilBean.split(morbidityCondition[3], GlobalTypes.KEY_VALUE_SEPARATOR);
                                if (trueOption.length == 3) {
                                    SharedStructureData.removeItemFromLICList(question, forWhomMorbidity);
                                    return trueOption[1];
                                }
                            }

                        }
                    }
                }
            }

        }
        return GlobalTypes.FALSE;
    }


    /**
     * @param pageStartPageNo Form start page number
     * @param formType        name of current filled form
     * @return String with required format
     */
    public static String generateAnswerString(int pageStartPageNo, String formType, Context context) {
        SharedStructureData.finalFilesToUpload.clear();
        PageFormBean currentPage = SharedStructureData.mapIndexPage.get(pageStartPageNo);
        StringBuilder answerString = new StringBuilder();
        if (currentPage != null) {
            currentPage.setPrePage(null);
            do { // page loop
                int firstQuestionId = currentPage.getFirstQuestionId();
                List<Integer> listOfQuestion = currentPage.getListOfQuestion();
                if (listOfQuestion != null && !listOfQuestion.isEmpty()) {
                    while (listOfQuestion.contains(firstQuestionId)) {
                        QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(firstQuestionId);
                        if (queFormBean != null) {
                            if (queFormBean.getIshidden().equalsIgnoreCase(GlobalTypes.FALSE) && queFormBean.getAnswer() != null && queFormBean.getAnswer().toString().trim().length() > 0) {
                                int loopCounter = queFormBean.getLoopCounter();
                                if (queFormBean.getExtraBinding() > 0) {
                                    loopCounter = queFormBean.getExtraBinding();
                                }
                                if (queFormBean.getType().equalsIgnoreCase(GlobalTypes.WEIGHT_BOX)) {
                                    if (!queFormBean.getAnswer().toString().trim().equalsIgnoreCase(GlobalTypes.NO_WEIGHT)) {
                                        answerString.append(getBindingValue(queFormBean.getBinding(), loopCounter, queFormBean.isIgnoreLoop())).append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR).append(queFormBean.getAnswer().toString().trim()).append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
                                    }
                                } else {
                                    answerString.append(getBindingValue(queFormBean.getBinding(), loopCounter, queFormBean.isIgnoreLoop())).append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR).append(queFormBean.getAnswer().toString().trim()).append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
                                }
                                if (queFormBean.getType().equalsIgnoreCase(GlobalTypes.PHOTO_PICKER)) {
                                    SharedStructureData.finalFilesToUpload.add(queFormBean);
                                }
                            }
                            firstQuestionId = getNext(queFormBean);
                        } else {
                            firstQuestionId = -1;
                        }
                    }
                }
                if (currentPage.getNextPage() != null) {
                    currentPage = currentPage.getNextPage();
                } else {
                    break;
                }
            } while (true);
        }

        if (gpsEnabledForms.contains(formType)) {
            String currentLatitude = SharedStructureData.relatedPropertyHashTable.get("currentLatitude");
            String currentLongitude = SharedStructureData.relatedPropertyHashTable.get("currentLongitude");

            answerString.append("-1").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR).append(currentLongitude).append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-2").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR).append(currentLatitude).append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }

        if ((FormConstants.SURVEILLANCE_PREG_REG.equals(formType) || FormConstants.SURVEILLANCE_PREG_OUTCOME.equals(formType)
                || FormConstants.SURVEILLANCE_CHILD_DEATH.equals(formType))
                || FormConstants.HU_MEDICAL_ASSESSMENT.equals(formType) || FormConstants.HU_FOLLOW_UP.equals(formType)
                || FormConstants.HU_PREG_OUTCOME.equals(formType)) {
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if ((FormConstants.CHIP_GBV_SCREENING.equals(formType))) {
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }

        if ((FormConstants.FAMILY_HEALTH_SURVEY.equals(formType) || FormConstants.CFHC.equals(formType)
                || FormConstants.IDSP_NEW_FAMILY.equals(formType) || FormConstants.CAM_FHS.equals(formType)
                || FormConstants.SURVEILLANCE_ADD_FAMILY.equals(formType))
                && LabelConstants.NOT_AVAILABLE.equals(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ID))) {
            answerString.append("-3").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.AREA_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }

        if (FormConstants.FAMILY_FOLDER.equals(formType) || FormConstants.SICKLE_CELL_ADD_FAMILY.equals(formType)) {
            answerString.append("-3").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.AREA_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-10").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_AVAILABILITY_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if (FormConstants.HOUSE_HOLD_LINE_LIST_NEW.equals(formType)) {
            answerString.append("-3").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.AREA_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-10").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.UUID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }

        if (FormConstants.TRAVELLERS_SCREENING.equals(formType)) {
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }

        if (FormConstants.TECHO_AWW_DAILY_NUTRITION.equals(formType)) {
            answerString.append("-6").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LOCATION_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if (FormConstants.BCG_VACCINATION_SURVEY.equals(formType)) {
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if (FormConstants.BCG_ELIGIBLE.equals(formType)) {
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if (FormConstants.HU_MEDICAL_ASSESSMENT.equals(formType)){
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if (FormConstants.HU_FOLLOW_UP.equals(formType)){
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if (FormConstants.HU_PREG_OUTCOME.equals(formType)){
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }



        if (formType != null && FormConstants.RCH_SHEETS.contains(formType)) {
            SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(context);
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(sharedPref.getString(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID, null))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-5").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(sharedPref.getString(RelatedPropertyNameConstants.FAMILY_ID, null))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-6").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(sharedPref.getString(RelatedPropertyNameConstants.LOCATION_ID, null))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-7").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(sharedPref.getString(RelatedPropertyNameConstants.CUR_PREG_REG_DET_ID, null))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                answerString.append("-55").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                        .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.UUID))
                        .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
                answerString.append("-44").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                        .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_UUID))
                        .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
                System.out.println("AFTER SUBMITTING FORM IN UUID -44 =====" + SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_UUID));
                answerString.append("-20").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                        .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID))
                        .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
                answerString.append("-21").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                        .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.GPS_LOCATION))
                        .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            }
        }


        if (formType != null && FormConstants.NCD_SHEETS.contains(formType)) {
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-5").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            if (formType.equalsIgnoreCase(FormConstants.NCD_FHW_WEEKLY_CLINIC)
                    || formType.equalsIgnoreCase(FormConstants.NCD_CVC_CLINIC)
                    || formType.equalsIgnoreCase(FormConstants.NCD_CVC_HOME)) {
                answerString.append("9").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                        .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.SCREENING_DATE))
                        .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            }
        }

        if (formType != null && FormConstants.NPCB_SHEETS.contains(formType)) {
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-5").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-6").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.AREA_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }

        if (FormConstants.IDSP_MEMBER.equals(formType) || FormConstants.IDSP_MEMBER_2.equals(formType)) {
            String familyQuestions = SharedStructureData.relatedPropertyHashTable.get("familyQuestions");
            if (familyQuestions != null) {
                answerString.append(familyQuestions);
            }
        }
        if (FormConstants.CHARDHAM_MEMBER_SCREENING.equals(formType)) {
            answerString.append("-10").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHARDHAM_MEMBER_UNIQUE_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-11").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.SCREENING_STATUS))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-12").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHARDHAM_DEFAULT_HEALTH_INFRA_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-13").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_FROM_DEVICE_AND_NOT_REGISTERED))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-14").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHARDHAM_SCREENING_START_TIME))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if (FormConstants.ANEMIA_SURVEY.equals(formType)) {
            answerString.append("-10").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.PATIENT_UUID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-11").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.PATIENT_FHIR_RESOURCES_DATA))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if (FormConstants.CHIP_ACTIVE_MALARIA.equals(formType)
                || FormConstants.CHIP_PASSIVE_MALARIA.equals(formType)
                || FormConstants.CHIP_ACTIVE_MALARIA_FOLLOW_UP.equals(formType)) {
            answerString.append("-15").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MALARIA_TYPE))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }

        if (FormConstants.CHIP_TB.equals(formType)
                || FormConstants.CHIP_TB_FOLLOW_UP.equals(formType)) {
            answerString.append("-16").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.TB_SCREENING_TYPE))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }

        if (FormConstants.DNHDD_ANEMIA_SURVEY.equals(formType)) {
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-5").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }
        if (FormConstants.SICKLE_CELL_SURVEY.equals(formType)) {
            answerString.append("-4").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
            answerString.append("-5").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                    .append(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ACTUAL_ID))
                    .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
        }

        setBeneficiaryName(formType);
        return answerString.toString();
    }

    /**
     * @param myContext  current context of android view
     * @param myListener listener of button Click
     * @return return full dynamic form's whole structure as a LinearLayout
     * containing Scroll-> bodyLayout and footer -> Back and Next Button
     * All component have Unique id
     */
    public static LinearLayout generateDynamicScreenTemplate(Context myContext, View.OnClickListener myListener) {
        LinearLayout parentLayout =
                (LinearLayout) LayoutInflater.from(myContext).inflate(R.layout.activity_main, null);
        MaterialButton button = parentLayout.findViewById(ID_NEXT_BUTTON);
        button.setOnClickListener(myListener);
        return parentLayout;
    }

    /**
     * @param myContext Activity Context
     * @return Dynamic Vaccines Layout
     */
    public static LinearLayout generateDynamicVaccinations(Context myContext) {
        // create top content holder
        LinearLayout parentLayout = MyStaticComponents.getLinearLayout(myContext, -1, LinearLayout.VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, 300));

        // add body part
        NestedScrollView bodyScroller = MyStaticComponents.getScrollView(myContext, ID_BODY_SCROLL, new LinearLayout.LayoutParams(MATCH_PARENT, 0, 1));

        //add into parent
        parentLayout.addView(bodyScroller);

        // generate body
        LinearLayout bodyLayout = MyStaticComponents.getLinearLayout(myContext, ID_BODY_LAYOUT, LinearLayout.VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
        bodyLayout.setPadding(5, 5, 5, 5);
        bodyLayout.setFocusable(true);
        bodyLayout.setFocusableInTouchMode(true);
        bodyLayout.setOnClickListener(v -> {
            v.clearFocus();
            v.requestFocus();
        });
        // add body into body Scroller

        bodyScroller.addView(bodyLayout);

        return parentLayout;
    }

    public static String getFullFormName(String entity) {
        return UtilBean.getFullFormOfEntity().get(entity);
    }

    public static void storeForm(String entity, String answerString) {

        SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(SharedStructureData.context);
        SharedPreferences.Editor editor = sharedPref.edit();

        /*
         *  Create Log Entry For the Filled Form
         */
        LoggerBean loggerBean = new LoggerBean();

        String nameOfBeneficiary = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.BENEFICIARY_NAME_FOR_LOG);
        String familyIdForLog = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ID);

        if (nameOfBeneficiary != null) {
            loggerBean.setBeneficiaryName(nameOfBeneficiary);
        } else {
            if ((entity.equals(FormConstants.FAMILY_HEALTH_SURVEY) || entity.equals(FormConstants.CFHC) ||
                    entity.equals(FormConstants.CAM_FHS) || entity.equals(FormConstants.IDSP_NEW_FAMILY) || entity.equals(FormConstants.FAMILY_FOLDER) || entity.equals(FormConstants.HOUSE_HOLD_LINE_LIST_NEW))
                    && (familyIdForLog == null || familyIdForLog.equals(LabelConstants.NOT_AVAILABLE))) {
                loggerBean.setBeneficiaryName("New Family");
            } else if (entity.equals(FormConstants.FHS_MEMBER_UPDATE) || entity.equals(FormConstants.FHS_MEMBER_UPDATE_NEW)) {
                loggerBean.setBeneficiaryName("New Member");
            } else if (entity.equals(FormConstants.ADOLESCENT_HEALTH_SCREENING)) {
                loggerBean.setBeneficiaryName("New Adolescent Member");
            } else if (entity.equals(FormConstants.SICKLE_CELL_ADD_FAMILY)) {
                loggerBean.setBeneficiaryName("New Sickle Cell Family");
            } else if (entity.equals(FormConstants.SURVEILLANCE_ADD_FAMILY)) {
                loggerBean.setBeneficiaryName("New Family or Member Registration");
            } else if (entity.equals(FormConstants.SICKLE_CELL_ADD_NEW_MEMBER)) {
                loggerBean.setBeneficiaryName("New Sickle Cell Member");
            } else if (entity.equals(FormConstants.ANEMIA_SURVEY)) {
                String firstName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME);
                String lastName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME);
                loggerBean.setBeneficiaryName(firstName + " " + lastName);
            } else if (entity.equals(FormConstants.CHARDHAM_MEMBER_SCREENING)) {
                String lastSyncedName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY);
                if (lastSyncedName != null) {
                    loggerBean.setBeneficiaryName(lastSyncedName);
                } else {
                    loggerBean.setBeneficiaryName("");
                }
            } else {
                loggerBean.setBeneficiaryName("");
            }
        }

        //name of beneficiary
//        if (entity.equals(FormConstants.FAMILY_HEALTH_SURVEY) || entity.equals(FormConstants.CFHC) || entity.equals(FormConstants.IDSP_NEW_FAMILY)) {
//            String familyId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ID);
//            if (familyId == null || familyId.equals(LabelConstants.NOT_AVAILABLE)) {
//                loggerBean.setBeneficiaryName("New Family");
//            } else {
//                loggerBean.setBeneficiaryName(familyId);
//            }
//        } else if (entity.equals(FormConstants.FHS_MEMBER_UPDATE)) {
//            String nameOfBeneficiary = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY);
//            if (nameOfBeneficiary != null) {
//                loggerBean.setBeneficiaryName(nameOfBeneficiary);
//            } else {
//                loggerBean.setBeneficiaryName("New Member");
//            }
//        } else {
//            String nameOfBeneficiary = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY);
//            if (nameOfBeneficiary != null) {
//                loggerBean.setBeneficiaryName(nameOfBeneficiary);
//            } else {
//                loggerBean.setBeneficiaryName("");
//            }
//        }

        //  Prepare Checksum Value
        StringBuilder checkSum = new StringBuilder(SewaTransformer.loginBean.getUsername());
        checkSum.append(Calendar.getInstance().getTimeInMillis());
        if (checkSum.toString().trim().length() > 0) {
            loggerBean.setCheckSum(checkSum.toString());
        }
        loggerBean.setDate(Calendar.getInstance().getTimeInMillis());
        loggerBean.setFormType(entity);
        String entityFullForm = getFullFormName(entity);
        if (entityFullForm == null) {
            loggerBean.setTaskName(entity);
        } else {
            loggerBean.setTaskName(entityFullForm);
        }
        loggerBean.setNoOfAttempt(0);
        loggerBean.setStatus(GlobalTypes.STATUS_PENDING);
        loggerBean.setRecordUrl(WSConstants.CONTEXT_URL_TECHO.trim());
        //loggerBean.setNotificationId(0); // baki
        Log.i(TAG, "LOGGER BEAN : " + loggerBean);
        Integer loggerBeanId = SharedStructureData.sewaService.createLoggerBean(loggerBean);
        editor.putString("loggerBeanId", String.valueOf(loggerBeanId));
        if (loggerBeanId == null) {
            return;
        }

        // store all Audio data structure ....
        Map<String, String> filesToAudioUpload = SharedStructureData.audioFilesToUpload;

        if (filesToAudioUpload != null && !filesToAudioUpload.isEmpty()) {
            for (Map.Entry<String, String> entry : filesToAudioUpload.entrySet()) {
                String filename = entry.getKey();
                String fileType = entry.getValue();

                UploadFileDataBean uploadFileDataBean = new UploadFileDataBean();
                uploadFileDataBean.setUniqueId(UUID.randomUUID().toString());
                uploadFileDataBean.setCheckSum(loggerBean.getCheckSum());
                uploadFileDataBean.setToken(SewaTransformer.loginBean.getUserToken());
                if (fileType != null) {
                    uploadFileDataBean.setFileType(fileType);
                }
                uploadFileDataBean.setFormType(loggerBean.getFormType());
                uploadFileDataBean.setFileName(filename);
                uploadFileDataBean.setUserName(SewaTransformer.loginBean.getUsername());
                uploadFileDataBean.setParentStatus(GlobalTypes.STATUS_PENDING);
                uploadFileDataBean.setStatus(GlobalTypes.STATUS_PENDING);

                //  Store upload file data bean to SQLite
                Integer districtIndex = SharedStructureData.sewaService.createUploadFileDataBean(uploadFileDataBean);

                if (districtIndex != null) {
                    Log.i(TAG, "Created for District File ID : " + districtIndex);
                }
            }
            SharedStructureData.audioFilesToUpload.clear();
        }

        StoreAnswerBean storeAnswerBean = new StoreAnswerBean();
        storeAnswerBean.setAnswer(answerString);
        storeAnswerBean.setFormFilledUpTime(SharedStructureData.formFillUpTime);
        storeAnswerBean.setAnswerEntity(entity);
        storeAnswerBean.setChecksum(checkSum.toString());
        storeAnswerBean.setDateOfMobile(Calendar.getInstance().getTimeInMillis());
        storeAnswerBean.setMorbidityAnswer("-1");

        //set Morbidity
        if (entity.equalsIgnoreCase(FormConstants.ANC_MORBIDITY)
                || entity.equalsIgnoreCase(FormConstants.CHILD_CARE_MORBIDITY)
                || entity.equalsIgnoreCase(FormConstants.PNC_MORBIDITY)) {
            List<BeneficiaryMorbidityDetails> beneficiaryMorbidityDetailsVector = MorbiditiesConstant.morbidities;

            MorbidityAnswerStringBean morbidityAnswerStringBean = new MorbidityAnswerStringBean();
            morbidityAnswerStringBean.setBeneficiaryMorbidityDetailses(beneficiaryMorbidityDetailsVector);
            morbidityAnswerStringBean.setFamilyUnderstand(SewaUtil.familyUnderstandInMorbidity);
            String morbidityString = morbidityAnswerStringBean.calculateMorbidityString();

            MorbiditiesConstant.morbidities = null;
            SewaUtil.familyUnderstandInMorbidity = null;

            storeAnswerBean.setMorbidityAnswer(morbidityString);
        }

        Long notificationId = null;
        String notificationIdString = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.NOTIFICATION_ID);
        if (notificationIdString != null && notificationIdString.trim().length() > 0) {
            notificationId = Long.valueOf(notificationIdString);
        }

        if (notificationId != null) {
            storeAnswerBean.setNotificationId(notificationId);
            Gson gson = new Gson();
            String json = gson.toJson(SharedStructureData.sewaService.getNotificationsById(notificationId));
            editor.putString(GlobalTypes.NOTIFICATION_BEAN, json);
            SharedStructureData.sewaService.deleteNotificationByNotificationId(notificationId);
            SharedStructureData.relatedPropertyHashTable.remove(RelatedPropertyNameConstants.NOTIFICATION_ID);
        } else {
            storeAnswerBean.setNotificationId(-1L);
        }

        String checkSumProperty = SharedStructureData.relatedPropertyHashTable.get("checkSum");
        if (checkSumProperty != null) {
            storeAnswerBean.setRelatedInstance(checkSumProperty);
        } else {
            storeAnswerBean.setRelatedInstance("-1");
        }

        // To store the checksum as related id for Morbidity Form
        if (entity.equalsIgnoreCase(FormConstants.ASHA_ANC) || entity.equalsIgnoreCase(FormConstants.ASHA_PNC) || entity.equalsIgnoreCase(FormConstants.ASHA_CS)) {
            SharedStructureData.relatedPropertyHashTable.put("checkSum", "l" + checkSum);
        }

        String customType = SharedStructureData.relatedPropertyHashTable.get("customType");
        if (customType != null) {
            storeAnswerBean.setCustumType(customType);
        }

        if (entity.equals(FormConstants.BCG_ELIGIBLE)) {
            String memberId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID);
            if (memberId != null && !memberId.equals(LabelConstants.NOT_AVAILABLE)) {
                SharedStructureData.sewaFhsService.markMemberBcgEligibleStatus(Long.valueOf(memberId));
            }
        }

        if (entity.equals(FormConstants.BCG_VACCINATION_SURVEY)) {
            String memberId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID);
            if (memberId != null && !memberId.equals(LabelConstants.NOT_AVAILABLE)) {
                SharedStructureData.sewaFhsService.markMemberBcgSurveyStatus(Long.valueOf(memberId));
            }
        }

        if (entity.equals(FormConstants.FAMILY_HEALTH_SURVEY)) {
            if ("1".equals(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_FOUND))) {
                String familyId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ID);
                if (familyId != null && !familyId.equals(LabelConstants.NOT_AVAILABLE)) {
                    SharedStructureData.sewaFhsService.markFamilyAsVerified(familyId);
                }
            } else if ("3".equals(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_FOUND))
                    || "4".equals(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_FOUND))) {
                String familyId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ID);
                if (familyId != null && !familyId.equals(LabelConstants.NOT_AVAILABLE)) {
                    SharedStructureData.sewaFhsService.markFamilyAsArchived(familyId);
                }
            }

            if (SharedStructureData.familyDataBeanToBeMerged != null) {
                SharedStructureData.sewaFhsService.mergeFamilies(SharedStructureData.currentFamilyDataBean, SharedStructureData.familyDataBeanToBeMerged);
            }
        }

        if (entity.equals(FormConstants.CFHC) || entity.equals(FormConstants.CAM_FHS)) {
            if ("1".equals(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_FOUND))) {
                String familyId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ID);
                if (familyId != null && !familyId.equals(LabelConstants.NOT_AVAILABLE)) {
                    SharedStructureData.sewaFhsService.markFamilyAsCFHCVerified(familyId);
                }
            }

            if (SharedStructureData.familyDataBeanToBeMerged != null) {
                SharedStructureData.sewaFhsService.mergeFamilies(SharedStructureData.currentFamilyDataBean, SharedStructureData.familyDataBeanToBeMerged);
            }
        }

        String actualId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID);
        if (actualId != null) {
            Long memberActualId = Long.parseLong(actualId);
            if (entity.equals(FormConstants.LMP_FOLLOW_UP)
                    || entity.equals(FormConstants.CAM_ANC)
                    || entity.equals(FormConstants.CAM_WPD)
                    || entity.equals(FormConstants.TECHO_FHW_ANC)
                    || entity.equals(FormConstants.TECHO_FHW_WPD)
                    || entity.equals(FormConstants.TECHO_FHW_PNC)
                    || entity.equals(FormConstants.TECHO_FHW_CS)) {
                String memberStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS);
                if (memberStatus != null && memberStatus.equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    SharedStructureData.sewaFhsService.markMemberAsDead(memberActualId);
                    SharedStructureData.sewaFhsService.deleteNotificationByMemberIdAndNotificationType(memberActualId, null);
                }
            }

            if (entity.equals(FormConstants.LMP_FOLLOW_UP)) {
                String isPregnant = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_PREGNANT);
                if (isPregnant != null && isPregnant.equals("1")) {
                    SharedStructureData.sewaFhsService.updateMemberPregnantFlag(memberActualId, Boolean.TRUE);

                    String lmpDate = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LMP_DATE);
                    if (lmpDate != null) {
                        Date lmp = new Date(Long.parseLong(lmpDate));
                        SharedStructureData.sewaFhsService.updateMemberLmpDate(memberActualId, lmp);
                    }

                    List<String> notificationTypes = new ArrayList<>();
                    notificationTypes.add(FormConstants.LMP_FOLLOW_UP);
                    SharedStructureData.sewaFhsService.deleteNotificationByMemberIdAndNotificationType(memberActualId, notificationTypes);
                }
                if (isPregnant != null && isPregnant.equals("5")) {
                    SharedStructureData.sewaFhsService.updateMemberPregnantFlag(memberActualId, null);
                }
            }

            if (entity.equals(FormConstants.TECHO_FHW_WPD) || entity.equals(FormConstants.CAM_WPD)) {
                SharedStructureData.sewaFhsService.updateMemberPregnantFlag(memberActualId, Boolean.FALSE);
                List<String> notificationTypes = new ArrayList<>();
                notificationTypes.add(FormConstants.TECHO_FHW_ANC);
                notificationTypes.add(FormConstants.TECHO_FHW_WPD);
                SharedStructureData.sewaFhsService.deleteNotificationByMemberIdAndNotificationType(memberActualId, notificationTypes);
            }

            if (entity.equals(FormConstants.TECHO_FHW_CS)) {
                String vaccinationGiven = sharedPref.getString("vaccinationGiven", null);
                if (vaccinationGiven != null) {
                    SharedStructureData.sewaFhsService.updateVaccinationGivenForChild(memberActualId, vaccinationGiven);
                }
            }
        }

        if (entity.equals(FormConstants.TECHO_FHW_PNC)) {
            String vaccinationGivenMap = sharedPref.getString("vaccinationMapWithUniqueHealthId", null);
            if (vaccinationGivenMap != null) {
                Gson gson = new Gson();
                HashMap<String, String> hashMap = gson.fromJson(vaccinationGivenMap, new TypeToken<HashMap<String, String>>() {
                }.getType());
                for (Map.Entry<String, String> entry : hashMap.entrySet()) {
                    SharedStructureData.sewaFhsService.updateVaccinationGivenForChild(entry.getKey(), entry.getValue());
                }
            }
        }

        storeAnswerBean.setRecordUrl(WSConstants.CONTEXT_URL_TECHO);
        if (SewaTransformer.loginBean != null) {
            storeAnswerBean.setToken(SewaTransformer.loginBean.getUserToken());
            storeAnswerBean.setUserId(SewaTransformer.loginBean.getUserID());
        }

        String memberId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ID);
        if (memberId != null) {
            storeAnswerBean.setMemberId(Long.valueOf(memberId));
        }

        if (entity.equalsIgnoreCase(FormConstants.CHARDHAM_MEMBER_SCREENING)) {
            SharedStructureData.versionService.createOrUpdateVersionBean(GlobalTypes.LAST_MEMBER_SCREENED, String.valueOf(checkSum));
        }

        if (SharedStructureData.finalFilesToUpload != null && !SharedStructureData.finalFilesToUpload.isEmpty()) {
            for (QueFormBean queFormBean : SharedStructureData.finalFilesToUpload) {
                SharedStructureData.sewaService.createUploadFileDataBean(queFormBean, entity, memberId, checkSum.toString());
            }
        }

        storeRequiredDataWhenFormIsFilledOffline(entity, answerString, storeAnswerBean);

        Integer answerRecordStoredId = SharedStructureData.sewaService.createStoreAnswerBean(storeAnswerBean);

        editor.putString("answerRecordStoredId", String.valueOf(answerRecordStoredId));
        editor.apply();

        if (answerRecordStoredId != null) {
            Log.i(TAG, "StoreAnswerBeanID : " + answerRecordStoredId);
        }

        Log.d("Dynamic Form", "Generated Record : " + SewaTransformer.loginBean.getUserToken()
                + "\nRecord : " + storeAnswerBean.pack());
    }

    private static void storeRequiredDataWhenFormIsFilledOffline(String entity, String answerString, StoreAnswerBean storeAnswerBean) {

        Gson gson = new Gson();
        String familyID = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ID);
        String uniqueHealthId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.UNIQUE_HEALTH_ID);
        String memberStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS);
        String serviceDate = SharedStructureData.relatedPropertyHashTable.get("serviceDate");
        FamilyBean familyBean = SharedStructureData.sewaFhsService.retrieveFamilyBeanByFamilyId(familyID);
        MemberBean memberBean;
        if (uniqueHealthId != null) {
            memberBean = SharedStructureData.sewaFhsService.retrieveMemberBeanByHealthId(uniqueHealthId);
        } else {
            memberBean = new MemberBean();
        }

        if (memberBean != null && memberStatus != null) {
            String state = null;
            if (memberStatus.equalsIgnoreCase("DEATH")) {
                state = FhsConstants.CFHC_MEMBER_STATE_DEAD;
            } else if (memberStatus.equalsIgnoreCase("MIGRATED")) {
                state = FhsConstants.FHS_MEMBER_STATE_MIGRATED;
            }
            memberBean.setState(state);
            SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
        }

        if (FormConstants.LMP_FOLLOW_UP.equalsIgnoreCase(entity) ||
                FormConstants.TECHO_FHW_ANC.equalsIgnoreCase(entity) ||
                FormConstants.TECHO_FHW_WPD.equalsIgnoreCase(entity) ||
                FormConstants.TECHO_FHW_PNC.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_ACTIVE_MALARIA.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_ACTIVE_MALARIA_FOLLOW_UP.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_TB.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_TB_FOLLOW_UP.equalsIgnoreCase(entity) ||
                FormConstants.HIV_POSITIVE.equalsIgnoreCase(entity) ||
                FormConstants.HIV_SCREENING.equalsIgnoreCase(entity) ||
                FormConstants.EMTCT.equalsIgnoreCase(entity) ||
                FormConstants.TECHO_FHW_VAE.equalsIgnoreCase(entity) ||
                FormConstants.HIV_SCREENING_FU.equalsIgnoreCase(entity) ||
                FormConstants.KNOWN_POSITIVE.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_PASSIVE_MALARIA.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_COVID_SCREENING.equalsIgnoreCase(entity) ||
                FormConstants.TECHO_FHW_CS.equalsIgnoreCase(entity)) {
            if (memberBean != null && serviceDate != null) {
                MemberAdditionalInfoDataBean memberAdditionalInfoDataBean;
                if (memberBean.getAdditionalInfo() != null) {
                    memberAdditionalInfoDataBean = gson.fromJson(memberBean.getAdditionalInfo(), MemberAdditionalInfoDataBean.class);
                } else {
                    memberAdditionalInfoDataBean = new MemberAdditionalInfoDataBean();
                }
                if ("T".equalsIgnoreCase(memberBean.getMobileNumber())) {
                    memberBean.setMobileNumber(SharedStructureData.relatedPropertyHashTable.get("phoneNumber"));
                }
                memberAdditionalInfoDataBean.setLastServiceLongDate(Long.parseLong(serviceDate));
                memberBean.setAdditionalInfo(gson.toJson(memberAdditionalInfoDataBean));
                SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
            }
        }

        //creating family and member from household line list registration for offline sync
        if (FormConstants.HOUSE_HOLD_LINE_LIST_NEW.equalsIgnoreCase(entity)
                && "1".equalsIgnoreCase(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.NEW_FAMILY))) {
            HouseHoldLineListMobileDto houseHoldLineListMobileDto = new Gson().fromJson(answerString, HouseHoldLineListMobileDto.class);
            SharedStructureData.sewaService.createFamilyBean(houseHoldLineListMobileDto, memberBean);
        } else if (FormConstants.FHS_MEMBER_UPDATE_NEW.equalsIgnoreCase(entity)) {
            HouseHoldLineListMobileDto houseHoldLineListMobileDto = new Gson().fromJson(answerString, HouseHoldLineListMobileDto.class);
            if (memberBean != null && SharedStructureData.relatedPropertyHashTable.containsKey(RelatedPropertyNameConstants.UNIQUE_HEALTH_ID)) {
                //update member for MEMBER_UPDATE_NEW form
                for (HouseHoldLineListMobileDto.MemberDetails memberDetails : houseHoldLineListMobileDto.getMemberDetails()) {
                    SharedStructureData.sewaService.updateMemberByUniqueHealthId(memberDetails, memberBean, familyBean);
                }
            } else {
                //adding new member for MEMBER_UPDATE_NEW form
                if (familyID != null) {
                    for (HouseHoldLineListMobileDto.MemberDetails memberDetails : houseHoldLineListMobileDto.getMemberDetails()) {
                        SharedStructureData.sewaService.createMemberBean(memberDetails, memberBean, familyBean);
                    }
                }
            }
        }

        if (memberBean != null && memberStatus != null && memberStatus.equalsIgnoreCase("DEATH")) {
            memberBean.setState(FhsConstants.FHS_MEMBER_STATE_MIGRATED);
        }

        if (FormConstants.LMP_FOLLOW_UP.equalsIgnoreCase(entity)) {
            if (memberBean != null) {
                String isPregnant = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_PREGNANT);
                String lmpDate = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LMP_DATE);
                if (lmpDate != null) {
                    Date lmp = new Date(Long.parseLong(lmpDate));
                    memberBean.setLmpDate(lmp);
                    if (memberBean.getLmpDate() != null) {
                        Calendar calendar = Calendar.getInstance();
                        Date lastLmpDate = memberBean.getLmpDate();
                        calendar.setTime(lastLmpDate);
                        calendar.add(Calendar.DAY_OF_YEAR, 281);
                        Date edd = calendar.getTime();
                        if ("1".equalsIgnoreCase(isPregnant)) {
                            memberBean.setEdd(edd);
                        }
                    }
                    if ("1".equalsIgnoreCase(isPregnant)) {
                        memberBean.setIsPregnantFlag(Boolean.TRUE);
                    }
                    if ("5".equalsIgnoreCase(isPregnant)) {
                        memberBean.setIsPregnantFlag(null);
                    }
                    SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
                }
            }
        }

        if (FormConstants.TECHO_FHW_ANC.equalsIgnoreCase(entity)) {
            if (memberBean != null) {
                String hivResult = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HIV_STATUS_FROM_ANC);
                if (hivResult != null && hivResult.equalsIgnoreCase(RchConstants.TEST_POSITIVE)) {
                    memberBean.setIsHivPositive(hivResult);
                    SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
                }
                /*//For retrieving if medicine has been given to patient
                String ifaTabletsGiven = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IFA_TABLETS);
                String faTabletsGiven = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FA_TABLETS);
                String calciumTabletsGiven = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CALCIUM_TABLETS);
                String albendazaoleTabletsGiven = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.ALBENDAZOLE_TABLETS);
                String ttGiven = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.TT_VACCINE);
                String ttOneGiven = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.TT_ONE_VACCINE);
                String ttTwoGiven = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.TT_TWO_VACCINE);

                //For retrieving ids of each medicine
                Integer ifaId = SharedStructureData.sewaFhsService.getIdOfListValueByConst(LabelConstants.IFA);
                Integer faId = SharedStructureData.sewaFhsService.getIdOfListValueByConst(LabelConstants.FA);
                Integer calciumId = SharedStructureData.sewaFhsService.getIdOfListValueByConst(LabelConstants.CALCIUM);
                Integer albendazoleId = SharedStructureData.sewaFhsService.getIdOfListValueByConst(LabelConstants.ALBENDAZOLE);
                Integer ttId = SharedStructureData.sewaFhsService.getIdOfListValueByConst(LabelConstants.TT_VACCINE);
                Integer tt1Id = SharedStructureData.sewaFhsService.getIdOfListValueByConst(LabelConstants.TT_ONE_VACCINE);
                Integer tt2Id = SharedStructureData.sewaFhsService.getIdOfListValueByConst(LabelConstants.TT_TWO_VACCINE);


                //Updating each tablet stock in stockInventoryBean
                if (ifaTabletsGiven != null) {
                    SharedStructureData.sewaService.updateStockInventoryByMedicineId(ifaId, Integer.parseInt(ifaTabletsGiven));
                }
                if (faTabletsGiven != null) {
                    SharedStructureData.sewaService.updateStockInventoryByMedicineId(faId, Integer.parseInt(faTabletsGiven));
                }
                if (calciumTabletsGiven != null) {
                    SharedStructureData.sewaService.updateStockInventoryByMedicineId(calciumId, Integer.parseInt(calciumTabletsGiven));
                }
                if (albendazaoleTabletsGiven != null) {
                    SharedStructureData.sewaService.updateStockInventoryByMedicineId(albendazoleId, 1);
                }
                if (ttGiven != null) {
                    SharedStructureData.sewaService.updateStockInventoryByMedicineId(ttId, 1);
                }
                if (ttOneGiven != null) {
                    SharedStructureData.sewaService.updateStockInventoryByMedicineId(tt1Id, 1);
                }
                if (ttTwoGiven != null) {
                    SharedStructureData.sewaService.updateStockInventoryByMedicineId(tt2Id, 1);
                }*/
            }
        }

        if (FormConstants.TECHO_FHW_WPD.equalsIgnoreCase(entity)) {
            if (memberBean != null) {
                String lastDateOfDelivery = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.DELIVERY_DATE);
                String pregnancyOutCome = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.PREGNANCY_OUTCOME);
                String hasDeliveryHappened = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HAS_DELIVERY_HAPPENED);
                String babyGender = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.BABIES_GENDER);
                String motherAlive = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MOTHER_ALIVE);
                if (lastDateOfDelivery != null && !lastDateOfDelivery.isEmpty()) {
                    memberBean.setLastDeliveryDate(new Date(Long.parseLong(lastDateOfDelivery)));
                    if ("1".equalsIgnoreCase(hasDeliveryHappened) && pregnancyOutCome != null) {
                        memberBean.setIsPregnantFlag(Boolean.FALSE);
                    }
                    SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
                }

                if (lastDateOfDelivery != null
                        && !lastDateOfDelivery.isEmpty()
                        && (RelatedPropertyNameConstants.PREGNANCY_OUTCOME_LIVE_BIRTH.equalsIgnoreCase(pregnancyOutCome)
                        || RelatedPropertyNameConstants.PREMATURE.equalsIgnoreCase(pregnancyOutCome))) {
                    MemberBean childMember = new MemberBean();
                    childMember.setFamilyId(memberBean.getFamilyId());
                    childMember.setFirstName("B/o " + memberBean.getFirstName());
                    childMember.setMiddleName(memberBean.getMiddleName());
                    childMember.setLastName(memberBean.getLastName());
                    childMember.setGender(babyGender);
                    childMember.setDob(new Date(Long.parseLong(lastDateOfDelivery)));
                    childMember.setState(FhsConstants.FHS_MEMBER_STATE_NEW);
                    childMember.setMaritalStatus("630");
                    if (memberBean.getActualId() != null) {
                        childMember.setMotherId(Long.parseLong(memberBean.getActualId()));
                    }
                    childMember.setMotherUUID(memberBean.getMemberUuid());
                    if (SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_UUID_WPD) != null) {
                        childMember.setMemberUuid(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_UUID_WPD));
                        System.out.println("WPD CHILD UUID WHEN MEMBER GETS SAVED == " + childMember.getMemberUuid());
                    }
                    childMember.setUniqueHealthId(HouseHoldLineListMobileMapper.generateTempUniqueHealthId(childMember.getMemberUuid()));
                    SharedStructureData.sewaService.createMemberBean(null, childMember, familyBean);
                }

                if ("2".equalsIgnoreCase(motherAlive)) {
                    memberBean.setState(FhsConstants.CFHC_MEMBER_STATE_DEAD);
                    SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
                }
            }
        }

        if (FormConstants.TECHO_FHW_CS.equalsIgnoreCase(entity)) {
            String vaccinationGiven = SharedStructureData.relatedPropertyHashTable.get("vaccinationGiven");
            if (memberBean != null && memberBean.getUniqueHealthId() != null && vaccinationGiven != null) {
                SharedStructureData.sewaFhsService.updateVaccinationGivenForChild(memberBean.getUniqueHealthId(), UtilBean.convertStringToMap(vaccinationGiven));
            }
        }

        if (FormConstants.TECHO_FHW_PNC.equalsIgnoreCase(entity)) {
            String isChildAlive = SharedStructureData.relatedPropertyHashTable.get("isChildAlive");
            String motherAlive = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MOTHER_ALIVE);

            String uniqueHealthIdChild = SharedStructureData.relatedPropertyHashTable.get("uniqueHealthIdChild");
            MemberBean childBean = SharedStructureData.sewaFhsService.retrieveMemberBeanByHealthId(uniqueHealthIdChild);

            if (childBean != null && isChildAlive != null && !isChildAlive.isEmpty() && !isChildAlive.equals("1")) {
                childBean.setState(FhsConstants.CFHC_MEMBER_STATE_DEAD);
                SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, childBean, familyBean);
            }

            if (uniqueHealthIdChild != null && childBean != null) {
                StringBuilder stringBuilder = new StringBuilder(answerString);
                stringBuilder.append("-45").append(GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR)
                        .append(childBean.getMemberUuid())
                        .append(GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR);
                storeAnswerBean.setAnswer(stringBuilder.toString().trim());
            }

            if (memberBean != null && "2".equalsIgnoreCase(motherAlive)) {
                memberBean.setState(FhsConstants.CFHC_MEMBER_STATE_DEAD);
                SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
            }
        }

        if (FormConstants.CHIP_ACTIVE_MALARIA.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_ACTIVE_MALARIA_FOLLOW_UP.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_PASSIVE_MALARIA.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_COVID_SCREENING.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_TB.equalsIgnoreCase(entity) ||
                FormConstants.CHIP_TB_FOLLOW_UP.equalsIgnoreCase(entity)) {
            String rdtStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.RDT_STATUS);
            String lmpDate = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LMP_DATE);
            String isItIndexCase = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_IT_INDEX_CASE);
            if (memberBean != null && rdtStatus != null && !rdtStatus.isEmpty()) {
                memberBean.setRdtStatus(rdtStatus);
            }
            if (memberBean != null && lmpDate != null && !lmpDate.isEmpty()) {
                memberBean.setLmpDate(new Date(Long.parseLong(lmpDate)));
            }
            if (memberBean != null && isItIndexCase != null && !isItIndexCase.isEmpty()) {
                memberBean.setIndexCase(isItIndexCase.equalsIgnoreCase("1") ? Boolean.TRUE : Boolean.FALSE);
            }
            SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
        }

        if (FormConstants.CHIP_TB.equalsIgnoreCase(entity)) {
            String tbSuspected = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_TB_SUSPECTED);
            if (memberBean != null && tbSuspected != null && !tbSuspected.isEmpty()) {
                memberBean.setTbSuspected(Boolean.TRUE);
                memberBean.setTbCured(Boolean.FALSE);
                SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
            }
        }

        if (FormConstants.CHIP_TB_FOLLOW_UP.equalsIgnoreCase(entity)) {
            String tbCured = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_TB_CURED);
            if (memberBean != null && tbCured != null && !tbCured.isEmpty()) {
                memberBean.setTbSuspected(Boolean.FALSE);
                memberBean.setTbCured(Boolean.TRUE);
                SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
            }
        }

        if (FormConstants.HIV_SCREENING.equalsIgnoreCase(entity) || FormConstants.HIV_SCREENING_FU.equalsIgnoreCase(entity)) {
            String hivTestResult = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HIV_TEST_RESULT);
            if (memberBean != null && hivTestResult != null && !hivTestResult.isEmpty()) {
                if ("T".equalsIgnoreCase(hivTestResult)) {
                    memberBean.setIsHivPositive(RchConstants.TEST_POSITIVE);
                } else {
                    memberBean.setIsHivPositive(RchConstants.TEST_NEGATIVE);
                }
                SharedStructureData.sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
            }
        }
    }

    /**
     * @param formType type of form set the name of beneficiary according to form
     *                 type
     */
    private static void setBeneficiaryName(String formType) {
        String name = null;
        String nameOfBeneficiary = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY);
        if (formType != null && (nameOfBeneficiary == null || nameOfBeneficiary.length() == 0)) {
            name = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_NAME);
        }
        if (name != null && name.length() != 0) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY, name);
        }
    }

    private static String checkCondition(String answer, String[] conditions, String forWhome) {
        if (conditions != null && conditions.length > 0) {
            for (String condition : conditions) {
                String[] data = UtilBean.split(condition, GlobalTypes.KEY_VALUE_SEPARATOR);
                if (data.length > 2 && (forWhome == null || forWhome.equalsIgnoreCase(data[2]))) {
                    float ans = Float.parseFloat(answer);
                    float comp = Float.parseFloat(data[1]);
                    if (UtilBean.isValidNumber(data[0], ans, comp)) {
                        return GlobalTypes.TRUE;
                    }
                }
            }
        }
        return GlobalTypes.FALSE;
    }

    public static String generateAnswersAccordingToForm(int pageStartPageNo, String formType, Context context) {
        if (FormConstants.NEW_DATA_BEAN_APPROACH_FORMS.contains(formType)) {
            return generateAnswerObject(pageStartPageNo, formType);
        } else {
            return generateAnswerString(pageStartPageNo, formType, context);
        }
    }

    public static String generateAnswerObject(int pageStartPageNo, String formType) {

        PageFormBean currentPage = SharedStructureData.mapIndexPage.get(pageStartPageNo);
        JSONObject answerObject = new JSONObject();
        if (currentPage == null) {
            setBeneficiaryName(formType);
            return answerObject.toString();
        }

        currentPage.setPrePage(null);
        do { // page loop
            int firstQuestionId = currentPage.getFirstQuestionId();
            List<Integer> listOfQuestion = currentPage.getListOfQuestion();
            if (listOfQuestion != null && !listOfQuestion.isEmpty()) {
                while (listOfQuestion.contains(firstQuestionId)) {
                    QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(firstQuestionId);
                    if (queFormBean == null) {
                        firstQuestionId = -1;
                        continue;
                    }

                    if (queFormBean.getIshidden().equalsIgnoreCase(GlobalTypes.TRUE)
                            || queFormBean.getAnswer() == null
                            || queFormBean.getAnswer().toString().trim().isEmpty()) {
                        firstQuestionId = getNext(queFormBean);
                        continue;
                    }

                    if (queFormBean.getFieldname() == null || queFormBean.getFieldname().isEmpty()) {
                        firstQuestionId = getNext(queFormBean);
                        continue;
                    }

                    try {
                        int loopCounter = queFormBean.getExtraBinding() > 0 ? queFormBean.getExtraBinding() : queFormBean.getLoopCounter();
                        if (queFormBean.getFieldname().contains(".")) {
                            addLoopAnswersInAnswerObject(answerObject, queFormBean, loopCounter);
                        } else {
                            FormFieldTypeConverter.putDataInAnswerObject(answerObject, queFormBean.getFieldname(), queFormBean.getAnswer().toString(), queFormBean.getFieldtype());
                        }
                        addFormWiseCommonDataInAnswerObject(answerObject, formType);
                    } catch (JSONException e) {
                        Log.e(TAG, e.getMessage(), e);
                    }
                    firstQuestionId = getNext(queFormBean);
                }
            }
            if (currentPage.getNextPage() != null) {
                currentPage = currentPage.getNextPage();
            } else {
                break;
            }
        } while (true);
        setBeneficiaryName(formType);
        return answerObject.toString();
    }

    private static void addLoopAnswersInAnswerObject(JSONObject answerObject, QueFormBean queFormBean, int loopCounter) throws JSONException {
        String[] split = queFormBean.getFieldname().split("\\.");
        JSONArray array;
        if (answerObject.has(split[0])) {
            array = (JSONArray) answerObject.get(split[0]);
        } else {
            array = new JSONArray();
        }
        JSONObject obj;
        if (array.length() < loopCounter + 1) {
            obj = new JSONObject();
            obj.put(split[1], FormFieldTypeConverter.convertStringToObject(
                    queFormBean.getAnswer().toString(), queFormBean.getFieldtype()));
            array.put(obj);
        } else {
            obj = array.getJSONObject(loopCounter);
            FormFieldTypeConverter.putDataInAnswerObject(obj, split[1], queFormBean.getAnswer().toString(), queFormBean.getFieldtype());

            array.put(loopCounter, obj);
        }
        answerObject.put(split[0], array);
    }

    private static void addFormWiseCommonDataInAnswerObject(JSONObject answerObject, String formType) throws JSONException {
        answerObject.put("mobileStartDate", FormFieldTypeConverter.convertStringToObject(
                SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FORM_START_DATE), FormFieldTypeConverter.FIELD_TYPE_LONG));
        answerObject.put("mobileEndDate", FormFieldTypeConverter.convertStringToObject(
                String.valueOf(new Date().getTime()), FormFieldTypeConverter.FIELD_TYPE_LONG));
        answerObject.put("memberId", SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID));
        answerObject.put("familyId", SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ACTUAL_ID));
        answerObject.put("locationId", SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.AREA_ID != null ? RelatedPropertyNameConstants.AREA_ID : RelatedPropertyNameConstants.LOCATION_ID));
        if (gpsEnabledForms.contains(formType)) {
            answerObject.put("currentLatitude", SharedStructureData.relatedPropertyHashTable.get("currentLatitude"));
            answerObject.put("currentLongitude", SharedStructureData.relatedPropertyHashTable.get("currentLongitude"));
        }
        if (formType.equalsIgnoreCase(FormConstants.HOUSE_HOLD_LINE_LIST_NEW)) {
            answerObject.put("uuid", SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.UUID));
            answerObject.put("currentLatitude", SharedStructureData.relatedPropertyHashTable.get("currentLatitude"));
            answerObject.put("currentLongitude", SharedStructureData.relatedPropertyHashTable.get("currentLongitude"));
            answerObject.put("locationId", SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.AREA_ID));
        }

        if (formType.equalsIgnoreCase(FormConstants.FHS_MEMBER_UPDATE_NEW)) {
            answerObject.put("uuid", SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.UUID));
        }
    }
}