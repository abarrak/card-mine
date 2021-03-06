//
//  AbstractAPI.swift
//  CardMine
//
//  Created by Abdullah on 2/28/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class AbstractAPI: NSObject {
    
    // Mark: - Type definitions
    
    // Define a generic completion handler closure for api tasks
    typealias handlerType = (_ auth: UserAuthInfo?, _ payload: AnyObject?, _ error: NSError?) -> Void
        

    // Mark: - Methods

    func isNetworkAvaliable() -> Bool {
        let reachability = Reachability()!
        return reachability.currentReachabilityStatus == .notReachable ? false : true
    }
    
    func notifyDisconnectivity(_ completionHandler: @escaping handlerType) {
        let userInfo = [NSLocalizedDescriptionKey : "No connectivity !"]
        completionHandler(nil, nil, NSError(domain: "Network Status", code: 2, userInfo: userInfo))
    }
}
