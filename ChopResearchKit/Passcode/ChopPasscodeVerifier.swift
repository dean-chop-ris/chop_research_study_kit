//
//  ChopPasscodeVerifier.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/22/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

//
// This object needs to be a class to implement ORKPasscodeDelegate protocol
//
class ChopPasscodeVerifier: NSObject {
    init(containerViewController: PasscodeClientViewController) {
        self.containerVC = containerViewController
        super.init()
    }
    
    func verify() -> Bool {
        var okToContinue = true
        
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            passcodeVC = ORKPasscodeViewController.passcodeAuthenticationViewController(withText: "Upon success, you'll go to the next step", delegate: self)
            
            containerVC.present(passcodeVC!, animated: false, completion: nil)
            containerVC.contentHidden = true
            okToContinue = true
        } else {
            let alert = ChopUIAlert(forViewController: containerVC as! UIViewController, withTitle: "Error", andMessage: "Passcode needed, but not created.")
            
            alert.show()
            okToContinue = false
        }
        
        return okToContinue
    }
    
    fileprivate var containerVC: PasscodeClientViewController
    fileprivate var passcodeVC: ORKPasscodeViewController?
}

extension ChopPasscodeVerifier: ORKPasscodeDelegate {
    
    // MARK: ORKPasscodeDelegate
    func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        containerVC.contentHidden = false
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
    }
   
    
}

protocol PasscodeClientViewController {
    var contentHidden: Bool { get set }
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)

}
