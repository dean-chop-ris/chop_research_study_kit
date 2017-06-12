//
//  ChopWebRequestBroker.swift
//  Camelot
//
//  Created by Ritter, Dean on 1/25/17.
//
//  ChopWebRequestBroker.swift
//  CHOP_RK
//
//  Created by Ritter, Dean on 5/11/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

protocol WebRequestSendable {
    
    func populateWebRequestParamsDictionary(dictionary: inout Dictionary<String, String>)

    var destinationUrl: String { get }
}

struct ChopWebRequestBroker {
    var session: URLSession
    private var client: ChopWebDataStoreClient
    
    init(dataStoreClient client: ChopWebDataStoreClient) {
        
        self.client = client
        session = URLSession(configuration: URLSessionConfiguration.default)
    }

    func send(request: WebRequestSendable) {
        
        guard let url = URL(string: request.destinationUrl) else {
            print("Error: cannot create URL: " + request.destinationUrl)
            return
        }
        
        // set up dictionary of JSON parameters to be included in the web request
        var paramsDictionary = Dictionary<String, String>()
        
        request.populateWebRequestParamsDictionary(dictionary: &paramsDictionary)
        
        // create params string to be included in request
        var params = ""
        for kvp in paramsDictionary {
            if params.lengthOfBytes(using: String.Encoding.ascii) > 0 {
                params += "&"
            }
            params += "\(kvp.key)=\(kvp.value)"
        }
        
        // set up request
        var urlRequest = URLRequest(url: url)
        
        let body = NSMutableData()

        body.append(params.data(using: String.Encoding.utf8)!)

        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body as Data
        
        // send request
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
            }
            if response != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: (\(httpResponse.statusCode))")
                    if httpResponse.statusCode != 200 {
                        print(response!)
                    }
                } else {
                    print(response!)
                }
            }
        })
        dataTask.resume()
    }
    
    func parseJSON(data responseData: Data) {
        do {
            guard let jsonDictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                print("error trying to convert data to JSON")
                return
            }
            
            // now we have the serialized info, let's just print it to prove we can access it
            print("The JSON is: " + jsonDictionary.description)
            
            // the object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            guard let title = jsonDictionary["title"] as? String else {
                print("Could not get title from JSON")
                return
            }
            print("The title is: " + title)
        } catch  {
            print("error trying to convert data to JSON")
            return
        }
    }
}
