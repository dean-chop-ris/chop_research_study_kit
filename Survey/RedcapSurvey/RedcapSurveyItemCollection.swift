//
//  RedcapSurveyItemCollection.swift
//  Test_RedcapSurvey_1
//
//  Created by Ritter, Dean on 7/20/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapSurveyItemCollection {
    
    var isEmpty: Bool {
        get { return items.count == 0 }
    }
    
    var first: RedcapSurveyItem {
    
        return items[0]
    }
    
    mutating func loadFromJSON(data: [Dictionary<String, Any>], forInstrumentName instrumentName: String) {
        
        for item in data {
            
            let surveyItem = RedcapSurveyItem(data: item)
            
            if surveyItem.formName == instrumentName {
                items += [surveyItem]
            }
        }
        
    }
    
    mutating func removeAll() {
        
        items = [RedcapSurveyItem]()
    }
    
    mutating func add(item: RedcapSurveyItem) {
        
        items += [item]
    }
    
    fileprivate var items = [RedcapSurveyItem]()
}

extension RedcapSurveyItemCollection: Sequence {
    // MARK: Sequence
    public func makeIterator() -> RedcapSurveyItemIterator {

        return RedcapSurveyItemIterator(withArray: items)
    }
}


//////////////////////////////////////////////////////////////////////
// RedcapSurveyItemIterator
//////////////////////////////////////////////////////////////////////

struct RedcapSurveyItemIterator : IteratorProtocol {
    
    var values: [RedcapSurveyItem]
    var indexInSequence = 0
    
    init(withArray dictionary: [RedcapSurveyItem]) {
        values = [RedcapSurveyItem]()
        for value in dictionary {
            self.values += [value]
        }
    }
    
    mutating func next() -> RedcapSurveyItem? {
        if indexInSequence < values.count {
            let element = values[indexInSequence]
            indexInSequence += 1
            
            return element
        } else {
            indexInSequence = 0
            return nil
        }
    }
}
