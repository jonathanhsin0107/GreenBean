//
//  PostJsonDataToApi.swift
//  GreenBean
//
//  Created by Jonathan on 4/8/25.
//  Copyright © 2025 Jonathan Hsin. All rights reserved.
//

import Foundation

/*
*************************************************************
MARK: - postJsonDataToApi Function for POST Requests to APIs
*************************************************************
*/
public func postJsonDataToApi(apiHeaders: [String: String],
                              apiUrl: String,
                              postData: [String: Any],
                              timeout: TimeInterval) -> Data? {
    guard let url = URL(string: apiUrl) else { return nil }
    
    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
    request.httpMethod = "POST"
    
    for (headerField, headerValue) in apiHeaders {
        request.setValue(headerValue, forHTTPHeaderField: headerField)
    }
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
    } catch {
        print("Error serializing JSON for POST request: \(error)")
        return nil
    }
    
    let semaphore = DispatchSemaphore(value: 0)
    var apiData: Data?
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: \(String(describing: error))")
            semaphore.signal()
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("HTTP Response status is not in 2xx range!")
            semaphore.signal()
            return
        }
        
        apiData = data
        semaphore.signal()
    }.resume()
    
    _ = semaphore.wait(timeout: .now() + timeout)
    return apiData
}

