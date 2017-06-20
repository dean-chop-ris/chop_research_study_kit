//
//  ChopResearchStudy.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 2/6/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

public enum ChopResearchStudyModuleTypeEnum {
    case Login
    case Consent
    case Survey
    case ShortWalkActiveTask
}

// In order to implement ORKTaskViewControllerDelegate, 
// ChopResearchStudy must implement NSObjectProtocol,
// and it is impractical to implement implement NSObjectProtocol
// any way except deriving a class from NSObject.
// We may separate the delegate to another object in order to 
// change ChopResearchStudy to a struct, but somewhere down the
// line we'll have to derive some class from NSObject in order to
// implement ORKTaskViewControllerDelegate
class ChopResearchStudy: NSObject {

    
    func getFile1() -> String {
        //let moduleInfo = modules[ChopResearchStudyModuleTypeEnum.ShortWalkActiveTask]
        //let shortWalkTask = moduleInfo?.module as! PSA_ShortWalkActiveTask
        
        return "Unkown"
    }

    func createModuleViewController(type taskType: ChopResearchStudyModuleTypeEnum) -> UIViewController {
        
        return createModuleViewController(type: taskType, options: nil)
    }

    func createModuleViewController(type taskType: ChopResearchStudyModuleTypeEnum, options: ChopResearchStudyModuleOptions?) -> UIViewController {
        
        var module = modules[taskType]?.module
        
        if options != nil {
            module?.setOptions(options: options!)
            modules[taskType]?.module = module!
        }
        
        let viewController = module?.createModuleViewController(delegate: self)
        
        modules[taskType]?.viewController = viewController
        
        return viewController!
    }
    
    func add(moduleType: ChopResearchStudyModuleTypeEnum, moduleToAdd: ChopResearchStudyModule) {
        
        //modules[moduleType] = moduleToAdd
        modules[moduleType] = ModuleInformation(module: moduleToAdd)
    }
    
    //fileprivate var modules: [ChopResearchStudyModuleTypeEnum:ChopResearchStudyModule] = [:]
    fileprivate var modules: [ChopResearchStudyModuleTypeEnum:ModuleInformation] = [:]
    private var dataStore: ChopDataStore = ChopDataStore()
}

extension ChopResearchStudy : ORKTaskViewControllerDelegate {
    // MARK: Ex: ORKTaskViewControllerDelegate
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        let chopTaskViewController = taskViewController as! ChopRKTaskViewController
        var moduleInfo = modules[chopTaskViewController.taskType]!

        if reason == ORKTaskViewControllerFinishReason.completed {

            var module: ChopResearchStudyModule = moduleInfo.module
            
            module.onFinish(withResult: taskViewController.result);
            
            if module is ChopWebRequestSource {
                let request = ChopWebRequest(withSource: module as! ChopWebRequestSource)                
                let broker = ChopWebRequestBroker(dataStoreClient: self)

                broker.send(request: request)
            }
        }
        else if reason != ORKTaskViewControllerFinishReason.discarded {
            
            let alert = ChopUIAlert(forViewController: taskViewController,
                                    withTitle: "Error",
                                    andMessage: "Task Ended: " + error.debugDescription)
            
            alert.show()
            
        }
        taskViewController.dismiss(animated: true, completion: nil)
        moduleInfo.viewController = nil
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, shouldPresent step: ORKStep) -> Bool {

        guard let orkTask = taskViewController.task else {
            return true
        }
        var shouldPresent: Bool = true

        for chopModuleInfo in modules.values {
            let chopModule = chopModuleInfo.module
            
            if chopModule.identifier == orkTask.identifier {

                shouldPresent = chopModule.shouldPresentStep(
                    stepIdToPresent: step.identifier,
                    givenResult: taskViewController.result)
                
                if shouldPresent == false {
                    
                    sendUserMessage(forClientWithId: chopModule.identifier, title: "Error", message: chopModule.errorMessage)
                    /*
                    // The user provided invalid input
                    let alert = ChopUIAlert(forViewController: taskViewController,
                                            withTitle: "Error",
                                            andMessage: chopModule.errorMessage)
                    
                    alert.show()
                    */
                }
            }
        }
        
        
        return shouldPresent
    }
}

// Currently this protocol has no members. But I suspect it will
// be needed sometime in the future so I am leaving it in place
extension ChopResearchStudy : ChopWebDataStoreClient {
// MARK: : ChopWebDataStoreClient
    func populateWebRequestParamsDictionary(dictionary: inout Dictionary<String, String>) {
        
        // Moved to client-specific code
//        dictionary["token"] = "6888B142F5AC0578AB6F605E549E1C44"
//        dictionary["content"] = "record"
//        dictionary["format"] = "json"
//        dictionary["action"] = "import"
//        dictionary["type"] = "flat"
//        dictionary["overwriteBehavior"] = "overwrite"
        
        
    }
    
    
}


extension ChopResearchStudy: ChopResearchStudyModuleClient {
    
    func sendUserMessage(forClientWithId clientId: String, title: String, message: String) {
        for chopModuleInfo in modules.values {
            let chopModule = chopModuleInfo.module
            
            if chopModule.identifier == clientId {
                
            let alert = ChopUIAlert(forViewController: chopModuleInfo.viewController!,
                                            withTitle: title,
                                            andMessage: message)
                    
                    alert.show()
            }
        }
    }
}




struct ModuleInformation {
    
    init(module: ChopResearchStudyModule) {
        self.module = module
        self.viewController = nil
    }
    
    var module: ChopResearchStudyModule
    var viewController: UIViewController?
}
