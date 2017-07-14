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

    
    func executeWorkflowAction(actionType: ChopWorkflowActionTypeEnum) {
        var action = ChopWorkflowAction()
        
        action.actionType = actionType
        
        executeWorkflowAction(action: action)
    }

    func executeWorkflowAction(action: ChopWorkflowAction) {
        
        // execute action
        switch action.actionType {
        case ChopWorkflowActionTypeEnum.ToStudy:
            //            let alert = ChopUIAlert(forViewController: self,
            //                                    withTitle: "Workflow",
            //                                    andMessage: "Going to Study")
            //
            //            alert.show()
            performSegue(withIdentifier: ChopResearchStudyViewController.SID_STUDY, sender: self)
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
        executeWorkflowAction(actionType: ChopWorkflowActionTypeEnum.ToOnboarding)
    }
    
    func toStudy() {
        //performSegue(withIdentifier: "toStudy", sender: self)
        executeWorkflowAction(actionType: ChopWorkflowActionTypeEnum.ToStudy)
    }
    
    func toWithdrawl() {
        /*
 
        See ORKSample for implementation
 
        let viewController = WithdrawViewController()
        viewController.delegate = self
        
        present(viewController, animated: true, completion: nil)
        
        */
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
