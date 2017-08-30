//
//  RedcapInstrument.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/25/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapInstrument {
    
    // Core Attributes
    var instrumentName: String { get { return base.attributeAsString(key: "instrument_name") } }
    var instrumentLabel: String { get { return base.attributeAsString(key: "instrument_label") } }

    // Other Attributes
    public private(set) var fields = RedcapSurveyItemCollection()

    var isLoaded: Bool {
        get { return (base.coreAttributes.isEmpty == false) && (fields.isEmpty == false) }
    }

    /////////////////////
    
    init(data: Dictionary<String, Any>) {
        
        base.coreAttributes = data
    }
    
    mutating func load(withFields fieldsToLoad: RedcapSurveyItemCollection) {
        
        fields = fieldsToLoad
    }
    
    private var base = RedcapItemBase()
}

struct RedcapInstrumentCollection {
    
    var isEmpty: Bool {
        get { return instruments.count == 0 }
    }

    var count: Int {
        get { return instruments.count }
    }

    var first: RedcapInstrument {
        
        return instruments[0]
    }
    
    subscript(index: Int) -> RedcapInstrument {
        return instruments[index]
    }
    
    func filter(instrumentMappings: RedcapInstrumentEventMappingCollection) -> RedcapInstrumentCollection {
    
        var newCollection = RedcapInstrumentCollection()
        
        if isEmpty {
            return newCollection
        }
        
        for item in instrumentMappings {
           
            let instrument = find(name: item.form)
            
            newCollection.add(item: instrument!)
        }
        return newCollection

    
    }

    func filter(instrumentName: String) -> RedcapInstrumentCollection {
        
        var newCollection = RedcapInstrumentCollection()
        
        for item in instruments {
            
            if (item.instrumentName == instrumentName) {
                newCollection.add(item: item)
            }
        }
        return newCollection
    }
    
    mutating func loadFromJSON(data: [Dictionary<String, Any>]) {
        
        for item in data {
            instruments += [RedcapInstrument(data: item)]
        }
        
    }
    
    mutating func removeAll() {
        
        instruments = [RedcapInstrument]()
    }
    
    mutating func add(item: RedcapInstrument) {
        
        instruments += [item]
    }
    
    func find(name: String) -> RedcapInstrument? {
        
        for instrument in instruments {
            
            if instrument.instrumentName == name {
                return instrument
            }
        }
        return nil
    }

    func find(title: String) -> RedcapInstrument? {
        
        for instrument in instruments {
            
            if instrument.instrumentLabel == title {
                return instrument
            }
        }
        return nil
    }

    fileprivate var instruments = [RedcapInstrument]()
}

extension RedcapInstrumentCollection: Sequence {
    // MARK: Sequence
    public func makeIterator() -> RedcapInstrumentIterator {
        
        return RedcapInstrumentIterator(withArray: instruments)
    }
}


//////////////////////////////////////////////////////////////////////
// RedcapInstrumentIterator
//////////////////////////////////////////////////////////////////////

struct RedcapInstrumentIterator : IteratorProtocol {
    
    var values: [RedcapInstrument]
    var indexInSequence = 0
    
    init(withArray dictionary: [RedcapInstrument]) {
        values = [RedcapInstrument]()
        for value in dictionary {
            self.values += [value]
        }
    }
    
    mutating func next() -> RedcapInstrument? {
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



/*
 
[
{
    "instrument_name":"demographics",
    "instrument_label":"Demographics"
 },

 {  "instrument_name":"contact_info",
    "instrument_label":"Contact Info"
 },
 
 {  "instrument_name":"baseline_data",
    "instrument_label":"Baseline Data"
 },
 
 {
    "instrument_name":"visit_lab_data",
    "instrument_label":"Visit Lab Data"
 },
 
 {  "instrument_name":"patient_morale_questionnaire",
    "instrument_label":"Patient Morale Questionnaire"
 },
 
 {
    "instrument_name":"visit_blood_workup",
    "instrument_label":"Visit Blood Workup"
 },
 {
    "instrument_name":"visit_observed_behavior",
    "instrument_label":"Visit Observed Behavior"
 }
 
 {
    "instrument_name":"completion_data",
    "instrument_label":"Completion Data"
 },
 
 {
    "instrument_name":"completion_project_questionnaire",
    "instrument_label":"Completion Project Questionnaire"
 }
 ]
 
 */

