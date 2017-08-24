//
//  ChopPhoneNumberQuestion.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/16/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopPhoneNumberQuestion {
    
    // Validation Error Messages
    static let VEM_TEN_DIGITS = "Phone number must be 10 digits long"
    
    var answer: String {
        
        return _answer
    }
    
    init(withStepID stepID: String,
         withWebId webIdentifier: String,
         withTitle title: String) {
        
        let answerFormat = ORKTextAnswerFormat()
        
        rkStep = ORKQuestionStep(identifier: stepID, title: title, answer: answerFormat)
        
        base.web_Id = webIdentifier
    }
    
    // The answer is held as a string of just the digits (e.g. "2125551212")
    fileprivate var _answer = ""
    fileprivate var rkStep: ORKStep
    fileprivate var base = ChopRKTaskStepBase()
}


extension ChopPhoneNumberQuestion: ChopRKTaskStep {
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

extension ChopPhoneNumberQuestion: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return rkStep.identifier } }
}

extension ChopPhoneNumberQuestion: AbleToBeValidated {
    // MARK: : AbleToBeValidated
    var isAnswerValid: Bool {
    
        var errMsg = ""
        
        return isAnswerValid(dataToValidate: _answer, errorMsg: &errMsg)
    }
    
    var errorMessage: String { get { return isAnswerValid ? "" : ChopPhoneNumberQuestion.VEM_TEN_DIGITS } }
    
    var validationActive: Bool { return true }
    
    var bypassValidation: Bool {
        get { return base.validation.bypass_Validation }
        set { base.validation.bypass_Validation = newValue }
    }
    
    func isValid(givenResult result: ORKTaskResult, errorMessageToReturn: inout String) -> Bool {
        
        var answerToValidate = ""
        
        captureResult(fromORKTaskResult: result, andPutInto: &answerToValidate)
        
        return isAnswerValid(dataToValidate: answerToValidate,
                             errorMsg: &errorMessageToReturn)
    }
    
    private func isAnswerValid(dataToValidate: String, errorMsg: inout String) -> Bool {
        var is_answer_valid = true
        
        let dataToValidate_digits = dataToValidate.digitsOnly()
        
        if dataToValidate_digits.length != 10 {
            
            is_answer_valid = false
            errorMsg = ChopPhoneNumberQuestion.VEM_TEN_DIGITS
        }
        
        return is_answer_valid
    }
}



extension ChopPhoneNumberQuestion: HasModuleStepDataToCapture {
    // MARK: HasModuleStepDataToCapture
    
    mutating func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult) {

        captureResult(fromORKTaskResult: orkTaskResult, andPutInto: &_answer)
    }
    
    fileprivate func captureResult(fromORKTaskResult orkTaskResult: ORKTaskResult, andPutInto destString: inout String ) {
        
        let orkStepResult = orkTaskResult.stepResult(forStepIdentifier: self.stepId)
        let orkTextQuestionResultArray = orkStepResult?.results
        if (orkTextQuestionResultArray != nil) {
            
            let firstResult = orkTextQuestionResultArray?[0]
            let rkRawTextResult = firstResult as! ORKTextQuestionResult
            let rawTextAnswer = rkRawTextResult.textAnswer!
            
            destString = rawTextAnswer.digitsOnly()
        }
    }
}

extension ChopPhoneNumberQuestion: GeneratesWebRequestData {
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
        
        dictionary[webId] = formatter.formatTelephoneNumberForSubmission(phoneNumberToFormat: answer)
    }
}

extension String {
    
    var isNotEmpty: Bool {
        return self.isEmpty == false
    }
    
    var length : Int {
        return self.characters.count
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func substring(startIndex: Int) -> String {

        return substring(startIndex: startIndex,
                         len: self.length - startIndex)
    }

    func substring(startIndex: Int, len: Int ) -> String {
        
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let numCharsFromEnd = self.length - (startIndex + len - 1)
        let end = self.index(self.endIndex, offsetBy: -1 * numCharsFromEnd)
        let range = start..<end
        
        return self.substring(with: range)
    }
    
    func digitsOnly() -> String{
        
        let stringArray = self.components(separatedBy:
            CharacterSet.decimalDigits.inverted)
        let newString = stringArray.joined(separator: "")
        
        return newString
    }
    
}
