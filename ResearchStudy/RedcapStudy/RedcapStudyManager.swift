//
//  RedcapStudyManager.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/11/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import UIKit

struct RedcapStudyManager {
    
    var isLoaded: Bool {
        get { return items.isEmpty == false }
    }

    public private(set) var redcapToken: String
    
    public var currentArm: RedcapArm {
        
        //let currentEvent = events.find(eventId: userRecord.currentEventId)
        
        return arms.find(eventId: userRecord.currentEventId)!
    }

    public var currentEvent: RedcapEvent {
        
        return events.find(eventId: userRecord.currentEventId)!
    }

    init(token: String) {
        
        redcapToken = token
    }
    
    func createLoaderViewController(delegate: ChopResearchStudy) -> UIViewController {
        
        let loaderViewController = RedcapSurveyLoaderViewController()
        let source = RedcapMetadataWebRequestSource(client: self)
        
        loaderViewController.requestor = source
            
        return loaderViewController
    }
    
    mutating func load(options: Int, onCompletion: @escaping LoadRequestResponse) {

        let queue = DispatchQueue.global(qos: DispatchQoS.background.qosClass)
        let group = DispatchGroup()

        let broker = ChopWebRequestBroker()
        
        
        group.enter()
        queue.sync {
            let metadataSource = RedcapMetadataWebRequestSource(client: self)
            let request = ChopWebRequest(withSource: metadataSource)
            
            broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("metadata", response, error)
                group.leave()
            }
            )
        }
        
        group.enter()
        queue.sync {
            let armsSource = RedcapArmsWebRequestSource(client: self)
            let request = ChopWebRequest(withSource: armsSource)
            
            broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("arm", response, error)
                group.leave()
            }
            )
        }
        
        group.enter()
        queue.sync {
            let eventsSource = RedcapEventsWebRequestSource(client: self)
            let request = ChopWebRequest(withSource: eventsSource)
            
            broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("event", response, error)
                group.leave()
            }
            )
        }
        
        group.enter()
        queue.sync {
            let mappingsSource = RedcapInstrumentEventMappingsWebRequestSource(client: self)
            let request = ChopWebRequest(withSource: mappingsSource)
            
            broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("mapping", response, error)
                group.leave()
            }
            )
        }
        
        group.enter()
        queue.sync {
            let userSource = RedcapUserRecordWebRequestSource(client: self)
            let request = ChopWebRequest(withSource: userSource)
            
            broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("user", response, error)
                group.leave()
            }
            )
        }

        group.notify(queue: DispatchQueue.main, execute: {
            let dummyResponse = ChopWebRequestResponse(usingSimulator: ChopWebServerSimulator(withParamsDictionary: Dictionary<String, String>()))

            onCompletion("load_done", dummyResponse, nil)
            }
        )
    }


    mutating func load_orig(options: Int, onCompletion: @escaping LoadRequestResponse) {

        let group = DispatchGroup()

        group.enter()
        let metadataSource = RedcapMetadataWebRequestSource(client: self)
        var request = ChopWebRequest(withSource: metadataSource)
        let broker = ChopWebRequestBroker()
        
        broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("metadata", response, error)
                group.leave()
            }
        )

        group.enter()
        let armsSource = RedcapArmsWebRequestSource(client: self)
        
        request = ChopWebRequest(withSource: armsSource)
        
        broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("arm", response, error)
                group.leave()
            }
        )

        group.enter()
        let eventsSource = RedcapEventsWebRequestSource(client: self)
        
        request = ChopWebRequest(withSource: eventsSource)
        
        broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("event", response, error)
                group.leave()
            }
        )

        group.enter()
        let mappingsSource = RedcapInstrumentEventMappingsWebRequestSource(client: self)
        
        request = ChopWebRequest(withSource: mappingsSource)
        
        broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("mapping", response, error)
                group.leave()
            }
        )

        group.enter()
        let userSource = RedcapUserRecordWebRequestSource(client: self)
        
        request = ChopWebRequest(withSource: userSource)
        
        broker.send(request: request, onCompletion: { (response, error) in
                onCompletion("user", response, error)
                group.leave()
            }
        )
        
        group.notify(queue: DispatchQueue.global(), execute: { () in
            let dummyResponse = ChopWebRequestResponse(usingSimulator: ChopWebServerSimulator(withParamsDictionary: Dictionary<String, String>()))
            onCompletion("load_done", dummyResponse, nil)
        })
    }
    /*
    func createRedcapSurveyManager(instrumentName: String) -> RedcapSurveyManager {
     
        var mgr = RedcapSurveyManager(
            token: redcapToken,
            redcapInstrumentName: instrumentName)
        
        mgr.load(redcapItems: items)
        
        return mgr
    }
    */
    mutating func extract(requestId: String, fromResponse response: ChopWebRequestResponse) {
        
        if requestId == "metadata" {
            items.loadFromJSON(data: response.data)
        }

        if requestId == "arm" {
            arms.loadFromJSON(data: response.data)
        }
        
        if requestId == "event" {
            events.loadFromJSON(data: response.data)
        }

        if requestId == "mapping" {
            events.loadFromJSON(data: response.data)
        }

        if requestId == "user" {
            userRecord = RedcapUserRecord(data: response.data.first!)
        }
    }
    
    fileprivate var items = RedcapSurveyItemCollection()
    fileprivate var arms = RedcapArmCollection()
    fileprivate var events = RedcapEventCollection()
    fileprivate var userRecord = RedcapUserRecord()
}

