//
//  CardsTabBarController.swift
//  CardMine
//
//  Created by Abdullah on 3/11/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class CardsTabBarController: UITabBarController {
    // Mark: - Properties
    
    var logoutButton: UIBarButtonItem? = nil
    var refershButton: UIBarButtonItem? = nil
    var newButton: UIBarButtonItem? = nil
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refersh()
    }
    
    // Mark: - Actions & Protocol
    
    func logoutPressed() {
        setUIEnabled(false)
        
        CardMineClient.shared.logout { (success, errorString) in
            
            if !success {
                performAsync({
                    super.alertMessage("Failure", message: errorString!)
                    self.setUIEnabled(true)
                })
                return
            }
            
            performAsync({
                self.setUIEnabled(true)
                
                let appDel = (UIApplication.shared.delegate as! AppDelegate)
                appDel.userAuth = nil
                
                _ = self.navigationController?.popToRootViewController(animated: true)
                // self.alertMessage("Success", message: "Logged out successfully.")
            })
        }
    }
    
    func refersh() {
        fetch()
    }
    
    func new() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    // Mark: - Methods
    
    private func setupTopBar() {
        let r : UIImage? = UIImage.init(named: "Refresh")!.withRenderingMode(.alwaysOriginal)
        let n : UIImage? = UIImage.init(named: "New")!.withRenderingMode(.alwaysOriginal)

        logoutButton    = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain,
                                          target: self,
                                          action: #selector(logoutPressed))
        styleLoginText()
        
        refershButton   = UIBarButtonItem(image: r, style: UIBarButtonItemStyle.plain,
                                          target: self, action: #selector(refersh))
        
        newButton       = UIBarButtonItem(image: n, style: UIBarButtonItemStyle.plain,
                                          target: self, action: #selector(new))
        
        navigationItem.title = "My Cards"
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [refershButton!, newButton!]
    }
    
    private func styleLoginText() {
        let darkRed = UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        let attributes = [ NSForegroundColorAttributeName : darkRed ]

        let darkRedMed = UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.7)
        let attributesMed = [ NSForegroundColorAttributeName : darkRedMed ]
        
        let darkRedLight = UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4)
        let attributesLight = [ NSForegroundColorAttributeName : darkRedLight ]

        logoutButton?.setTitleTextAttributes(attributes , for: .normal)
        logoutButton?.setTitleTextAttributes(attributesMed, for: .focused)
        logoutButton?.setTitleTextAttributes(attributesLight , for: .disabled)
    }
    
    private func setUIEnabled(_ enabled: Bool) {
        logoutButton?.isEnabled = enabled
    }
    
    private func fetch() {
        
    }
    
    private func fetchAllCardsData() {
        
    }
    
    // Mark: - Helpers
}
