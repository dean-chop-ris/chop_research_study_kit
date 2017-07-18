//
//  ChopWebRequestBroker.swift
//
//  Created by Ritter, Dean on 1/25/17.
//
//  ChopWebRequestBroker.swift
//
//  Created by Ritter, Dean on 5/11/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

typealias ServiceResponse = (ChopWebRequestResponse, NSError?) -> Void

struct ChopWebRequestBroker {

    init() {
        
        self.client = nil
        session = URLSession(configuration: URLSessionConfiguration.default)
    }

    init(dataStoreClient client: ChopWebDataStoreClient) {
        
        self.client = client
        session = URLSession(configuration: URLSessionConfiguration.default)
    }

    func send(request: ChopWebRequest, onCompletion: @escaping ServiceResponse) {
        
        let urlRequest = request.urlRequest
        
        // send request
        let dataTask = session.dataTask(with: urlRequest!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
            }
            if response != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    
                    let resp = ChopWebRequestResponse(httpResponse: httpResponse, data: data!)
                    //let resp = ChopWebRequestResponse(usingSimulator:ChopWebServerSimulator(withParamsDictionary: paramsDictionary))
  
                    onCompletion(resp, nil)
                    
                } else {
                    print(response!)
                }
            }
        })
        dataTask.resume()
    }
    
    private var client: ChopWebDataStoreClient?
    private var session: URLSession
}
