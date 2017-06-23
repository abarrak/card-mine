//
//  RegistrationViewController.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    // Mark: - Properties

    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var firstNameFiled: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    // Mark: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Mark: - Actions & Protocols

    @IBAction func signUp(_ sender: UIButton) {
        if !validatePresence() {
            alertMessage("Error", message: "Please fill in all required fields.")
            return
        }
        enableUI(false)

        CardMineClient.shared.signUp(email: emailField.text!, password: passwordField.text!,
                                     passwordConfirmation: passwordConfirmationField.text!,
                                     nickname: nicknameField.text!,
                                     firstName: firstNameFiled.text!,
                                     lastName: lastNameField.text!) { (success, error, user) in
            if !success {
                performAsync {
                    self.alertAlignedMessage("Failed",
                                             message: error ?? "Unexpected Error during registration.")
                }
            } else {
                var message = "Hey \((user?.nickname)! as String) !\n\n"
                message += "You've signed up successfully \n"
                message += "We've send you confirmation email. Please verifiy using it then sign in app."

                performAsync {
                    self.alertMessage("Success", message: message) { (action) in
                        let _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            performAsync { self.enableUI(true) }
        }

    }

    // Mark: - Methods

    func validatePresence() -> Bool {
        // the only validation the we will do .. 
        // API validates it also with the rest ..
        let fields = [emailField, passwordField, passwordConfirmationField, nicknameField]
        for f in fields {
            if (f?.text?.isBlank())! {
                return false
            }
        }
        return true
    }

    // Mark: - Resolve Keyboard/UI issue

    // Mark: - Helpers

    private func enableUI(_ enabled: Bool) {
        signUpButton.isEnabled = enabled
    }
}
