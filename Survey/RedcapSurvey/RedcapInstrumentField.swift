//
//  RedcapInstrumentField.swift
//  Test_RedcapSurvey_1
//
//  Created by Ritter, Dean on 7/20/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapInstrumentField  {
    
    var fieldAnnotation: String { get { return base.attributeAsString(key: "field_annotation") } }
    var fieldLabel: String { get { return base.attributeAsString(key: "field_label") } }
    var fieldName: String { get { return base.attributeAsString(key: "field_name") } }
    var matrixRanking: String { get { return base.attributeAsString(key: "matrix_ranking") } }
    var identifier: String { get { return base.attributeAsString(key: "identifier") } }
    var selectChoicesOrCalculations: String { get { return base.attributeAsString(key: "select_choices_or_calculations") } }
    var textValidationMax: Int { get { return base.attributeAsInt(key: "text_validation_max") } }
    var textValidationMin: Int { get { return base.attributeAsInt(key: "text_validation_min") } }
    var fieldType: String { get { return base.attributeAsString(key: "field_type") } }
    var fieldNote: String { get { return base.attributeAsString(key: "field_note") } }
    
    var branchingLogic: RedcapInstrumentFieldBranchingLogic {
        
        return RedcapInstrumentFieldBranchingLogic(
            parentStepIdentifier: fieldName,
            logicAsString: base.attributeAsString(key: "branching_logic"))
    }
    
    var sectionHeader: String { get { return base.attributeAsString(key: "section_header") }    }
    var formName: String { get { return base.attributeAsString(key: "form_name") }    }
    var textValidationTypeOrShowSliderNumber: String { get { return base.attributeAsString(key: "text_validation_type_or_show_slider_number") }    }
    var customAlignment: String { get { return base.attributeAsString(key: "custom_alignment") }    }
    var requiredField: String { get { return base.attributeAsString(key: "required_field") }    }
    var questionNumber: String { get { return base.attributeAsString(key: "question_number") }    }
    var matrixGroupName: String { get { return base.attributeAsString(key: "matrix_group_name") } }
 
    var generatesValidModuleStep: Bool {
        
        return fieldType != "file" && // Upload a file
               fieldType != "calc"    // Calculation field
    }

    var hasNumericMax: Bool {
        return textValidationMax != Int.min
    }

    var hasNumericMin: Bool {
        return textValidationMin != Int.min
    }

    var isRecordIdField: Bool {
        // TODO: make this "includes"
        return fieldAnnotation == "chopnote_record_id"
    }

    var isDateField: Bool {
        // TODO: make this "includes"
        return textValidationTypeOrShowSliderNumber == "date_ymd"
    }

    var isEmailField: Bool {
        // TODO: make this "includes"
        return textValidationTypeOrShowSliderNumber == "email"
    }

    var isTelephoneNumberField: Bool {
        // TODO: make this "includes"
        return textValidationTypeOrShowSliderNumber == "phone"
    }

    var isIntegerField: Bool {
        // TODO: make this "includes"
        return textValidationTypeOrShowSliderNumber == "integer"
    }
    
    init(data: Dictionary<String, Any>) {
        
        base.coreAttributes = data
    }

    func generateModuleStep(options: RedcapInstrumentFieldGenerationOptions? = nil) -> ChopResearchStudyModuleStep {

        var step: ChopResearchStudyModuleStep
        
        if isRecordIdField {
            
            var recordId = ChopModuleDataPointCollected(
                withDescription: fieldName,
                andStepId: fieldName,
                andWebId: fieldName)
            
            recordId.collectString(stringToCollect: NSUUID().uuidString)
            step = recordId

        } else if isDateField {
            
            step = ChopDateQuestion(withStepID: fieldName, withWebId: fieldName, withTitle: fieldLabel)
            
        } else if isEmailField {
            
            step = ChopEmailQuestion(withStepID: fieldName, withWebId: fieldName, withTitle: fieldLabel)

        } else if isTelephoneNumberField {
            
            step = ChopPhoneNumberQuestion(withStepID: fieldName, withWebId: fieldName, withTitle: fieldLabel)
            
        } else if isIntegerField {
            
            let numericStep = ChopNumericQuestion(
                withStepID: fieldName,
                withWebId: fieldName,
                withTitle: fieldLabel,
                min: hasNumericMin ? textValidationMin : Int.min,
                max: hasNumericMax ? textValidationMax : Int.max)
            
            step = numericStep

        } else if fieldType == "checkbox" {
            
            let choices = parseSelectChoices()
            
            step = ChopMultipleChoiceQuestion(withStepID: fieldName,
                                                withWebId: fieldName,
                                                withQuestion: fieldLabel,
                                                allowsMultipleAnswers: true,
                                                withChoices: choices)
        } else if fieldType == "radio" {
            
            let choices = parseSelectChoices()
            
            step = ChopMultipleChoiceQuestion(withStepID: fieldName,
                                                withWebId: fieldName,
                                                withQuestion: fieldLabel,
                                                allowsMultipleAnswers: false,
                                                withChoices: choices)
        } else if fieldType == "text" {
         
            step = ChopTextQuestion(withStepID: fieldName,
                                       withWebId: fieldName,
                                       withTitle: fieldLabel)

        } else if fieldType == "notes" {
            
            step = ChopTextQuestion(withStepID: fieldName,
                                    withWebId: fieldName,
                                    withTitle: fieldLabel)

        } else if fieldType == "dropdown" {
            
            let choices = parseSelectChoices()

            step = ChopValuePickerQuestion(withStepID: fieldName,
                                           withWebId: fieldName,
                                           withQuestion: fieldLabel,
                                           withChoices: choices)

        } else if fieldType == "yesno" {
            
            let answers = ["Yes", "No"]
            
            step = ChopValuePickerQuestion(withStepID: fieldName,
                                           withWebId: fieldName,
                                           withQuestion: fieldLabel,
                                           withAnswers: answers)
        } else if fieldType == "slider" {
            let parser = RedcapSelectChoiceParser()
            let selectChoices = parser.parseSelectChoices(choicesAsStr: selectChoicesOrCalculations)
            
            step = ChopSliderQuestion(
                withStepID: fieldName,
                withWebId: fieldName,
                withTitle: fieldLabel,
                isVertical: customAlignment.contains("V"),
                min: 0,
                minValueDescription: (selectChoices.first?.description)!,
                max: 100,
                maxValueDescription: (selectChoices.last?.description)!)
        } else {
            print("WARNING: RedcapInstrumentField.generateModuleStep(): Unknown field type: " + fieldType)
            step = ChopMultipleChoiceQuestion(withStepID: fieldName,
                                                withWebId: fieldName,
                                                withQuestion: fieldLabel,
                                                allowsMultipleAnswers: false,
                                                withAnswers: [])
        }
        return step
    }

    private func parseSelectChoices() -> ChopItemSelectChoiceCollection {
        let parser = RedcapSelectChoiceParser()

        return parser.parseSelectChoices(choicesAsStr: selectChoicesOrCalculations)
    }

    private var base = RedcapItemBase()
}


