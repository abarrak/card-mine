//
//  AsyncHelpers.swift
//  CardMine
//
//  Created by Abdullah on 2/28/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

func performAsync(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

typealias completionHandler =  (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void

func getImageAsync(url: URL, completion: @escaping completionHandler) {
    URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        completion(data, response, error)
    }.resume()
}
