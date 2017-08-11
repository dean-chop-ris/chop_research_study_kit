//
//  ChopRKTaskStepBase.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/29/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct ChopRKTaskStepBase {
    // This struct serves only as a container for
    // common attributes of survey question (struct) objects.
    // It is a by-product of the absence of inherited attributes
    // found in object-oriented paradigms.
    
    var passcodeProtected: Bool = false
    var web_Id: String = ""
    var validation: ValidationInfo = ValidationInfo()
}
