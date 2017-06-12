//
//  ChopModuleDataPointCollected.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/18/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct ChopModuleDataPointCollected {
    
    init(withDescription description: String, andStepId stepId: String, andWebId webId: String) {
        self.description = description
        self.identifier = stepId
        self._webId = webId
        self.dataPointValue = ""
    }
    
    mutating func collectDate(dateToCollect: Date) {
        
        let formatter = RedcapImportDataFormatter(forClient: self)
        
        dataPointValue = formatter.formatDateForSubmission(dateToFormat: dateToCollect)
    }

    mutating func collectString(stringToCollect: String) {
        
        dataPointValue = stringToCollect
    }

    fileprivate var identifier: String
    fileprivate var dataPointValue: String
    fileprivate var description: String
    fileprivate var _webId: String
}

extension ChopModuleDataPointCollected: ChopResearchStudyModuleStep {
    // MARK: ChopResearchStudyModuleStep
    var stepId: String { get { return self.identifier } }
    
}


extension ChopModuleDataPointCollected: GeneratesWebRequestData {
    // MARK: GeneratesWebRequestData
    public var webId: String {
        get { return _webId }
        set { _webId = newValue }
    }
        
    func populateWebRequestPostDictionary(dictionary: inout Dictionary<String, String>) {
        dictionary[webId] = dataPointValue
    }
}
