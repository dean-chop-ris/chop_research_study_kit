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
    
    var contentHidden = false {
        didSet {
            guard contentHidden != oldValue && isViewLoaded else { return }
            childViewControllers.first?.view.isHidden = contentHidden
        }
    }
    
}
