//
//  Client.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

class CardMineClient: AbstractAPI {
    
    // Mark: - Properties
    
    var session = URLSession.shared
    var userAuth: UserAuthInfo?
    
    
    // Mark: - Methods
    
    func genericApiTaks(apiEndpoint: String, parameters: [String:AnyObject], httpMethod: String,
                        jsonBody: String?, auth: UserAuthInfo? = nil, callback: @escaping handlerType) {
        
        // Exit properly if no connection available.
        if !isNetworkAvaliable() {
            notifyDisconnectivity(callback)
            return
        }
        
        userAuth = auth
        
        // Build the url then the request objects.
        var url = setupAPIURLWith(pathExtension: apiEndpoint, parameters: parameters)
        var request = URLRequest(url: url)
        
        request = configureRequest(request, method: httpMethod, body: jsonBody)
        
        // Make request ..
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            func reportError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                callback(nil, nil, NSError(domain: "taskForSessionlogin", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                reportError("There was an error with the server connection: \(error)")
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode! < 500 else {
                reportError("(\(statusCode!)) There was an unexpected error from the server. Try again.")
                return
            }
            
            guard data != nil else {
                reportError("Data curruption from the server. Sorry for the inconvenience.")
                return
            }
            
            // Extract Auth headers
            if self.userAuth == nil {
                self.parseHeaders(response as! HTTPURLResponse)
            }
            
            // Extact the raw data and pass it for parsing.
            self.parseJSON(data!, parseJSONCompletionHandler: callback)
        })
        
        // Start request ..
        task.resume()
    }
    
    private func setupAPIURLWith(pathExtension: String? = nil, parameters: [String:AnyObject]) -> URL {
        var components = URLComponents()
        
        components.scheme = Constants.APIScheme
        components.host   = Constants.APIHost
        components.path   = Constants.APIPath + (pathExtension ?? "")
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    // Setup the API request header, and body if any.
    private func configureRequest(_ request: URLRequest, method: String, body: String? = nil) -> URLRequest {
        var req = request
        
        req.httpMethod = method
        
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue(Constants.Auth.Values.ApiAccessToken,
                         forHTTPHeaderField: Constants.Auth.Keys.ApiAccessToken)

        if userAuth != nil {
            req.addValue((userAuth?.tokenType)!, forHTTPHeaderField: Constants.Auth.Keys.TokenType)
            req.addValue((userAuth?.accessToken)!, forHTTPHeaderField: Constants.Auth.Keys.AccessToken)
            req.addValue((userAuth?.client)!, forHTTPHeaderField: Constants.Auth.Keys.Client)
            req.addValue((userAuth?.expiry)!, forHTTPHeaderField: Constants.Auth.Keys.Expiry)
            req.addValue((userAuth?.uid)!, forHTTPHeaderField: Constants.Auth.Keys.UID)
        }
        
        if let body = body {
            req.httpBody = body.data(using: String.Encoding.utf8)
        }
        return req
    }
    
    // Get the authentication info from response headers
    private func parseHeaders(_ response: HTTPURLResponse) {
        if let _ = response.allHeaderFields[Constants.Auth.Keys.AccessToken] {
            userAuth = UserAuthInfo(dictionary: response.allHeaderFields as! [String : AnyObject])
        }
    }
    
    // Convert raw JSON to a Foundation object via provided callback
    private func parseJSON(_ data: Data, parseJSONCompletionHandler: handlerType) {
        var parsedResult: Any? = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            parseJSONCompletionHandler(nil, nil, NSError(domain: "parseJSONCompletionHandler",
                                                         code: 1,
                                                         userInfo: userInfo))
        }
        parseJSONCompletionHandler(self.userAuth, parsedResult as AnyObject?, nil)
    }
    
    
    // Mark: - Shared Instance
    
    class var shared: CardMineClient {
        get {
            struct Singleton {
                static var sharedInstance = CardMineClient()
            }
            return Singleton.sharedInstance
        }
    }
}
