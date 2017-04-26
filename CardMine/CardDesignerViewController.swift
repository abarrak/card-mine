//
//  CardDesignerViewController.swift
//  CardMine
//
//  Created by Abdullah on 4/10/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class CardDesignerViewController: UIViewController, UIPopoverPresentationControllerDelegate,
UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {
    
    // Mark: - Properties
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var templatePicker: UIPickerView!
    @IBOutlet weak var textInsert: UIBarButtonItem!
    @IBOutlet weak var colorPicker: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var helpButton: UIBarButtonItem!
    
    var textInsertColor = UIColor.red
    
    var templates: [Template] {
        get {
            return AllTemplates.templates
        }
    }
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesigner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setInitalCardImage()
    }
    
    // Mark: - Actions & Protocols
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return templates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return templates[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let rowTitle = templates[row].name
        
        let lightRed = UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        let attr = NSAttributedString(string: rowTitle, attributes: [NSForegroundColorAttributeName : lightRed])
        
        return attr
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let m = templates[row].imgObject {
            cardImage.image = UIImage(data: m as Data)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @IBAction func showColorPicker(_ sender: UIBarButtonItem) {
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover")
                        as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.barButtonItem = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverVC.delegate = self
        }
        
        present(popoverVC, animated: true, completion: nil)
    }
    
    func setColorCallback (_ color: UIColor) {
        colorPicker.tintColor = color
        textInsertColor = color
        textInsert.tintColor = color
    }
    
    @IBAction func insertText(_ sender: UIBarButtonItem) {
        
    }

    func listenToTemplatesArrival() {
        self.templatePicker.reloadAllComponents()
        setInitalCardImage()
    }
    
    @IBAction func showHelpPopup() {
        let helpText = "* Use insert icon to create texts. \n" +
                       "* Move it around by touch and drag. \n\n" +
                       "* You can colorize as your preference. \n\n" +
                       "* To delete a text tap and hold. \n\n" +
                       "* Save/delete card with right buttons."
        alertMessage("Help", message: helpText)
    }
    
    // Mark: - Methods
    
    private func configureDesigner() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.listenToTemplatesArrival),
                                               name: NSNotification.Name(AllTemplates.templatesNotificationId),
                                               object: nil)
    }
    
    private func setInitalCardImage() {
        if let m = templates.first?.imgObject {
            cardImage.image = UIImage(data: m as Data)
        }
    }
    
    private func insertTextTopOfCardImage() {
        
    }
    
    private func moveTextFieldAroundCardImage() {
        
    }
    
    private func getBoundingLimitsOfImage() -> [String:Float]? {
        if let cardImg = cardImage.image {
            return ["x": Float(cardImage.frame.minX),
                    "y": Float(cardImage.frame.minY),
                    "w": Float(cardImg.size.width),
                    "h": Float(cardImg.size.height)]
        }
        return nil
    }
    
    // Mark: - Helpers
    
    private func generateTextField(x: Int, y: Int, w: Int, h: Int) {
        let textField = UITextField(frame: CGRect(x: x, y: y, width: w, height: h))
        
        textField.placeholder = "Your text here .."
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextBorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.isUserInteractionEnabled = true
        textField.textAlignment = NSTextAlignment.center
    }
    
    private func destroyTextField() {
        
    }

    // Mark: - Resolve Keyboard/UI issue
}
