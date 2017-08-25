//
//  RedcapEvent.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/24/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapEvent {

    // Core Attributes
    var offsetMin: Int { get { return base.attributeAsInt(key: "offset_min") } }
    var customEventLabel: Int { get { return base.attributeAsInt(key: "custom_event_label") } }
    var eventName: String { get { return base.attributeAsString(key: "event_name") } }
    var dayOffset: Int { get { return base.attributeAsInt(key: "day_offset") } }
    var uniqueEventName: String { get { return base.attributeAsString(key: "unique_event_name") } }
    var armNum: Int { get { return base.attributeAsInt(key: "arm_num") } }
    var offsetMax: Int { get { return base.attributeAsInt(key: "offset_max") } }

    // Other Attributes
    var eventId: String { return uniqueEventName }
    
    ///////////////////////////////////
    
    init(data: Dictionary<String, Any>) {
        
        base.coreAttributes = data
    }
    
    private var base = RedcapItemBase()
}


struct RedcapEventCollection {
    
    var isEmpty: Bool {
        get { return events.count == 0 }
    }
    
    var first: RedcapEvent {
        
        return events[0]
    }
    
    func filter(eventName: String) -> RedcapEventCollection {
        
        var newCollection = RedcapEventCollection()
        
        for item in events {
            
            if (item.eventName == eventName) {
                newCollection.add(item: item)
            }
        }
        return newCollection
    }
    
    mutating func loadFromJSON(data: [Dictionary<String, Any>], forInstrumentName eventName: String = "") {
        
        let loadAll = eventName.isEmpty
        
        for item in data {
            
            let event = RedcapEvent(data: item)
            
            if loadAll || (event.eventName == eventName) {
                events += [event]
            }
        }
        
    }
    
    mutating func removeAll() {
        
        events = [RedcapEvent]()
    }
    
    mutating func add(item: RedcapEvent) {
        
        events += [item]
    }
    
    func find(eventId: String) -> RedcapEvent? {
        
        for event in events {
            
            if eventId.contains(event.eventId) {
                return event
            }
        }
        return nil
    }

    fileprivate var events = [RedcapEvent]()
}

extension RedcapEventCollection: Sequence {
    // MARK: Sequence
    public func makeIterator() -> RedcapEventIterator {
        
        return RedcapEventIterator(withArray: events)
    }
}


//////////////////////////////////////////////////////////////////////
// RedcapEventIterator
//////////////////////////////////////////////////////////////////////

struct RedcapEventIterator : IteratorProtocol {
    
    var values: [RedcapEvent]
    var indexInSequence = 0
    
    init(withArray dictionary: [RedcapEvent]) {
        values = [RedcapEvent]()
        for value in dictionary {
            self.values += [value]
        }
    }
    
    mutating func next() -> RedcapEvent? {
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
 
 [[  
    "offset_min": 0,
    "custom_event_label": <null>, 
    "event_name": Enrollment, 
    "day_offset": 0, 
    "unique_event_name": enrollment_arm_1, 
    "arm_num": 1, 
    "offset_max": 0
 ],
 
 [
    "offset_min": 0, 
    "custom_event_label": <null>, 
    "event_name": Dose 1, 
    "day_offset": 1, 
    "unique_event_name": dose_1_arm_1, 
    "arm_num": 1, 
    "offset_max": 0
 ],
 
 [
    "offset_min": 0, 
    "custom_event_label": <null>, 
    "event_name": Visit 1, 
    "day_offset": 3, 
    "unique_event_name": visit_1_arm_1, 
    "arm_num": 1, 
    "offset_max": 0
 ],
 
 [
    "offset_min": 0, 
    "custom_event_label": <null>, 
    "event_name": Dose 2, 
    "day_offset": 8, 
    "unique_event_name": dose_2_arm_1, 
    "arm_num": 1, "offset_max": 0
 ],
 
 [
    "offset_min": 0, 
    "custom_event_label": <null>, 
    "event_name": Visit 2, 
    "day_offset": 10, 
    "unique_event_name": visit_2_arm_1, 
    "arm_num": 1, 
    "offset_max": 0
 ],
 
 [
    "offset_min": 0, 
    "custom_event_label": <null>, 
    "event_name": Dose 3, 
    "day_offset": 15, 
    "unique_event_name": dose_3_arm_1, 
    "arm_num": 1, 
    "offset_max": 0
 ],
 
 [
    "offset_min": 0, 
    "custom_event_label": <null>, 
    "event_name": Visit 3, 
    "day_offset": 17, 
    "unique_event_name": visit_3_arm_1, 
    "arm_num": 1, "offset_max": 0
 ],
 
 [
    "offset_min": 0, 
    "custom_event_label": <null>, 
    "event_name": Final visit, 
    "day_offset": 30, 
    "unique_event_name": final_visit_arm_1, 
    "arm_num": 1, 
    "offset_max": 0
 ]]

 */
