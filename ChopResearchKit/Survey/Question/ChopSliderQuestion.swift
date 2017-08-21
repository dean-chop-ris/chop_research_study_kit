//
//  ChopSliderQuestion.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/17/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopSliderQuestion {
    
    var answer: Int {
        
        return _answer
    }
    
    init(withStepID stepIdentifier: String,
         withWebId webIdentifier: String,
         withTitle questionTitle: String,
         isVertical: Bool = false,
         min: Int = Int.min,
         minValueDescription: String = "",
         max: Int = Int.max,
         maxValueDescription: String = "") {
        
        base.web_Id = webIdentifier
        
        
        //let sliderStepAsDouble = (Double(max) - Double(min) / 10.0)
        //let sliderStep = (Int(sliderStepAsDouble) < 1) ? 1 : Int(sliderStepAsDouble)
        let sliderDefault = Int((Double(max) + Double(min)) / 2.0)

        
        var minValDescr = min.description
        var maxValDescr = max.description
        
        if minValueDescription.isNotEmpty {
            minValDescr = minValueDescription
        }
        
        if maxValueDescription.isNotEmpty {
            maxValDescr = maxValueDescription
        }
        
        /*
         ResearchKit-imposed limits on scale input values:
         
         Minimum number of step in a task should not be less than 1.
         Minimum number of section on a scale (step count) should not be < 1.
         Maximum number of section on a scale (step count) should not be > 13.
         The lower bound value in scale answer format cannot be < -10000.
         The upper bound value in scale answer format cannot be >  10000.
         */
        let answerFormat = ORKScaleAnswerFormat(
            maximumValue: max,
            minimumValue: min,
            defaultValue: sliderDefault,
            step: 10,                    // STEP COUNT should be 1
            vertical: isVertical,
            maximumValueDescription: maxValDescr,
            minimumValueDescription: minValDescr)
        

        rkStep = ORKQuestionStep(identifier: stepIdentifier,
                                 title: questionTitle,
                                 answer: answerFormat)
    }
    
    
    fileprivate var _answer = 0
    fileprivate var rkStep: ORKQuestionStep
    fileprivate var base = ChopRKTaskStepBase()
}


extension ChopSliderQuestion: ChopRKTaskStep {
    // MARK: ChopRKTaskStep
    var passcodeProtected: Bool {
        get {
            return self.base.passcodeProtected
        }
        set {
            self.base.passcodeProtected = newValue
        }
    }
    
    func populateRKStepArray(stepArray: inout [ORKStep]) {
        stepArray += [rkStep]
    }
}

extension ChopSliderQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
}

extension ChopSliderQuestion: AbleToBeValidated {
    // MARK: : AbleToBeValidated
    var errorMessage: String { get { return base.validation.errMsg } }
    var bypassValidation: Bool {
        get { return base.validation.bypass_Validation }
        set { base.validation.bypass_Validation = newValue }
    }
}

extension ChopSliderQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {
        
        captureResult(fromORKTaskResult: orkTaskResult, andPutInto: &_answer)
    }
    
    fileprivate func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult, andPutInto destNumber: inout Int ) {
        
        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
        let orkTextQuestionResultArray = orkStepResult?.results
        if (orkTextQuestionResultArray != nil) {
            
            let firstResult = orkTextQuestionResultArray?[0]
            let rkScaleResult = firstResult as! ORKScaleQuestionResult
            let numericAnswer = rkScaleResult.scaleAnswer as! Int
            
            destNumber = numericAnswer
        }
    }
    
}

extension ChopSliderQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return base.web_Id }
        set { base.web_Id = newValue }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        
        if webId.isEmpty {
            return
        }
        dictionary[webId] = "\(answer)"
    }
}
