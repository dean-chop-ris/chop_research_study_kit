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

typealias WebRequestResponse = (ChopWebRequestResponse, NSError?) -> Void

struct ChopWebRequestBroker {

    init() {
        
        self.client = nil
        session = URLSession(configuration: URLSessionConfiguration.default)
    }

    init(dataStoreClient client: ChopWebDataStoreClient) {
        
        self.client = client
        session = URLSession(configuration: URLSessionConfiguration.default)
    }

    func send(request: ChopWebRequest, onCompletion: @escaping WebRequestResponse) {
        
        let urlRequest = request.urlRequest
        
        // send request
        let dataTask = session.dataTask(with: urlRequest!, completionHandler: { (data, response, error) in
            

            if error != nil {
                print("-------HTTP ERROR -----------")
                print(error!)
                print("-------/HTTP ERROR ----------")
            }
            
            if response != nil {
                if let httpResponse = response as? HTTPURLResponse {
    
                    var resp = ChopWebRequestResponse(
                        httpResponse: httpResponse,
                        data: data!,
                        requestResponded: request)

//                    var resp = ChopWebRequestResponse(usingSimulator:ChopWebServerSimulator(withParamsDictionary: request.paramsDictionary))

                    resp.error = error
                    onCompletion(resp, nil)
                    
                } else {
                    print(response!)
                }
            }
            else {

                let resp = ChopWebRequestResponse(
                    requestError: error!,
                    requestResponded: request)

                onCompletion(resp, nil)
            }
            /*
            let resp = ChopWebRequestResponse(usingSimulator:ChopWebServerSimulator(withParamsDictionary: Dictionary<String,String>()))
            
            onCompletion(resp, nil)
            */
        })
        dataTask.resume()
    }
    
    private var client: ChopWebDataStoreClient?
    private var session: URLSession
}