/*
extension RedcapStudyManager: ChopWebRequestSource {
    // MARK: ChopWebRequestSource
    
    var destinationUrl: String
    {
        get
        {
            return "https://redcap.chop.edu/api/"
        }
    }
    
    var headerParamsDictionary: Dictionary<String, String> {
        
        get {
            var params = ChopWebRequestParameters()
            
            params.load(key: "token", value: redcapToken)
            params.load(key: "content", value: "metadata")
            params.load(key: "format", value: "json")
            params.load(key: "returnFormat", value: "json")
            return params.postDictionary
        }
    }
}
*/

extension RedcapStudyManager: RedcapItemsProvider {
    // MARK: RedcapItemsProvider
    
    var redcapItems: RedcapSurveyItemCollection {
        
        return items
    }
    
}

extension RedcapStudyManager: RedcapWebRequestClient {
    // MARK: RedcapItemsProvider
    
    var destinationUrl: String
    {
        return "https://redcap.chop.edu/api/"
    }
    
    var token: String
    {
        return redcapToken
    }
}

protocol RedcapWebRequestClient {
    
    var destinationUrl: String { get }
    var token: String { get }
}

struct RedcapMetadataWebRequestSource {

    
    fileprivate var client: RedcapWebRequestClient
}

extension RedcapMetadataWebRequestSource: ChopWebRequestSource {
    
    var destinationUrl: String
    {
        return client.destinationUrl
    }
    
    var headerParamsDictionary: Dictionary<String, String> {
        
        get {
            var params = ChopWebRequestParameters()
            
            params.load(key: "token", value: client.token)
            params.load(key: "content", value: "metadata")
            params.load(key: "format", value: "json")
            params.load(key: "returnFormat", value: "json")
            return params.postDictionary
        }
    }
}

struct RedcapArmsWebRequestSource {
    
    
    fileprivate var client: RedcapWebRequestClient
}

extension RedcapArmsWebRequestSource: ChopWebRequestSource {
    
    var destinationUrl: String
    {
        return client.destinationUrl
    }
    
    var headerParamsDictionary: Dictionary<String, String> {
        
        get {
            var params = ChopWebRequestParameters()
            
            params.load(key: "token", value: client.token)
            params.load(key: "content", value: "arm")
            params.load(key: "format", value: "json")
            params.load(key: "returnFormat", value: "json")
            return params.postDictionary
        }
    }
}

struct RedcapEventsWebRequestSource {
    
    
    fileprivate var client: RedcapWebRequestClient
}

extension RedcapEventsWebRequestSource: ChopWebRequestSource {
    
    var destinationUrl: String
    {
        return client.destinationUrl
    }
    
    var headerParamsDictionary: Dictionary<String, String> {
        
        get {
            var params = ChopWebRequestParameters()
            
            params.load(key: "token", value: client.token)
            params.load(key: "content", value: "event")
            params.load(key: "format", value: "json")
            params.load(key: "returnFormat", value: "json")
            return params.postDictionary
        }
    }
}

struct RedcapInstrumentEventMappingsWebRequestSource {
    
    
    fileprivate var client: RedcapWebRequestClient
}

extension RedcapInstrumentEventMappingsWebRequestSource: ChopWebRequestSource {
    
    var destinationUrl: String
    {
        return client.destinationUrl
    }
    
    var headerParamsDictionary: Dictionary<String, String> {
        
        get {
            var params = ChopWebRequestParameters()
            
            params.load(key: "token", value: client.token)
            params.load(key: "content", value: "formEventMapping")
            params.load(key: "format", value: "json")
            params.load(key: "returnFormat", value: "json")
            return params.postDictionary
        }
    }
}

struct RedcapUserRecordWebRequestSource {
    
    
    fileprivate var client: RedcapWebRequestClient
}

extension RedcapUserRecordWebRequestSource: ChopWebRequestSource {
    
    var destinationUrl: String
    {
        return client.destinationUrl
    }
    
    var headerParamsDictionary: Dictionary<String, String> {
        
        get {
            var params = ChopWebRequestParameters()
            
            params.load(key: "token", value: client.token)
            params.load(key: "content", value: "record")
            params.load(key: "format", value: "json")
            params.load(key: "type", value: "flat")
            params.load(key: "records", value: "23C837A0-E9CE-4A25-81E6-EC21D5E26674")
            params.load(key: "rawOrLabel", value: "raw")
            params.load(key: "rawOrLabelHeaders", value: "raw")
            params.load(key: "exportCheckboxLabel", value: "false")
            params.load(key: "exportSurveyFields", value: "false")
            params.load(key: "exportDataAccessGroups", value: "false")
            params.load(key: "returnFormat", value: "json")
            return params.postDictionary
        }
    }
}
