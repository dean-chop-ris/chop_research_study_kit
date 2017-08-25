//
//  RedcapEventTracker.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/25/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapEventTracker {

    var userCurrentEventId: String {
        
        get {
            return currentEventId
        }
        
        set {
            currentEventId = newValue
            track()
        }
    }
    
    init(redcapEvents: RedcapEventCollection, redcapArms: RedcapArmCollection, redcapMappings: RedcapInstrumentEventMappingCollection) {
        
        events = redcapEvents
        arms = redcapArms
        mappings = redcapMappings
    }
    
    private mutating func track() {
        
        guard let curArm = arms.find(eventId: userCurrentEventId) else {
            return
        }
        
        guard let curEvent = events.find(eventId: userCurrentEventId) else {
            return
        }
        
        
        
        currentArm = curArm
        currentEvent = curEvent
    }
    
    
    private var events: RedcapEventCollection
    private var arms: RedcapArmCollection
    private var mappings: RedcapInstrumentEventMappingCollection
    
    private var currentEventId = ""
    private var currentArm: RedcapArm? = nil
    private var currentEvent: RedcapEvent? = nil
    
}
