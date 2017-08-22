//
//  RedcapSurveyManager.swift
//  Test_RedcapSurvey_1
//
//  Created by Ritter, Dean on 7/20/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit


struct RedcapSurveyManager {

    var isLoaded: Bool {
        get { return items.isEmpty == false }
    }

    var surveySubmissionWebRequestParmeters: ChopWebRequestParameters {
        
        var params = ChopWebRequestParameters()
        
        params.load(moduleSteps: moduleSteps)
        
        return params
    }
    
    public private(set) var rkSurveyTask : ChopRKTask!

    init(token: String, redcapInstrumentName: String) {
        
        redcapToken = token
        redcapFormName = redcapInstrumentName
    }
    
    func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController {
        
        if isLoaded == false {
            let loaderViewController = RedcapSurveyLoaderViewController()
            
            loaderViewController.requestor = self
            
            return loaderViewController
            
        } else {
            let taskViewController = ChopRKTaskViewController(
                type: ChopResearchStudyModuleTypeEnum.Survey,
                task: rkSurveyTask,
                taskRun: nil)
            
            taskViewController.delegate = delegate
            
            return taskViewController
        }
    }
    
    mutating func load(redcapItems: RedcapSurveyItemCollection) {
        
        items = redcapItems.filter(instrumentName: redcapFormName)
        generateSurveyTask()
    }

    mutating func extract(fromResponse response: ChopWebRequestResponse) {
        
        items.loadFromJSON(data: response.data, forInstrumentName: self.redcapFormName)
        generateSurveyTask()
    }

    mutating func generateSurveyTask() {

        if items.containsRecordIdField == false {
            //////////////////////////////////////////////////////////////////////
            // Record Id
            //////////////////////////////////////////////////////////////////////
            var recordId = ChopModuleDataPointCollected(
                withDescription: "RecordId",
                andStepId: "RecordId",
                andWebId: "record_id")
            
            recordId.collectString(stringToCollect: NSUUID().uuidString)
            
            if moduleSteps.add(element: recordId) == false {
                return
            }
        }
        
        //////////////////////////////////////////////////////////////////////
        // Survey Questions (from REDCap items)
        //////////////////////////////////////////////////////////////////////
        var currentMatrixGroupName = ""
        var currentMatrixGroup = RedcapSurveyItemCollection()
        var moduleStep: ChopResearchStudyModuleStep? = nil
        var newGroup = false
        
        for item in items {
            newGroup = false
            moduleStep = nil
            
            if item.generatesValidModuleStep == false {
                continue
            }

            if item.matrixGroupName.isEmpty == false {
                if currentMatrixGroupName.isEmpty == false {
                    // item has group name, and there is a current group
                    
                    if item.matrixGroupName == currentMatrixGroupName {
                        // items group is the same as current
                        currentMatrixGroup.add(item: item)
                    } else {
                        // items group is a different group
                        moduleStep = createModuleStep(redcapItems: currentMatrixGroup)
                        newGroup = true
                    }
                }
                else {
                    // item has group name, but no current group name
                    newGroup = true
                }
            } else {
                if currentMatrixGroupName.isEmpty == false {
                    // item has no group name, but there is a current group name
                    
                    // create a step for the finished group
                    moduleStep = createModuleStep(redcapItems: currentMatrixGroup)
                    
                    if moduleSteps.add(element: moduleStep!) == false {
                        return
                    }
                    newGroup = true
                }
                
                // item has no group name, create a step for this item
                moduleStep = item.generateModuleStep()
            }
            
            if newGroup {
                currentMatrixGroupName = item.matrixGroupName
                currentMatrixGroup.removeAll()
                currentMatrixGroup.add(item: item)
            }
            
            if moduleStep != nil {
                if moduleSteps.add(element: moduleStep!) == false {
                    return
                }
            }
        }
        
        //////////////////////////////////////////////////////////////////////
        // Summary Step
        //////////////////////////////////////////////////////////////////////
        let completionStep = ChopSurveyCompletionStep(withStepID: "Completion Step",
                                                      withTitle: "Survey Complete",
                                                      withText: "Thank you for taking the time to share your thoughts and opinions with us!")
        
        if moduleSteps.add(element: completionStep) == false {
            return
        }
        
        rkSurveyTask = ChopRKTask(identifier: "SurveyTask",
                                  stepsToInit: moduleSteps)
        
        //////////////////////////////////////////////////////////////////////
        // Navigation Setup: Local Validation
        //////////////////////////////////////////////////////////////////////
        
        for step in moduleSteps {
            
            if step is AbleToBeValidated {
                
                let validatableStep = step as! AbleToBeValidated
                
                if validatableStep.bypassValidation {
                    continue
                }
                
                if validatableStep.validationActive {
                    let nextStep = moduleSteps.nextStep(fromStepId: step.stepId)

                    rkSurveyTask.navigateSetSurveyStepDisplayRule(
                        forStepIdToDisplay: (nextStep?.stepId)!,
                        onlyIfStepIdIsValid: step.stepId)
                }
            }
            
            
        }
    }

