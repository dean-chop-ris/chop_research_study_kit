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

enum ShouldPresentResultEnum {
    case NO
    case YES
    case PASSCODE
}

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
        
        let rule = SurveyStepDisplayRule(stepToDisplay: stepIdToDisplay,
                                         validationType: ValidationTypeEnum.ValidStep,
                                         stepToValidate: stepIdToValidate)
        
        surveyStepDisplayRules += [rule]
    }
    
    func shouldPresent(stepIdToPresent: String, givenResult result: ORKTaskResult) -> ShouldPresentResultEnum {

        for rule in surveyStepDisplayRules {

            if rule.stepToDisplay != stepIdToPresent {
                continue
            }

            if rule.validationType == ValidationTypeEnum.ValidStep {
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
                return isValid ? ShouldPresentResultEnum.YES : ShouldPresentResultEnum.NO
            }
            
            //if rule.validationType == ValidationTypeEnum.Passcode {
            
                
            //    return ShouldPresentResultEnum.PASSCODE
            //}
        }
   
        //
        // Passcode Verification
        //
        
        let stepToDisplay = moduleSteps.findStep(withId: stepIdToPresent)
        
        if stepToDisplay is ChopWaitStep {
            let waitStep = stepToDisplay as! ChopWaitStep
            
            if waitStep.reason == WaitReasonEnum.PasscodeVerification {
                
                return ShouldPresentResultEnum.PASSCODE
            }
        }
        
        return ShouldPresentResultEnum.YES
    }

    func addPasscodeSecurity(forStepId passcodeProtectedStepId: String) -> Bool {
        /*
        guard let previousStep = moduleSteps.previousStep(fromStepId: passcodeProtectedStepId) else {
            
            return false
        }
        
        let rule = SurveyStepDisplayRule(
            stepToDisplay: passcodeProtectedStepId,
            validationType: ValidationTypeEnum.Passcode,
            stepToValidate: previousStep.stepId)

        surveyStepDisplayRules += [rule]
        
        // Insert a Wait step just before the step protected by passcode
        // so that RK can move past the previous step, but not proceed
        // to the passcoded step
        let waitStepId = previousStep.stepId + "__WAIT"
        let waitStep = ChopWaitStep(withStepID: waitStepId, withTitle: "Please wait", withText: "Verifying Passcode")
        
        let result = moduleSteps.insert(element: waitStep,
                                        afterStepId: previousStep.stepId)

        
        return result
 */
        return true
    }

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

//struct ChopRKSignatureCollectionResult {
//    var firstName: String?
//    var lastName: String?
//    var signature: UIImage?
//}

enum ValidationTypeEnum {
    case Passcode
    case ValidStep
}


struct SurveyStepDisplayRule {
    var stepToDisplay: String
    var validationType: ValidationTypeEnum
    var stepToValidate: String
}
