struct RedcapInstrumentFieldCollection {
    
    var isEmpty: Bool {
        get { return items.count == 0 }
    }
    
    var first: RedcapInstrumentField {
        
        return items[0]
    }
    
    var containsRecordIdField: Bool {
        
        for item in items {
            
            if item.isRecordIdField {
                return true
            }
        }
        return false
    }
    
    func filter(instrumentName: String) -> RedcapInstrumentFieldCollection {
        
        var newCollection = RedcapInstrumentFieldCollection()
        
        for item in items {
            
            if (item.formName == instrumentName) {
                newCollection.add(item: item)
            }
        }
        return newCollection
    }
    
    mutating func loadFromJSON(data: [Dictionary<String, Any>], forInstrumentName instrumentName: String = "") {
        
        let loadAll = instrumentName.isEmpty
        
        for item in data {
            
            let surveyItem = RedcapInstrumentField(data: item)
            
            if loadAll || (surveyItem.formName == instrumentName) {
                items += [surveyItem]
            }
        }
        
    }
    
    mutating func removeAll() {
        
        items = [RedcapInstrumentField]()
    }
    
    mutating func add(item: RedcapInstrumentField) {
        
        items += [item]
    }
    
    fileprivate var items = [RedcapInstrumentField]()
}

extension RedcapInstrumentFieldCollection: Sequence {
    // MARK: Sequence
    public func makeIterator() -> RedcapInstrumentFieldIterator {
        
        return RedcapInstrumentFieldIterator(withArray: items)
    }
}


//////////////////////////////////////////////////////////////////////
// RedcapInstrumentFieldIterator
//////////////////////////////////////////////////////////////////////

struct RedcapInstrumentFieldIterator : IteratorProtocol {
    
    var values: [RedcapInstrumentField]
    var indexInSequence = 0
    
