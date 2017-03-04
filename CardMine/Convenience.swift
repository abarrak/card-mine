//
//  Convenience.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

extension CardMineClient {
    struct Constants {
        static let APIScheme    = "https"
        static let APIHost      = "localhost:3000"
        static let APIPath      = "/api/v1"
    }

    struct ParameterKeys {
        static let APIKey = "api_key"
    }

    struct ParameterValues {
        static let APIKey = ""
    }
    
    struct ResponseKeys {
    }

    struct ResponseValues {
        static let OKStatus = "ok"
    }
}