    func createModuleStep(redcapItems: RedcapSurveyItemCollection) -> ChopResearchStudyModuleStep {
        /*
        let fieldType = redcapItems.first.fieldType
        
        if fieldType == "radio" {
            return createRankingQuestionModuleStep(redcapItems: redcapItems)
        } else if fieldType == "checkbox" {
            return createMatrixQuestionModuleStep(redcapItems: redcapItems)
        } else {
            print("Error: unknown grouped field type: \(fieldType))")
        }
        
        return createMatrixQuestionModuleStep(redcapItems: redcapItems)
        */
        var sectionHeader = ""
        var matrixGroupName = ""
        var isMultipleAnswer = false
        var selectChoiceCollection = ChopItemSelectChoiceCollection()
        var rows = [ChopMatrixQuestionRow]()
        
        for item in redcapItems {
            if sectionHeader.isEmpty {
                sectionHeader = item.sectionHeader
                matrixGroupName = item.matrixGroupName

                if item.fieldType == "checkbox" {
                    isMultipleAnswer = true
                } else if item.fieldType == "radio" {
                    isMultipleAnswer = false
                } else {
                    print("ERROR: unknown grouped field type: \(item.fieldType))")
                }

                let parser = RedcapSelectChoiceParser()
                selectChoiceCollection = parser.parseSelectChoices(choicesAsStr: item.selectChoicesOrCalculations)
            }
            let row = ChopMatrixQuestionRow(
                withWebId: item.fieldName,
                withItemId: item.fieldName,
                withDisplayString: item.fieldLabel)
            rows += [row]
        }
        return ChopMatrixQuestion(withStepID: matrixGroupName,
                                  withWebId: matrixGroupName,
                                  withQuestion: sectionHeader,
                                  allowsMultipleAnswers: isMultipleAnswer,
                                  withItems: rows,
                                  withQuestionChoices: selectChoiceCollection)
    }
    
    func createMatrixQuestionModuleStep(redcapItems: RedcapSurveyItemCollection) -> ChopResearchStudyModuleStep {

        var sectionHeader = ""
        var matrixGroupName = ""
        var selectChoiceCollection = ChopItemSelectChoiceCollection()
        var rows = [ChopMatrixQuestionRow]()

        for item in redcapItems {
            if sectionHeader.isEmpty {
                sectionHeader = item.sectionHeader
                matrixGroupName = item.matrixGroupName

                let parser = RedcapSelectChoiceParser()
                selectChoiceCollection = parser.parseSelectChoices(choicesAsStr: item.selectChoicesOrCalculations)
            }
            let row = ChopMatrixQuestionRow(
                withWebId: item.fieldName,
                withItemId: item.fieldName,
                withDisplayString: item.fieldLabel)
            rows += [row]
        }
        return ChopMatrixQuestion(withStepID: matrixGroupName,
                                  withWebId: matrixGroupName,
                                  withQuestion: sectionHeader,
                                  allowsMultipleAnswers: true,
                                  withItems: rows,
                                  withQuestionChoices: selectChoiceCollection)
    }

    func createRankingQuestionModuleStep(redcapItems: RedcapSurveyItemCollection) -> ChopResearchStudyModuleStep {
        
        var rankingItems = [ChopRankingItem]()
        var matrixGroupName = ""
        var sectionHeader = ""
         
        for item in redcapItems {
            
            if sectionHeader.isEmpty {
                sectionHeader = item.sectionHeader
                matrixGroupName = item.matrixGroupName
            }
            rankingItems += [ChopRankingItem(withWebId: item.fieldName,
                                             withItemId: item.fieldName,
                                             withDisplayString: item.fieldLabel)]
        }
        
        return ChopRankingQuestion(withStepID: matrixGroupName,
                                   withQuestion: sectionHeader,
                                   withItems: rankingItems)
    }

    mutating func captureResults(withResult taskResult: ORKTaskResult) {
        
        moduleSteps.captureResults(withResult: taskResult)
    }

    private var items = RedcapSurveyItemCollection()
    private var redcapFormName: String
    fileprivate var moduleSteps = ChopModuleStepCollection()
    fileprivate var redcapToken: String
}


extension RedcapSurveyManager: ChopWebRequestSource {
    // MARK: ChopWebRequestSource
    
    var destinationUrl: String
    {
        get
        {
            return "https://redcap.chop.edu/api/"
        }
    }
    
    var headerParamsDictionary: Dictionary<String, String> {
        
        get {
            var params = ChopWebRequestParameters()
            
            params.load(key: "token", value: redcapToken)
            params.load(key: "content", value: "metadata")
            params.load(key: "format", value: "json")
            params.load(key: "returnFormat", value: "json")
            
            return params.postDictionary
        }
    }
    
    var payloadParamsDictionary: Dictionary<String, String> {  // A dictionary of JSON keys/values
        
        
        get {
            let params = ChopWebRequestParameters()
            
            return params.postDictionary
        }
    }

}
