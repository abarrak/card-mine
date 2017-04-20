//
//  LoginViewController.swift
//  CardMine
//
//  Created by Abdullah on 2/28/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // Mark: - Properties
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // Mark: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeForLoginScreen(true)
        passIfLoggedIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        customizeForLoginScreen(false)
    }

    // Mark: - Methods
    
    private func customizeForLoginScreen(_ customized: Bool) {
        self.navigationController?.isNavigationBarHidden = customized
        customized ? subscribeToKeyboardNotifications() : unsubscribeFromKeyboardNotifications()
    }
    
    private func passIfLoggedIn() {
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        
        if let _ = appDel.userAuth {
            navigateToCards()
        } else {
            if let storedLogin = UserAuthInfo.retrieve() {
                appDel.userAuth = storedLogin
                navigateToCards()
            }
        }
    }
    
    private func login() {
        setUIEnabled(false)
        
        let email = emailText.text!, password = passwordText.text!
        
        CardMineClient.shared.login(email: email, password: password) {(success, error, auth) in
            if !success {
                performAsync { self.alertMessage("Falied", message: error ?? "Unexpected Error") }
            } else {
                performAsync {
                    self.persistAuthUserInfo(userAuth: auth!)
                    self.navigateToCards()
                }
            }
            performAsync { self.setUIEnabled(true) }
        }
    }
    
    private func persistAuthUserInfo(userAuth: UserAuthInfo) {
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        appDel.userAuth = userAuth
        appDel.userAuth?.persist()
    }
    
    private func navigateToCards() {
        let c = storyboard?.instantiateViewController(withIdentifier: "cardsTabBar") as! CardsTabBarController
        navigationController?.pushViewController(c, animated: true)
    }
    
    private func setUIEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    // Mark: - Actions & Protocols
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if areUserCredentialsBlank() {
            return
        }
        
        login()
    }
    
    @IBAction func presentRegistrationScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "showRegistration", sender: self)
    }
    
    @IBAction func presentAboutPage(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAbout", sender: self)
    }
    
    @IBAction func presentContactPage(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showContact", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAbout" {
            let staticContentVC = segue.destination as! StaticContentViewController
            staticContentVC.requestedPage = StaticContentViewController.StaticPage.about
        }
        
        if segue.identifier == "showContact" {
            let staticContentVC = segue.destination as! StaticContentViewController
            staticContentVC.requestedPage = StaticContentViewController.StaticPage.contact
        }
    }

    // Mark: - Helpers
    
    private func areUserCredentialsBlank() -> Bool {
        return (emailText.text?.isBlank())! || (passwordText.text?.isBlank())! ? true : false
    }
    
    private func isDeviceLandscape() -> Bool {
        return UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
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
        if emailText.isEditing && isDeviceLandscape() {
            view.frame.origin.y = -super.getKeyboardHeight(notification)
        } else if passwordText.isEditing {
            view.frame.origin.y = -super.getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
}
