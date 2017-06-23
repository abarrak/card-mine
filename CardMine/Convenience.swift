//
//  Convenience.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation
import CoreData

extension CardMineClient {
    
    // Mark: - Definitions
    
    typealias loginCallback  = (_ success: Bool, _ errorString: String?, _ userAuth: UserAuthInfo?,
                                _ currentUser: User?) -> Void
    typealias logoutCallback = (_ success: Bool, _ errorString: String?) -> Void
    typealias signUpCallback = (_ success: Bool, _ errorString: String?, _ user: User?) -> Void
    typealias deleteAccountCallback = (_ success: Bool, _ errorString: String?) -> Void
    
    typealias contentCallback  = (_ success: Bool, _ errorString: String?, _ content: String?) -> Void
    typealias templatesCallback  = (_ success: Bool, _ errorString: String?, _ templates: [Template]?) -> Void

    typealias getCardsCallback    = (_ success: Bool, _ errorString: String?, _ cards: [Card]?) -> Void
    typealias createCardCallback  = (_ success: Bool, _ errorString: String?, _ card: Card?) -> Void
    typealias updateCardCallback  = (_ success: Bool, _ errorString: String?, _ card: Card?) -> Void
    typealias deleteCardCallback  = (_ success: Bool, _ errorString: String?, _ message: String?) -> Void

    
    // Mark: - Auth

