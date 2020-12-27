//
//  APIService.swift
//  TaskPlugXR
//
//  Created by N, Narasimhulu on 25/12/20.
//  Copyright © 2020 Narasimha. All rights reserved.
//

import Foundation

class APIService: NSObject {
    
    // MARK: - API to get data
    func getSampleData(completion: @escaping (DataModel?, Error?) -> ()) {
        
        let urlComp = NSURLComponents(string: "http://www.json-generator.com/api/json/get/cfimhYMfCa?indent=2")
       
        // guard check for url
        guard let url = urlComp?.url else { return }
        var urlRequest = URLRequest(url: url)
        
        // HttpMethod - Get
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // URLSession as data task
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // API success
            if error == nil && data != nil {
                // Serialize the data into an Object
                do {
                    let responseModel =  try JSONDecoder().decode(DataModel.self, from: data!)
                    DispatchQueue.main.async {
                        //return the  model
                        completion(responseModel, nil)
                    }
                }  catch {
                    DispatchQueue.main.async {
                        // managing the error
                        completion(nil, error)
                    }
                }
                // Check an error if occured
            } else if error != nil   { // API failure
                DispatchQueue.main.async {
                    // managing the error
                    completion(nil, error)
                }
            }
        })
        task.resume()
    }
    
}
