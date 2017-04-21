//
//  Convenience.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

extension CardMineClient {
    
    // Mark: - Definitions
    
    typealias loginCallback  = (_ success: Bool, _ errorString: String?, _ userAuth: UserAuthInfo?) -> Void
    typealias logoutCallback = (_ success: Bool, _ errorString: String?) -> Void
    typealias signUpCallback = (_ success: Bool, _ errorString: String?, _ user: User) -> Void
    typealias deleteAccountCallback = (_ success: Bool, _ errorString: String?) -> Void
    
    typealias contentCallback  = (_ success: Bool, _ errorString: String?, _ content: String?) -> Void
    
    
    // Mark: - Auth

    func login(email: String, password: String, callback: @escaping loginCallback) {
        
        let endpoint = "\(Constants.EndPoints.Auth)/\(Constants.EndPoints.SignIn)"
        let body = loginRequestBody(email: email.trim(), password: password.trim())
        
        let _ = genericApiTaks(apiEndpoint: endpoint, parameters: [:], httpMethod: "POST", jsonBody: body)
        { (auth, payload, error) in
            
            if error != nil {
                callback(false, "Login failed: \(error!.localizedDescription)", nil)
                return
            }
            
            if let errors = payload?[Constants.JSONPayloadKeys.Errors] as? [String] {
                callback(false, "Login failed. \(errors)", nil)
                return
            }
            
            // Extract json top level key and verify it has user created.
            let dataDict = payload?[Constants.JSONPayloadKeys.Data] as? [String:Any?]
            if dataDict == nil {
                callback(false, "Unexpected parsing error occured.", nil)
                return
            }
            
            guard dataDict?[Constants.JSONPayloadKeys.Id] as? Int != nil else {
                callback(false, "Unexpected error occured while parsing user info.", nil)
                return
            }
            
            // Extract our auth values from response headers
            auth == nil ? callback(false, "Authentication Failed", nil) : callback(true, nil, auth)
        }
    }
    
    func logout(callback: @escaping logoutCallback) {
        let endpoint = "\(Constants.EndPoints.Auth)/\(Constants.EndPoints.SignOut)"
        
        let _ = genericApiTaks(apiEndpoint: endpoint, parameters: [:], httpMethod: "DELETE", jsonBody: nil)
        { (auth, payload, error) in
            
            if error != nil {
                callback(false, "Loguot failed: \(error!.localizedDescription)")
                return
            }
            
            if let errors = payload?[Constants.JSONPayloadKeys.Errors] as? [String:Any?] {
                callback(false, "Loguot failed. \(errors)")
                return
            }
            
            let status = payload?[Constants.JSONPayloadKeys.Success] as? Bool
            status == false ? callback(false, "Logout Failed") : callback(true, nil)
        }
    }
    
    func signUp(email: String, password: String, passwordConfirmation: String, nickname: String,
                firstName: String, lastName: String, callback: @escaping signUpCallback) {
        
    }
    
    func deleteAccount(callback: @escaping deleteAccountCallback) {
        // TODO ..
    }
    
    func updateAccount() {
        // TODO ..
    }
    
    // Mark: - Resources
    
    func getAllTemplates() {
    }
    
    func getAllCards() {
    }
    
    func createCard() {
    }
    
    func updateCard() {
    }
    
    func getCard() {
    }
    
    func deleteCard() {
    }
    
    func addTextualContentToCard() {
    }
    
    func updateTextualContentOfCard() {
    }

    func deleteTextualContentFromCard() {
    }
    
    func getPage(page: staticPage, callback: @escaping contentCallback) throws {
        var endpoint = ""
        
        switch page {
            case .about:
                endpoint = "\(Constants.EndPoints.About)"
            case .contact:
                endpoint = "\(Constants.EndPoints.Contact)"
        }
        
        let _ = genericApiTaks(apiEndpoint: endpoint, parameters: [:], httpMethod: "GET", jsonBody: nil)
        { (auth, payload, error) in
            
            if error != nil {
                callback(false, "Fetch data failed: \(error!.localizedDescription)", nil)
                return
            }
            
            if let errors = payload?[Constants.JSONPayloadKeys.Errors] as? [String:Any?] {
                callback(false, "Fetch data failed. \(errors)", nil)
                return
            }
            
            let status = payload?[Constants.JSONPayloadKeys.Success] as? Bool
            let content = payload?[Constants.JSONPayloadKeys.Content] as? String
            
            if status == false || content == nil {
                callback(false, "Parsing data failed", nil)
            } else {
                let _c = content?.replacingOccurrences(of: "\n", with: "\n\n")
                callback(true, nil, _c)
            }
        }
    }
    
    // Mark: - Helpers
    
    private func loginRequestBody(email: String, password: String) -> String {
        return "{\"\(Constants.JSONPayloadKeys.Email)\": \"\(email)\", \"\(Constants.JSONPayloadKeys.Password)\": \"\(password)\"}"
    }
    
    private func registerRequestBody() {
        
    }
    
    private func unpackErrorDictionary(errors: [String:Any?]) -> String? {
        return nil
    }
}
