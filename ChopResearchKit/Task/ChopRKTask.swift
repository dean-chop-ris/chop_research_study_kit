//
//  ChopRKTask.swift
//  Camelot
//
//
//  ChopRKTask
//
//  Created by Ritter, Dean on 1/24/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

public class ChopRKTask : ORKNavigableOrderedTask
{
    var errorMessage: String? = nil
    
    init(identifier: String, stepsToInit: ChopModuleStepCollection) {
        
        self.moduleSteps = stepsToInit
        
        super.init(identifier: identifier, steps: moduleSteps.rkSteps)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func navigateSetSkipNextStep(skipFrom: String,
                         onAnswerValue answerValue: Int) -> Bool {

        guard let stepToSkip = moduleSteps.nextStep(fromStepId: skipFrom) else {
            return false
        }
        
        guard let stepAfterSkippedStep = moduleSteps.nextStep(fromStepId: (stepToSkip.stepId)) else {
            return false
        }
        
        return navigateSetSkip(skipFrom: skipFrom,
                               onAnswerValue: answerValue,
                               skipTo: stepAfterSkippedStep.stepId)
    }

    func navigateSetSkip(skipFrom: String,
                         onAnswerValue answerValue: Int,
                         skipTo: String) -> Bool {
        
        let predicateOther = ORKResultPredicate.predicateForChoiceQuestionResult(
                  with: ORKResultSelector(resultIdentifier: skipFrom),
                  expectedAnswerValue: answerValue as (NSCoding & NSCopying & NSObjectProtocol))
        let predicateNotOther = NSCompoundPredicate(notPredicateWithSubpredicate: predicateOther)
        let rule = ORKPredicateStepNavigationRule(
            resultPredicatesAndDestinationStepIdentifiers: [(predicateNotOther, skipTo)])
        
        self.setNavigationRule(rule, forTriggerStepIdentifier: skipFrom)

        return true
    }
    
    func navigateSetSurveyStepDisplayRule(forStepIdToDisplay stepIdToDisplay: String, onlyIfStepIdIsValid stepIdToValidate: String) {
        
        let rule = SurveyStepDisplayRule(stepToDisplay: stepIdToDisplay, stepToValidate: stepIdToValidate)
        
        surveyStepDisplayRules += [rule]
    }
    
    func shouldPresent(stepIdToPresent: String, givenResult result: ORKTaskResult) -> Bool {

        for rule in surveyStepDisplayRules {

            if rule.stepToDisplay != stepIdToPresent {
                continue
            }

            let stepToValidate = moduleSteps.findStep(withId: rule.stepToValidate)
            
            if (stepToValidate == nil) || (stepToValidate is AbleToBeValidated) == false {
                continue
            }
        
            let validatableStep = stepToValidate as! AbleToBeValidated
            
            if validatableStep.bypassValidation {
                continue
            }
 
            var errMsg: String = ""
            let isValid = validatableStep.isValid(givenResult: result, errorMessageToReturn: &errMsg)
            
            errorMessage = errMsg
            return isValid
        }
        
        return true
    }
    
/*
    func makeShortWalkTask() {
        let options = ORKPredefinedTaskOption()
        
        let task = ORKOrderedTask.shortWalk(withIdentifier: "ShortWalk", intendedUseDescription: "Test", numberOfStepsPerLeg: 5, restDuration: 10, options: options)
    }
 */
//
//    func signatureCollectionResult(forQuestionStep stepIdentifier: String, from result: ORKTaskResult) -> ChopRKSignatureCollectionResult {
//        
//        let stepResult = result.stepResult(forStepIdentifier: stepIdentifier)
//        let questionResult = stepResult?.results /* ORKChoiceQuestionResult []? */
//        
//        let result = questionResult?.first
//        let sigResult = result as! ORKConsentSignatureResult
//        let sig = sigResult.signature // ORKConsentSignature
//
//        var chopResult = ChopRKSignatureCollectionResult()
//        
//        chopResult.firstName = sig?.givenName
//        chopResult.lastName = sig?.familyName
//        chopResult.signature = sig?.signatureImage
//
//        return chopResult
//    }

    private var moduleSteps: ChopModuleStepCollection
    private var surveyStepDisplayRules = [SurveyStepDisplayRule]()
}

struct ChopRKSignatureCollectionResult {
    var firstName: String?
    var lastName: String?
    var signature: UIImage?
}

struct SurveyStepDisplayRule {
    var stepToDisplay: String
    var stepToValidate: String
}
















