//
//  ChopUIAlert.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/16/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import UIKit


struct ChopUIAlert {

    init(forViewController parentViewController: UIViewController, withTitle title: String, andMessage message: String) {
        
        self.parentViewController = parentViewController
        self.title = title
        self.message = message
    }

    func show(completionMethod: (() -> Swift.Void)? = nil) {
        
        let alertController = UIAlertController(title: self.title,
                                                message: self.message,
                                                preferredStyle: .actionSheet)
        
        // OK Action
        let okAction = UIAlertAction(title: "OK",
                                     style: .destructive,
                                     handler: { (action:UIAlertAction!) in
                                        print ("ok")
        })
        alertController.addAction(okAction)
        
        // Present Alert
        self.parentViewController.present(alertController,
                                          animated: true,
                                          completion:completionMethod)
        
    }
    
    private var parentViewController: UIViewController
    private var title: String
    private var message: String
}
