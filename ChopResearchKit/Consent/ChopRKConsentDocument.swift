//
//  ChopRKConsentDocument.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/25/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

public class ChopRKConsentDocument: ORKConsentDocument {
    
    override init() {

        super.init()
    }
    
    func addSection(sectionType: ORKConsentSectionType,
                             summary: String,
                             content: String) {

        let section = ORKConsentSection(type: sectionType)
        
        section.summary = summary
        section.content = content
        
        if sections == nil {
            sections = [ORKConsentSection]()
        }
        
        sections?.append(section)
    }

    func includeSignature() {
        
        self.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
        
        // Note: An ORKConsentSignature can also be pre-populated with a name, image and date. This is useful
        // when you need to include a copy of the principal investigator’s signature in the consent document.
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
