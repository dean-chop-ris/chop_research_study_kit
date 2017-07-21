//
//  RedcapSurveyLoaderViewController.swift
//  Test_RedcapSurvey_1
//
//  Created by Ritter, Dean on 7/20/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import UIKit

class RedcapSurveyLoaderViewController: ChopResearchStudyViewController {
    
    var requestor: ChopWebRequestSource?

    var webRequestResponseRecievedCallback: WebRequestResponseRecievedCallback? 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up view
        view.backgroundColor = UIColor.white
        view.addSubview(button)
        view.addSubview(label)
        view.setNeedsUpdateConstraints()
        
        // send web request to get survey info
        let request = ChopWebRequest(withSource: self.requestor!)
        let broker = ChopWebRequestBroker()
        
        broker.send(request: request, onCompletion: { (response, error) in
            
                //self.webRequestResponseRecievedCallback!(response)
            self.study.processWebResponse(response: response)
       }
        )
    }
    
    override func updateViewConstraints() {
        buttonConstraints()
        labelConstraints()
        super.updateViewConstraints()
    }
    
    func buttonConstraints() {
        // Center button in Page View
        NSLayoutConstraint(
            item: button,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0)
            .isActive = true
        
        // Set Width to be 30% of the Page View Width
        NSLayoutConstraint(
            item: button,
            attribute: .width,
            relatedBy: .equal,
            toItem: view,
            attribute: .width,
            multiplier: 0.3,
            constant: 0.0)
            .isActive = true
        
        // Set Y Position Relative to Bottom of Page View
        NSLayoutConstraint(
            item: button,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 0.9,
            constant: 0.0)
            .isActive = true
    }
  
    func labelConstraints() {
        // Center button in Page View
        NSLayoutConstraint(
            item: label,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0)
            .isActive = true
        
        // Set Width to be 80% of the Page View Width
        NSLayoutConstraint(
            item: label,
            attribute: .width,
            relatedBy: .equal,
            toItem: view,
            attribute: .width,
            multiplier: 0.8,
            constant: 0.0)
            .isActive = true
        
        // Set Y Position Relative to Bottom of Page View
        NSLayoutConstraint(
            item: label,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
            .isActive = true
    }
    
    func buttonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var button: UIButton! = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(RedcapSurveyLoaderViewController.buttonPressed), for: .touchDown)
        view.setTitle("Cancel", for: [])
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    lazy var label: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Loading"
        view.textAlignment = .center
        
        return view
    }()
}

























