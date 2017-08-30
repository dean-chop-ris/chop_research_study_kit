//
//  ChopResearchStudy.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 2/6/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

typealias LoadRequestResponse = (String, ChopWebRequestResponse, NSError?) -> Void
typealias ModuleCompleteCallback = (ChopWorkflowAction) -> Void
typealias WebRequestResponseRecievedCallback = (ChopWebRequestResponse) -> Void

public enum ChopResearchStudyModuleTypeEnum {
    case Login
    case Consent
    case Survey
    case ShortWalkActiveTask
    case TappingIntervalTask
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

    var initialWorkflowAction: ChopWorkflowAction {
        
        get {
            var action = ChopWorkflowAction()
            
            action.actionType = ChopWorkflowActionTypeEnum.ToOnboarding
            
            return action
        }
    }
    
    init(initWorkflow: ChopResearchStudyWorkflow) {
        self.workflow = initWorkflow
    }
    
    func registerContainingViewController(onModuleComplete: @escaping ModuleCompleteCallback) {
        
        onModuleCompleteCallback = onModuleComplete

        for var chopModuleInfo in modules.values {
            chopModuleInfo.module.moduleCompleteCallback = onModuleCompleteCallback
        }
   }

   func add(moduleType: ChopResearchStudyModuleTypeEnum, moduleToAdd: ChopResearchStudyModule) {

        modules[moduleType] = ModuleInformation(module: moduleToAdd)
    }
    
    var isLoaded: Bool {
        
        return false
    }

    func load(options: Int, onCompletion: @escaping LoadRequestResponse) {
        
    }

    func loadRedcapItems(redcapItemsProvider: RedcapItemsProvider) {
        
        for key in modules.keys {
            if (modules[key]?.module.loadsRedcapItems)! {
                modules[key]?.module.loadRedcapItems(provider: redcapItemsProvider)
            }
        }
    }

    func createModuleViewController(type taskType: ChopResearchStudyModuleTypeEnum) -> UIViewController {
        
        return createModuleViewController(type: taskType, options: nil)
    }

    func setModuleOptions(type taskType: ChopResearchStudyModuleTypeEnum,
                          options: ChopResearchStudyModuleOptions?) {
        
        if options != nil {
            var module = modules[taskType]?.module

            module?.setOptions(options: options!)
            modules[taskType]?.module = module!
        }
    }

    func createModuleViewController(type moduleType: ChopResearchStudyModuleTypeEnum,
                                    options: ChopResearchStudyModuleOptions?) -> UIViewController {
        
        setModuleOptions(type: moduleType, options: options)
        
        let viewController = modules[moduleType]?.module.createModuleViewController(delegate: self)
        
        modules[moduleType]?.viewController = viewController
        
        return viewController!
    }
    
    func processWebResponse(response: ChopWebRequestResponse) {

        for key in modules.keys {
            
            if (modules[key]?.module.canProcess(response: response))! {
                
                modules[key]?.module.process(response: response)
            }
        }

    }

    
    var onModuleCompleteCallback: ModuleCompleteCallback? = nil
    
    fileprivate var modules: [ChopResearchStudyModuleTypeEnum:ModuleInformation] = [:]
    private var dataStore: ChopDataStore = ChopDataStore()
    fileprivate var passcodeManager = PasscodeManager()
    private var workflow: ChopResearchStudyWorkflow
}

extension ChopResearchStudy : ORKTaskViewControllerDelegate {
    // MARK: Ex: ORKTaskViewControllerDelegate
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        if reason == ORKTaskViewControllerFinishReason.completed {

            var module = getModule(taskViewController: taskViewController)
            
            module.onFinish(withResult: taskViewController.result);
            
            if module is ChopWebRequestSource {
                let request = ChopWebRequest(withSource: module as! ChopWebRequestSource)                
                let broker = ChopWebRequestBroker(dataStoreClient: self)

                broker.send(request: request, onCompletion: { (response, error) in

                        if self.onModuleCompleteCallback != nil {

                            let workflowAction = module.createWorkflowAction(from: response)
                            
                            self.onModuleCompleteCallback!(workflowAction)
                        }
                    }
                )

            }
        }
        else if reason != ORKTaskViewControllerFinishReason.discarded {
            
            let alert = ChopUIAlert(forViewController: taskViewController,
                                    withTitle: "Error",
                                    andMessage: "Task Ended: " + error.debugDescription)
            
            alert.show()
            
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, shouldPresent step: ORKStep) -> Bool {

        var shouldPresent = ShouldPresentResultEnum.YES
        let chopModule = getModule(taskViewController: taskViewController)
        
        shouldPresent = chopModule.shouldPresentStep(
            stepIdToPresent: step.identifier,
            givenResult: taskViewController.result)
                
        if shouldPresent == ShouldPresentResultEnum.NO {
            
            sendUserMessage(forClientWithId: chopModule.identifier, title: "Error", message: chopModule.errorMessage)
        }
        
        if shouldPresent == ShouldPresentResultEnum.PASSCODE {
            // This is the wait step just before the passcoded step.
            // Let it present, but behind the passcode VC
            shouldPresent = ShouldPresentResultEnum.YES

            passcodeManager.verify(withContainingTaskVC: taskViewController)
        }

        return shouldPresent == ShouldPresentResultEnum.YES
    }

    func getModule(type taskType: ChopResearchStudyModuleTypeEnum) -> ChopResearchStudyModule {
        
        let moduleInfo = modules[taskType]!
        
        return moduleInfo.module
    }
    
    private func getModule(taskViewController: ORKTaskViewController) -> ChopResearchStudyModule {
        
        let chopTaskViewController = taskViewController as! ChopRKTaskViewController
        let moduleInfo = modules[chopTaskViewController.taskType]!
        
        return moduleInfo.module
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
    // MARK: ChopResearchStudyModuleClient
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


protocol RedcapItemsProvider {
    
    func getRedcapInstrument(instrumentTitle: String) -> RedcapInstrument
}

