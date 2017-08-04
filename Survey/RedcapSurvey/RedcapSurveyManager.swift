//
//  RedcapSurveyManager.swift
//  Test_RedcapSurvey_1
//
//  Created by Ritter, Dean on 7/20/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import UIKit


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

    init(redcapInstrumentName: String) {
        
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
    

    mutating func extract(fromResponse response: ChopWebRequestResponse) {
        
        items.loadFromJSON(data: response.data, forInstrumentName: self.redcapFormName)
        
        
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
        

        var currentMatrixGroupName = ""
        var currentMatrixGroup = RedcapSurveyItemCollection()
        var moduleStep: ChopResearchStudyModuleStep? = nil
        var newGroup = false
        
        for item in items {
            newGroup = false
            moduleStep = nil

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
                moduleStep = item.moduleStep
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
    }

    func createModuleStep(redcapItems: RedcapSurveyItemCollection) -> ChopResearchStudyModuleStep {
        
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
    
    private var items = RedcapSurveyItemCollection()
    private var redcapFormName: String
    fileprivate var moduleSteps = ChopModuleStepCollection()
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
            
            params.load(key: "token", value: "6888B142F5AC0578AB6F605E549E1C44")
            params.load(key: "content", value: "metadata")
            params.load(key: "format", value: "json")
            params.load(key: "returnFormat", value: "json")
            
//            params.load(key: "action", value: "import")
//            params.load(key: "type", value: "flat")
//            params.load(key: "overwriteBehavior", value: "overwrite")
            
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
