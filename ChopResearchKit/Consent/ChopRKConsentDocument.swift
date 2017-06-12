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
        
        self.title = "Example Consent"
        
        //////////////////////////////////////////////////////////////////////
        // Consent Sections
        //////////////////////////////////////////////////////////////////////
        let consentSectionTypes: [ORKConsentSectionType] = [
            .overview,
            .dataGathering,
            .privacy,
            .dataUse,
            .timeCommitment,
            .studySurvey,
            .studyTasks,
            .withdrawing
        ]
        
        // Iterates through sections, adding the same summary and content,
        // for purposes of brevity. A real app, would, of course, have different content
        // for each section.
        let consentSections: [ORKConsentSection] = consentSectionTypes.map { contentSectionType in
            let consentSection = ORKConsentSection(type: contentSectionType)
            consentSection.summary = "If you wish to complete this study..."
            consentSection.content = "In this study you will be asked five (wait, no, three!) questions. You will also have your voice recorded for 10 seconds."
            
            return consentSection
        }
        
        self.sections = consentSections
        
        //////////////////////////////////////////////////////////////////////
        // Signature
        //////////////////////////////////////////////////////////////////////
        self.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
        
        // Note: An ORKConsentSignature can also be pre-populated with a name, image and date. This is useful
        // when you need to include a copy of the principal investigator’s signature in the consent document.
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