    init(withArray dictionary: [RedcapInstrumentField]) {
        values = [RedcapInstrumentField]()
        for value in dictionary {
            self.values += [value]
        }
    }
    
    mutating func next() -> RedcapInstrumentField? {
        if indexInSequence < values.count {
            let element = values[indexInSequence]
            indexInSequence += 1
            
            return element
        } else {
            indexInSequence = 0
            return nil
        }
    }
}

/*
 
 [
 "field_annotation":"",
 "field_label":1   . Which of the following mobile devices do you own? Please select all that apply.,
 "field_name":mobile_device_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Smartphone (like an iPhone or Android phone) | 2,
 Tablet (such as an iPad) | 3,
 Cell phone (call and text only) | 4,
 Feature phone (like an LG Mini,
 Samsung Monte,
 Song Ericsson) | 5,
 None of the above,
 "text_validation_min":,
 "field_type":checkbox,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 
 [
 "field_annotation":,
 "field_label":2   . Have you ever used a mobile device to look up or track information about your child's health?,
 "field_name":mobile_device_hi_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Yes | 2,
 No | 3,
 I don't own a mobile device,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":3   . Have you ever downloaded an app on a mobile device to help manage or look for information about your child's health?,
 "field_name":health_app_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Yes | 2,
 No | 3,
 I don't own a mobile device,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":4   . What type of apps do you currently have on your mobile device(s) to manage and/or find information about your child's health? Please check all that apply.,
 "field_name":currently_used_apps_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Asthma Management | 2,
 Diabetes Management | 3,
 Sleep | 4,
 Allergies | 5,
 Car Seat Safety | 6,
 Vaccines | 7,
 Health Portal (ex.,
 MyCHOP) | 8,
 Child Development (ex.,
 growth or milestone trackers) | 9,
 General Information (ex.,
 WebMD Baby) | 10,
 Other (please describe) | 11,
 None of the above | 12,
 I don't own a mobile device,
 "text_validation_min":,
 "field_type":checkbox,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":4   b. Other - please describe,
 "field_name":other_apps_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":,
 "text_validation_min":,
 "field_type":text,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 
 [
 "field_annotation":,
 "field_label":5   . How important is it that your child's doctor approves of the app that you use (or would use) to manage or look for information about your child on your mobile device(s)?,
 "field_name":doctor_approve_app_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Extremely Important | 2,
 Very Important | 3,
 Moderately Important | 4,
 Somewhat Important | 5,
 Not at all important,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 
 [
 "field_annotation":,
 "field_label":6   . If you use (or would use) a mobile app to collect health information about your child,
 how important is it for you to be able to share that information with your child's doctor?,
 "field_name":doctor_approval_2_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Extremely Important | 2,
 Very Important | 3,
 Moderately Important | 4,
 Somewhat Important | 5,
 Not at all Important,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 
 [
 "field_annotation":,
 "field_label":Security/privacy of health information,
 "field_name":security_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5   | 6,
 6,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":7   . Which is your greatest concern about using health apps? Please rank concern with 1 being the GREATEST concern and 6 being the LEAST concern.,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":app_concern_v3
 ],
 [
 "field_annotation":,
 "field_label":Cost of app,
 "field_name":cost_app_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5   | 6,
 6,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":app_concern_v3
 ],
 [
 "field_annotation":,
 "field_label":Cost of data use,
 "field_name":cost_data_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5   | 6,
 6,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":app_concern_v3
 ],
 [
 "field_annotation":,
 "field_label":Time it would take to use the app,
 "field_name":time_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5   | 6,
 6,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":app_concern_v3
 ],
 [
 "field_annotation":,
 "field_label":Helpfulness of the app,
 "field_name":help_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5   | 6,
 6,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":app_concern_v3
 ],
 
 [
 "field_annotation":,
 "field_label":Knowing how to use the app,
 "field_name":knowledge_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5   | 6,
 6,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":app_concern_v3
 ],
 
 [
 "field_annotation":,
 "field_label":8   . How concerned are you about the security and privacy of your child's health information collected on a mobile device through a mobile app?,
 "field_name":concern_privacy_child_app_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Very concerned | 2,
 Fairly concerned | 3,
 Concerned | 4,
 Not very concerned | 5,
 Not at all concerned,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":9   . When it comes to using mobile health apps,
 how concerned are you about smartphone data cost?,
 "field_name":concern_cost_data_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Very concerned | 2,
 Fairly concerned | 3,
 Concerned | 4,
 Not very concerned | 5,
 Not at all concerned,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":10   . When it comes to using mobile health apps,
 how concerned are you about the cost of the mobile app itself?,
 "field_name":concern_cost_app_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Very Concerned | 2,
 Fairly Concerned | 3,
 Concerned | 4,
 Not Very Concerned | 5,
 Not at all Concerned,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":Scheduling Appointments,
 "field_name":appointments_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":11   . Which of the following features would be of the most importance to you in a health app? Please rank importance with 1 being the MOST important and 5 being the LEAST important.,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":question_11_v3
 ],
 [
 "field_annotation":,
 "field_label":Reminder to Take Medication,
 "field_name":reminder_medication_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":question_11_v3
 ],
 [
 "field_annotation":,
 "field_label":Asking my Child's Doctor a Question,
 "field_name":doctor_question_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":question_11_v3
 ],
 [
 "field_annotation":,
 "field_label":Tracking my Child's Health,
 "field_name":tracking_child_health_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":question_11_v3
 ],
 [
 "field_annotation":,
 "field_label":Requesting a Medication Refill,
 "field_name":medication_refill_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 1   | 2,
 2   | 3,
 3   | 4,
 4   | 5,
 5,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":question_11_v3
 ],
 [
 "field_annotation":,
 "field_label":12   . If there were a list of CHOP recommended apps for various topics or health issues for your child that you could download onto your device,
 how likely would you use apps from this list?,
 "field_name":likely_use_chop_app_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Very likely | 2,
 Likely | 3,
 Not sure | 4,
 Unlikely | 5,
 Very unlikely,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":13   . Do you use the CHOP Patient Portal,
 called MyCHOP?,
 "field_name":use_mychop_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Use on my smart phone and computer | 2,
 Use on my smart phone only | 3,
 Use on computer only | 4,
 I don't use it,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":14   . What is your gender?,
 "field_name":gender_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Female | 2,
 Male | 3,
 Non Binary,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":15   . How old are you?,
 "field_name":age_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 17   or younger | 2,
 18-22   | 3,
 23-28   | 4,
 29-34   | 5,
 35-45   | 6,
 45-55   | 7,
 55+,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":16   . What was the last grade you completed in school?,
 "field_name":education_attainment_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Less than high school | 2,
 High school,
 GED,
 technical school | 3,
 Some college | 4,
 College graduate and beyond,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":17   . What is your race? One or more categories may be selected.,
 "field_name":race_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 White | 2,
 Black or African American | 3,
 Asian or Pacific Islander | 4,
 Native American/American Indian | 5,
 Other:| 6,
 Don't know | 7,
 Rather not say,
 "text_validation_min":,
 "field_type":checkbox,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":17   b. Other,
 "field_name":other_race_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":,
 "text_validation_min":,
 "field_type":text,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":18   . Are you Hispanic,
 Latino/a,
 or Spanish origin?,
 "field_name":hispanic_origin_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 No,
 not Hispanic,
 Latino/a,
 or Spanish origin | 2,
 Yes,
 Hispanic,
 Latino/a,
 or Spanish origin,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":19   . What is (are) the age(s) of your child(ren)? Please select all that apply.,
 "field_name":age_of_child_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Newborn-12 months | 2,
 1-5   years | 3,
 6-9   years | 4,
 10-12   years | 5,
 13-17   years | 6,
 18   or older,
 "text_validation_min":,
 "field_type":checkbox,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ],
 [
 "field_annotation":,
 "field_label":20   . Please select your current household income in U.S. dollar.,
 "field_name":household_income_v3,
 "text_validation_max":,
 "matrix_ranking":,
 "identifier":,
 "select_choices_or_calculations":1,
 Under $10,
 000   | 2,
 $10,
 000-19,
 999   | 3,
 $20,
 000-39,
 999   | 4,
 $40,
 000-49,
 999   | 5,
 $50,
 000-74,
 999   | 6,
 $75,
 000-99,
 999   | 7,
 $100,
 000-150,
 000   | 8,
 Over $150,
 000   | 9,
 Rather not say,
 "text_validation_min":,
 "field_type":radio,
 "field_note":,
 "branching_logic":,
 "section_header":,
 "form_name":iapp_parent_survey_3,
 "text_validation_type_or_show_slider_number":,
 "custom_alignment":,
 "required_field":,
 "question_number":,
 "matrix_group_name":
 ]
 ]
 
 

 */
