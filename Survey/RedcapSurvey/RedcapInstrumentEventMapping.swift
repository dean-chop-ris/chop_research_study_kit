//
//  RedcapInstrumentEventMapping.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/24/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapInstrumentEventMapping {
    
    var armNum: Int { get { return base.attributeAsInt(key: "arm_num") } }
    var form: String { get { return base.attributeAsString(key: "form") } }
    var uniqueEventName: String { get { return base.attributeAsString(key: "unique_event_name") } }
    
    init(data: Dictionary<String, Any>) {
        
        base.coreAttributes = data
    }
    
    private var base = RedcapItemBase()
}


struct RedcapInstrumentEventMappingCollection {
    
    var isEmpty: Bool {
        get { return items.count == 0 }
    }
    
    var first: RedcapInstrumentEventMapping {
        
        return items[0]
    }
    
    func filter(eventId: String) -> RedcapInstrumentEventMappingCollection {
        
        var newCollection = RedcapInstrumentEventMappingCollection()
        
        for item in items {
            
            if item.uniqueEventName == eventId {
                newCollection.add(item: item)
            }
        }
        return newCollection
    }

    func filter(mappingForm: String) -> RedcapInstrumentEventMappingCollection {
        
        var newCollection = RedcapInstrumentEventMappingCollection()
        
        for item in items {
            
            if (item.form == mappingForm) {
                newCollection.add(item: item)
            }
        }
        return newCollection
    }
    
    mutating func loadFromJSON(data: [Dictionary<String, Any>], forForm mappingForm: String = "") {
        
        let loadAll = mappingForm.isEmpty
        
        for item in data {
            
            let mapping = RedcapInstrumentEventMapping(data: item)
            
            if loadAll || (mapping.form == mappingForm) {
                items += [mapping]
            }
        }
        
    }
    
    mutating func removeAll() {
        
        items = [RedcapInstrumentEventMapping]()
    }
    
    mutating func add(item: RedcapInstrumentEventMapping) {
        
        items += [item]
    }
    
    fileprivate var items = [RedcapInstrumentEventMapping]()
}

extension RedcapInstrumentEventMappingCollection: Sequence {
    // MARK: Sequence
    public func makeIterator() -> RedcapInstrumentEventMappingIterator {
        
        return RedcapInstrumentEventMappingIterator(withArray: items)
    }
}


//////////////////////////////////////////////////////////////////////
// RedcapInstrumentEventMappingIterator
//////////////////////////////////////////////////////////////////////

struct RedcapInstrumentEventMappingIterator : IteratorProtocol {
    
    var values: [RedcapInstrumentEventMapping]
    var indexInSequence = 0
    
    init(withArray dictionary: [RedcapInstrumentEventMapping]) {
        values = [RedcapInstrumentEventMapping]()
        for value in dictionary {
            self.values += [value]
        }
    }
    
    mutating func next() -> RedcapInstrumentEventMapping? {
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
 
 [
    "arm_num": 1, 
    "form": demographics, 
    "unique_event_name": enrollment_arm_1
 ],

 [
    "arm_num": 1, 
    "form": contact_info, 
    "unique_event_name": enrollment_arm_1
 ],

 [
    "arm_num": 1, 
    "form": baseline_data, 
    "unique_event_name": enrollment_arm_1
 ], 
 
 [
    "arm_num": 1, 
    "form": patient_morale_questionnaire, 
    "unique_event_name": dose_1_arm_1
 ], 
 
 [
    "arm_num": 1, 
    "form": visit_lab_data, 
    "unique_event_name": visit_1_arm_1
 ], 
 
 [
    "arm_num": 1, "form": patient_morale_questionnaire, "unique_event_name": visit_1_arm_1], ["arm_num": 1, "form": visit_blood_workup, "unique_event_name": visit_1_arm_1], ["arm_num": 1, "form": visit_observed_behavior, "unique_event_name": visit_1_arm_1], ["arm_num": 1, "form": patient_morale_questionnaire, "unique_event_name": dose_2_arm_1], ["arm_num": 1, "form": visit_lab_data, "unique_event_name": visit_2_arm_1], ["arm_num": 1, "form": patient_morale_questionnaire, "unique_event_name": visit_2_arm_1], ["arm_num": 1, "form": visit_blood_workup, "unique_event_name": visit_2_arm_1], ["arm_num": 1, "form": visit_observed_behavior, "unique_event_name": visit_2_arm_1], ["arm_num": 1, "form": patient_morale_questionnaire, "unique_event_name": dose_3_arm_1], ["arm_num": 1, "form": visit_lab_data, "unique_event_name": visit_3_arm_1], ["arm_num": 1, "form": patient_morale_questionnaire, "unique_event_name": visit_3_arm_1], ["arm_num": 1, "form": visit_blood_workup, "unique_event_name": visit_3_arm_1], ["arm_num": 1, "form": visit_observed_behavior, "unique_event_name": visit_3_arm_1], ["arm_num": 1, "form": patient_morale_questionnaire, "unique_event_name": final_visit_arm_1], ["arm_num": 1, "form": visit_blood_workup, "unique_event_name": final_visit_arm_1], ["arm_num": 1, "form": visit_observed_behavior, "unique_event_name": final_visit_arm_1], ["arm_num": 1, "form": completion_data, "unique_event_name": final_visit_arm_1], ["arm_num": 1, "form": completion_project_questionnaire, "unique_event_name": final_visit_arm_1]]

 
 */
