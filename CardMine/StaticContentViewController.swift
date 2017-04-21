//
//  StaticContentViewController.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

typealias staticPage = StaticContentViewController.StaticPage

class StaticContentViewController: UIViewController {
    // Mark: - Properties
    
    enum StaticPage {
        case about
        case contact
    }
    var requestedPage: StaticPage?

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var pagePhoto: UIImageView!
    @IBOutlet weak var pageContent: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        turnToPage()
        pageContent.centerVertically()
        spinner.scale(factor: 1.8)
    }
    
    // Mark: - Actions & Protocols
    
    @IBAction func closePage(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        pageContent.font = pageContent.font?.withSize(CGFloat(sender.value))
        pageContent.centerVertically()
    }
    
    // Mark: - Methods
    
    private func turnToPage() {
        switch requestedPage! {
        case .about:
            setupPage("About")
        case .contact:
            setupPage("Contact")
        }
    }
    
    private func setupPage(_ name: String) {
        pageTitle.text = name
        pagePhoto.image = UIImage(named: "\(name) Photography")
        loadContent()
    }

    func rotated() {
        pageContent.centerVertically()
    }
    
    private func loadContent() {
        spin(true)
        
        try? CardMineClient.shared.getPage(page: requestedPage!) { (success, erorrString, content) in
            performAsync {
                if success {
                    self.pageContent.text = content
                    self.pageContent.centerVertically()
                } else {
                    self.alertMessage("Exception", message: erorrString!)
                }
                self.spin(false)
            }
        }
    }
    
    private func spin(_ state: Bool) {
        spinner.isHidden = !state
    }
}
