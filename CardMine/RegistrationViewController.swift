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
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    // Mark: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.scale(factor: 1.4)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Mark: - Actions & Protocols

    @IBAction func signUp(_ sender: UIButton) {
        if !validatePresence() {
            alertMessage("Error", message: "Please fill in all required fields.")
            return
        }
        enableUI(false)
        spin(true)
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
            performAsync {
                self.enableUI(true)
                self.spin(false)
            }
        }

    }

    // Mark: - Methods

    func validatePresence() -> Bool {
        // The only validation the we will do ..
        // leaving the rest for API to validate.
        let fields = [emailField, passwordField, passwordConfirmationField, nicknameField]
        for f in fields {
            if (f?.text?.isBlank())! {
                return false
            }
        }
        return true
    }

    // Mark: - Resolve Keyboard/UI issue

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(_ notification: Notification) {
        if firstNameFiled.isEditing && isDeviceLandscape() {
            view.frame.origin.y = -super.getKeyboardHeight(notification)
        } else if lastNameField.isEditing {
            view.frame.origin.y = -super.getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    private func isDeviceLandscape() -> Bool {
        return UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
    }

    // Mark: - Helpers

    private func enableUI(_ enabled: Bool) {
        signUpButton.isEnabled = enabled
    }

    private func spin(_ state: Bool) {
        spinner.isHidden = !state
    }
}