    func login(email: String, password: String, callback: @escaping loginCallback) {
        
        let endpoint = "\(Constants.EndPoints.Auth)/\(Constants.EndPoints.SignIn)"
        let body = loginRequestBody(email: email.trim(), password: password.trim())
        
        let _ = genericApiTaks(apiEndpoint: endpoint, parameters: [:], httpMethod: "POST", jsonBody: body)
        { (auth, payload, error) in
            
            if error != nil {
                callback(false, "Login failed: \(error!.localizedDescription)", nil, nil)
                return
            }
            
            if let errors = payload?[Constants.JSONPayloadKeys.Errors] as? [String] {
                callback(false, "\(errors.first!)", nil, nil)
                return
            }
            
            // Extract json top level key and verify it has user created.
            let dataDict = payload?[Constants.JSONPayloadKeys.Data] as? [String:Any?]
            if dataDict == nil {
                callback(false, "Unexpected parsing error occured.", nil, nil)
                return
            }
            
            guard dataDict?[Constants.JSONPayloadKeys.Id] as? Int != nil else {
                callback(false, "Unexpected error occured while parsing user info.", nil, nil)
                return
            }
            
            let user = User(dictionary: dataDict as! [String : AnyObject])
            
            if var _a = auth {
                _a.currentUser = user
                callback(true, nil, _a, user)
            } else {
                callback(false, "Authentication Failed", nil, nil)
            }
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
                firstName: String?, lastName: String?, callback: @escaping signUpCallback) {
        
        let endpoint = "\(Constants.EndPoints.Auth)/"
        let body = registerRequestBody(email: email.trim(), password: password.trim(),
                                       passwordConfirmation: passwordConfirmation.trim(),
                                       nickname: nickname.trim(), firstName: firstName, lastName: lastName)

        let _ = genericApiTaks(apiEndpoint: endpoint, parameters: [:], httpMethod: "POST", jsonBody: body)
        { (auth, payload, error) in

            if error != nil {
                callback(false, "Sign up failed: \(error!.localizedDescription)", nil)
                return
            }

            if let errors = payload?[Constants.JSONPayloadKeys.Errors] as? [String:Any?] {
                callback(false, self.stringifyErrorDictionary(errors), nil)
                return
            }

            // Extract json top level key and verify it has user created.
            let dataDict = payload?[Constants.JSONPayloadKeys.Data] as? [String:Any?]
            if dataDict == nil {
                callback(false, "Unexpected parsing error occured.", nil)
                return
            }

            guard dataDict?[Constants.JSONPayloadKeys.Id] as? Int != nil else {
                callback(false, "Unexpected error occured while parsing sign up info.", nil)
                return
            }

            let user = User(dictionary: dataDict as! [String : AnyObject])
            if user.id != 0 {
                callback(true, nil, user)
            } else {
                callback(false, "Sign Up Failed", nil)
            }
        }
  }
    
    func deleteAccount(callback: @escaping deleteAccountCallback) {
        // TODO ..
    }
    
    func updateAccount() {
        // TODO ..
    }
    
    // Mark: - Resources
    
    func getAllTemplates(callback: @escaping templatesCallback) {
        let endpoint = "\(Constants.EndPoints.Templates)/"
        
        let _ = genericApiTaks(apiEndpoint: endpoint, parameters: [:], httpMethod: "GET", jsonBody: nil) { (auth, payload, error) in
            
            if error != nil {
                callback(false, "Server Erro: \(error!.localizedDescription)", nil)
                return
            }
            
            if let errors = payload?[Constants.JSONPayloadKeys.Errors] as? [String:Any?] {
                callback(false, "Load Error. \(errors)", nil)
                return
            }
            
            if let templates = payload as? [[String : Any]]  {
                callback(true, nil, Template.buildList(templates))
            } else {
                callback(false, "Unable to parse server results !", nil)
            }
        }
    }
    
    func getCards(auth: UserAuthInfo, context: NSManagedObjectContext, callback: @escaping getCardsCallback) {
        let endpoint = "\(Constants.EndPoints.Cards)/"
        
        let _ = genericApiTaks(apiEndpoint: endpoint, parameters: [:], httpMethod: "GET", jsonBody: nil, auth: auth) { (auth, payload, error) in
            
            if error != nil {
                callback(false, "Server Error: \(error!.localizedDescription)", nil)
                return
            }
            
            if let errors = payload?[Constants.JSONPayloadKeys.Errors] as? [String:Any?] {
                callback(false, "Loading Error. \n\(errors)", nil)
                return
            }
            
            if let cards = payload as? [[String : Any]]  {
                callback(true, nil, Card.buildList(cards, context: context))
            } else {
                callback(false, "Unable to parse server results !", nil)
            }
        }
    }
    
    func createCard(card: Card, auth: UserAuthInfo, context: NSManagedObjectContext, callback: @escaping createCardCallback) {
        let endpoint = "\(Constants.EndPoints.Cards)/"
        
        let _ = genericApiTaks(apiEndpoint: endpoint, parameters: [:], httpMethod: "POST", jsonBody: card.toJSON(), auth: auth) { (auth, payload, error) in
            
            if error != nil {
                callback(false, "Server Error: \(error!.localizedDescription)", nil)
                return
            }
            
            if let errors = payload?[Constants.JSONPayloadKeys.Errors] as? [String:Any?] {
                callback(false, "Loading Error. \n\(errors)", nil)
                return
            }
            
            if let card = payload as? [String : Any]  {
                callback(true, nil, Card(card, context: context))
            } else {
                callback(false, "Unable to parse server results !", nil)
            }
        }
    }
    
    func updateCard() {
    }
        
    func deleteCard() {
    }
    
    func getTextualContents() {
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
    
    private func registerRequestBody(email: String, password: String, passwordConfirmation: String,
                                     nickname: String, firstName: String?, lastName: String?) -> String {
        var body = "{\"\(Constants.JSONPayloadKeys.Email)\": \"\(email)\", \"\(Constants.JSONPayloadKeys.Password)\": \"\(password)\", \"\(Constants.JSONPayloadKeys.PasswrodConfirmation)\": \"\(passwordConfirmation)\", \"\(Constants.JSONPayloadKeys.Nickname)\": \"\(nickname)\""

        if let fN = firstName {
            body += ", \"\(Constants.JSONPayloadKeys.FirstName)\": \"\(fN.trim())\""
        }
        if let lN = lastName {
            body += ", \"\(Constants.JSONPayloadKeys.LastName)\": \"\(lN.trim())\""
        }
        body += "}"
        return body
    }
    
    private func stringifyErrorDictionary(_ errorsDict: [String:Any?]) -> String? {
        var errorsList: [String] = []

        if let errors = errorsDict["full_messages"] as? [String] {
            errorsList.append("* Please correct the following errors: \n")
            for e in errors {
                errorsList.append("– \(e).\n")
            }
        }
        return errorsList.joined(separator: "")
    }
}
