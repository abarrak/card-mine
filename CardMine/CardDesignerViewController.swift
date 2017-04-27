//
//  CardDesignerViewController.swift
//  CardMine
//
//  Created by Abdullah on 4/10/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import CoreGraphics

class CardDesignerViewController: UIViewController, UIPopoverPresentationControllerDelegate,
UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate  {
    
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
        attachTextField()
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
    
    private func getBoundingLimitsOfImage() -> [String:Int]? {
        if let cardImg = cardImage.image {
            return ["x": Int(cardImage.frame.origin.x),
                    "y": Int(cardImage.frame.origin.y),
                    "w": Int(cardImg.size.width),
                    "h": Int(cardImg.size.height)]
        }
        return nil
    }
    
    // Mark: - Helpers
    
    private func attachTextField() {
        let coords = getBoundingLimitsOfImage()!
        print(coords)
        
        let textField = generateTextField(x: coords["x"]! + 20, y: coords["y"]! + 20, w: 70, h: 30)
        view.addSubview(textField)

        print(calculateRectOfImageInImageView(imageView: cardImage))
    }
    
    private func destroyTextField() {
    }
    
    private func moveTextField(x: Int, y: Int) {
        
    }

    private func generateTextField(x: Int, y: Int, w: Int, h: Int) -> UITextField {
        let textField = UITextField(frame: CGRect(x: x, y: y, width: w, height: h))
        
        textField.placeholder = "Your text here .."
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextBorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.isUserInteractionEnabled = true
        textField.textAlignment = NSTextAlignment.center
        return textField
    }

    private func registerGestures(textField: UITextField) {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.allowableMovement = 15
        longPressGesture.delegate = self
        
        textField.addGestureRecognizer(longPressGesture)
    }
    
    func handleLongPress(_ gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            let touchPoint = gestureRecognizer.location(in: view)
            
            _ = ["x": Int(touchPoint.x), "y": Int(touchPoint.y)]
        }
    }

    func calculateRectOfImageInImageView(imageView: UIImageView) -> CGRect {
        let imageViewSize = imageView.frame.size
        let imgSize = imageView.image?.size
        
        guard let imageSize = imgSize, imgSize != nil else {
            return CGRect.zero
        }
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        // Center image
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        // Add imageView offset
        imageRect.origin.x += imageView.frame.origin.x
        imageRect.origin.y += imageView.frame.origin.y
        
        return imageRect
    }
    
    // Mark: - Resolve Keyboard/UI issue
}
