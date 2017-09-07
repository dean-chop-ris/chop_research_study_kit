//
//  ChopResearchStudyViewController.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/30/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import UIKit

class ChopResearchStudyViewController: UIViewController {
    
    // Segue Id's
    static let SID_ONBOARDING = "toOnboarding"
    static let SID_STUDY = "toStudy"
    
    // View Controller Id's
    static let VCID_STUDY = "ChopStudyViewController"

    var contentHidden = false {
        didSet {
            guard contentHidden != oldValue && isViewLoaded else { return }
            childViewControllers.first?.view.isHidden = contentHidden
        }
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
        //    toStudy()
        //}
        //else {
        //    toOnboarding()
        //}
    }

    
    func execute(workflowActionType: ChopWorkflowActionTypeEnum) {
        
        var action = ChopWorkflowAction()
        
        action.actionType = workflowActionType
        
        execute(workflowAction: action)
    }

    func execute(workflowAction: ChopWorkflowAction) {
        
        // execute action
        switch workflowAction.actionType {

        case ChopWorkflowActionTypeEnum.UserMessage:
            let title = workflowAction.hasUserMessage
                            ? workflowAction.userMessageTitle
                            : "Alert"
            let msg = workflowAction.hasUserMessage
                            ? workflowAction.userMessage
                            : "Unknown Message"
            let alert = ChopUIAlert(forViewController: self,
                                    withTitle: title,
                                    andMessage: msg)
            
            alert.show()
            break

        case ChopWorkflowActionTypeEnum.ToStudy:
            print("ChopResearchStudyViewController: Segue to Study")
            
            //performSegue(withIdentifier: ChopResearchStudyViewController.SID_STUDY, sender: self)
            let storyboard = self.storyboard!
            let vc = storyboard.instantiateViewController(
                withIdentifier: ChopResearchStudyViewController.VCID_STUDY)
                    as! ChopResearchStudyViewController
            
            vc.study = study
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
            
            break
        case ChopWorkflowActionTypeEnum.ToOnboarding:
            /*
             let alert = ChopUIAlert(forViewController: self,
             withTitle: "Workflow",
             andMessage: "Going to Onboarding")
             
             alert.show()
             */
            performSegue(withIdentifier: ChopResearchStudyViewController.SID_ONBOARDING, sender: self)
            break
            
        default:
            let alert = ChopUIAlert(forViewController: self,
                                    withTitle: "Workflow",
                                    andMessage: "No action specified")
            
            alert.show()
            break
        }
    }

    // MARK: Unwind segues
    
    @IBAction func unwind_GoToStudy(_ segue: UIStoryboardSegue) {
        toStudy()
    }
    
    @IBAction func unwind_GoToWithdrawl(_ segue: UIStoryboardSegue) {
        toWithdrawl()
    }
    
    // MARK: Transitions
    
    func toOnboarding() {
        //performSegue(withIdentifier: "toOnboarding", sender: self)
        execute(workflowActionType: ChopWorkflowActionTypeEnum.ToOnboarding)
    }
    
    func toStudy() {
        //performSegue(withIdentifier: "toStudy", sender: self)
        execute(workflowActionType: ChopWorkflowActionTypeEnum.ToStudy)
    }
    
    func toWithdrawl() {
        /*
 
        See ORKSample for implementation
 
        let viewController = WithdrawViewController()
        viewController.delegate = self
        
        present(viewController, animated: true, completion: nil)
        
        */
    }

    func topMostController() -> UIViewController {
        
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        
        return topController
    }
    
    fileprivate lazy var _study: ChopResearchStudy = {
        return ChopResearchStudy(initWorkflow: ChopDefaultWorkflow())
    }()
}

extension ChopResearchStudyViewController: HoldsAChopStudy {
    // MARK: HoldsAChopStudy
    
    var study: ChopResearchStudy {
        get {
            return _study
        }
        
        set {
            _study = newValue
        }
    }
    
}


class ChopDefaultWorkflow : ChopResearchStudyWorkflow {
    
}
