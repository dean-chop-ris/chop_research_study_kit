//
//  ChopResearchStudyConsent.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 6/13/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopResearchStudyConsent {

    var name: String {
        
        get {
            return (rkSignatureResult?.signature?.givenName)! + " " + (rkSignatureResult?.signature?.familyName)!
        }
    }
    
    mutating func load(resultToLoad: ORKConsentSignatureResult) {
        
        self.rkSignatureResult = resultToLoad
    }
    
    // We hold the attribute as a ORKResult data structure because
    // we may want to use:
    //   signatureResult?.apply(to: rkConsentDocument)
    //
    //   consentDocument.makePDFWithCompletionHandler { (data, error) -> Void in
    //      let tempPath = NSTemporaryDirectory() as NSString
    //      let path = tempPath.stringByAppendingPathComponent("signature.pdf")
    //      data?.writeToFile(path, atomically: true)
    //      print(path)
    //
    private var rkSignatureResult: ORKConsentSignatureResult?
}
