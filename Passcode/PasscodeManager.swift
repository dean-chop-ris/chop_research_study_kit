//
//  PasscodeManager.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/15/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

// In order to implement ORKPasscodeDelegate,
// PasscodeManager must implement NSObjectProtocol,
// and it is impractical to implement implement NSObjectProtocol
// any way except deriving a class from NSObject.
// We may separate the delegate to another object in order to
// change PasscodeManager to a struct, but somewhere down the
// line we'll have to derive some class from NSObject in order to
// implement the delegate
class PasscodeManager: NSObject {

    
    // Passcode Modes
    //
    // Passcode Creation: 
    // 1. Can be done as an optional step in ChopResearchStudyRegistration
    //       called ChopPasscodeStep
    // 2. Stand-alone module?
    //
    // Passcode Enforcement:
    // This is a separate view controller that should be able to be invoked
    //    before any step.
    
    public private(set) var rkPasscodeTask : ChopRKTask!

    
    func implement(options: ChopResearchStudyModuleOptions) -> Bool {
        
        // reset step collection
        moduleSteps = ChopModuleStepCollection()
        
        switch options.passcodeMode {
        //case PasscodeMode.Creation:
        //    impl = ChopPasscodeCreation(withOptions: options)
        //case PasscodeMode.Enforcement:
        //    impl = ChopPasscodeEnforcement(withOptions: options)
        case PasscodeMode.Edit:
            impl = ChopPasscodeEdit(withOptions: options)
        default:
            print("ERROR: case not included: " + options.passcodeMode.rawValue)
            return false
        }
        
        impl?.loadSteps(into: &moduleSteps)
        
        rkPasscodeTask = ChopRKTask(identifier: "Passcode",
                                    stepsToInit: moduleSteps)
        return true
    }

    /* mutating */ func createModuleViewController(delegate: ChopResearchStudy) -> UIViewController {
        
        return /* self.moduleVC = */ (impl?.createModuleViewController(
            delegate: delegate,
            rkTaskToRun: self.rkPasscodeTask))!
        
        //return self.moduleVC!
        
        

    }
    
    func onFinish(withResult taskResult: ORKTaskResult) {
        
        moduleSteps.captureResults(withResult: taskResult)
        
        impl?.onFinish(withResult: taskResult)
    }

    func verify(withContainingTaskVC containerViewController: ORKTaskViewController) {
        
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            
            passcodeViewController = ORKPasscodeViewController.passcodeAuthenticationViewController(withText: "Authenticate Passcode", delegate: self)
            passcodeViewController?.modalPresentationStyle = .fullScreen
            passcodeViewController?.modalTransitionStyle = .coverVertical
            self.rkTaskViewController = containerViewController
            containerViewController.present(passcodeViewController!, animated: false, completion: nil)
        }
        else {
            let alert = ChopUIAlert(forViewController: containerViewController,
                                    withTitle: "No Passcode",
                                    andMessage: "Passcode was not detected. Please inpuit passcode.")
            
            alert.show()
        }
    }
    
    func resetPasscode() {
        resetPasscode(onFirstRun: false)
    }

    func resetPasscode(onFirstRun: Bool) {
        
        var executeReset = true
        
        if onFirstRun {
            
            let standardDefaults = UserDefaults.standard
            if standardDefaults.object(forKey: "ORKSampleFirstRun") != nil {
                executeReset = false
            }
        }
        
        if executeReset {
            ORKPasscodeViewController.removePasscodeFromKeychain()
        }
    }

    //
    // In order to passcode protect app upon entering background:
    //         1. Make the root View Controller a ChopResearchStudyViewController
    //         2. Add a property to AppDelegate to cast window?.rootViewController
    //            as a ChopResearchStudyViewController
    //         3. Add to willFinish: passcodeManager.resetPasscode(onFirstRun: true)
    //         4. Implement PasscodeManager.passcodeProtectApp() (See method for intructions)
    //         5. Implement PasscodeManager.hideForPasscodeProtection() (See method for intructions)
    //
    
    
    func passcodeProtectApp(containerViewController: ChopResearchStudyViewController, applicationWindow: UIWindow) {
        
        // This method locks the app and shows passcode verification 
        // if there is a stored passcode and a passcode
        // controller isn't already being shown.
        //
        // To implement, call this method from:
        //      1. AppDelegate.application(_,didFinishLaunchingWithOptions)
        //      2. AppDelegate.applicationWillEnterForeground(_ application: UIApplication)

        guard ORKPasscodeViewController.isPasscodeStoredInKeychain() && !(containerViewController.presentedViewController is ORKPasscodeViewController) else { return }
        
        applicationWindow.makeKeyAndVisible()
        
        let passcodeViewController = ORKPasscodeViewController.passcodeAuthenticationViewController(withText: "Welcome back to ResearchKit Sample App", delegate: self)
        self.containerViewController = containerViewController
        containerViewController.present(passcodeViewController, animated: false, completion: nil)
    }
    
    func hideForPasscodeProtection(containerViewController: ChopResearchStudyViewController) {
        
        // This method Hide content so it doesn't appear in the app switcher.
        //
        // To implement, call this method from:
        //      1. AppDelegate.applicationDidEnterBackground(_ application: UIApplication)
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            // Hide content so it doesn't appear in the app switcher.
            containerViewController.contentHidden = true
        }
        
    }
    
    fileprivate var impl: ChopPasscodeModuleImplementation?
    fileprivate var moduleSteps = ChopModuleStepCollection()
    private var passcodeViewController: ORKPasscodeViewController?
    weak fileprivate var rkTaskViewController: ORKTaskViewController?
    weak fileprivate var containerViewController: ChopResearchStudyViewController?
}

extension PasscodeManager: ORKPasscodeDelegate {
    // MARK: ORKPasscodeDelegate

    public func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {

        viewController.dismiss(animated: true, completion: nil)

        if (rkTaskViewController != nil) {
            // A wait step is current, holding the progress of the task
            // TODO: Not sure why this isn't working:
            // .goForward() does not work...
            let vc = rkTaskViewController
            let svc = rkTaskViewController?.currentStepViewController
            
            if vc != nil && svc != nil {
                _ = svc?.step?.identifier
                rkTaskViewController?.currentStepViewController?.goForward()
                rkTaskViewController = nil
            }
        }
        
        if containerViewController != nil {

            containerViewController?.contentHidden = false
            containerViewController = nil
        }
    }
    
    public func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
        
        rkTaskViewController = nil
        containerViewController = nil
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
    public func passcodeViewControllerDidCancel(_ viewController: UIViewController) {
        
        rkTaskViewController = nil
        containerViewController = nil
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
//    /**
//     Defaults to Localized "Forgot Passcode?" text
//     
//     @param viewController      The `ORKPasscodeStepViewController` object in which the passcode input is entered.
//     @return                    Text to display for the forgot passcode button
//     */
//    public func passcodeViewControllerText(forForgotPasscode viewController: UIViewController) -> String {
//        return "Forgot Passcode?"
//    }
    
    
    /**
     Notifies the delegate that forgot passcode button has been tapped.
     
     @param viewController      The `ORKPasscodeStepViewController` object in which the passcode input is entered.
     */
    public func passcodeViewControllerForgotPasscodeTapped(_ viewController: UIViewController) {
        
        rkTaskViewController = nil
        viewController.dismiss(animated: true, completion: nil)
    }

}

