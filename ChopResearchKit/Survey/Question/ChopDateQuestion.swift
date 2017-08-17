//
//  ChopDateQuestion.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/16/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopDateQuestion {
    
    var answer: Date {
        
        return _answer
    }
    
    init(withStepID stepID: String,
         withWebId webIdentifier: String,
         withTitle title: String) {
        
        let answerFormat = ORKDateAnswerFormat(style: ORKDateAnswerStyle.date)
        
        rkStep = ORKQuestionStep(identifier: stepID, title: title, answer: answerFormat)
        
        base.web_Id = webIdentifier
    }
    
    fileprivate var _answer = Date()
    fileprivate var rkStep: ORKStep
    fileprivate var base = ChopRKTaskStepBase()
}

extension ChopDateQuestion: ChopRKTaskStep {
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

extension ChopDateQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
}

extension ChopDateQuestion: AbleToBeValidated {
    // MARK: : AbleToBeValidated
    var errorMessage: String { get { return base.validation.errMsg } }
    var bypassValidation: Bool {
        get { return base.validation.bypass_Validation }
        set { base.validation.bypass_Validation = newValue }
    }
}

extension ChopDateQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {
        
        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
        let orkTextQuestionResultArray = orkStepResult?.results
        if (orkTextQuestionResultArray != nil) {
            
            let firstResult = orkTextQuestionResultArray?[0]
            let dateResult = firstResult as! ORKDateQuestionResult
            _answer = dateResult.dateAnswer!
        }
    }
    
}

extension ChopDateQuestion: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return base.web_Id }
        set { base.web_Id = newValue }
    }
    
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        
        if webId.isEmpty {
            return
        }
        
        let formatter = RedcapImportDataFormatter(forClient: self)
        
        dictionary[webId] = formatter.formatDateForSubmission(dateToFormat: _answer)
    }
}
