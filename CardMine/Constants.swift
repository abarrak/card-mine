//
//  Constants.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

extension CardMineClient {

    struct Constants {
        static let APIScheme    = "https"
        static let APIHost      = "cardmine.herokuapp.com"
        static let APIPath      = "/api/v1/"
        
        struct EndPoints {
            static let Auth     = "auth"
            static let SignIn   = "sign_in"
            static let SignOut  = "sign_out"
            
            static let About            = "about"
            static let Contact          = "contact"
            static let Templates        = "templates"
            static let Cards            = "cards"
            static let TextualContent   = "textual_content"
        }
        
        struct JSONPayloadKeys {
            // Top level keys
            static let Success = "success"
            static let Error = "error"
            
            static let Status = "status"
            static let Errors = "errors"
            static let Data   = "data"
            
            // resources shared keys
            static let Id                   = "id"
            static let CreatedAt            = "created_at"
            static let UpdatedAt            = "updated_at"

            // User resource keys
            static let Email                = "email"
            static let Password             = "password"
            static let PasswrodConfirmation = "password_confirmation"
            static let Nickname             = "nickname"
            static let FirstName            = "first_name"
            static let LastName             = "last_name"
            
            
            // Template resource keys
            
            // Card resource keys
            static let Title        = "title"
            static let Description  = "description"
            static let UserId       = "user_id"
            static let TemplateId   = "template_id"
            static let Draft        = "draft"
            static let TextualContentAttributes = "textual_content_attributes"
            
            // Textual Content resource keys
            static let Content                  = "content"
            static let FontFamily               = "font_family"
            static let FontSize                 = "font_size"
            static let Color                    = "color"
            static let XPosition                = "x_position"
            static let YPosition                = "y_position"
            static let Width                    = "width"
            static let Height                   = "height"
        }

        struct Auth {
            struct Keys {
                static let ApiAccessToken = "Authorization"
                static let TokenType      = "Token-Type"
                static let AccessToken    = "Access-Token"
                static let Client         = "Client"
                static let Expiry         = "Expiry"
                static let UID            = "Uid"
            }
            
            struct Values {
                static let ApiAccessToken =
                "Token token=rKSi7R7gx_lSiDqXxE1udbOO9CNjnpKByWgxdsykAfXTUu3g9coti2na0HfvlzJt"
            }
        }
    }
}
