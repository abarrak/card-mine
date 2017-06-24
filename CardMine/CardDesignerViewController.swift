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
    @IBOutlet weak var textInsertButton: UIBarButtonItem!
    @IBOutlet weak var colorButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var helpButton: UIBarButtonItem!
    
    var insertedText: UITextField?
    var textInsertColor = UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let insertedTextInitialTag = 995
    var insertedTextTag = CardDesignerViewController.insertedTextInitialTag

    var newCardTitle: String?

    var navToImageIndex: Int?

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
        super.viewWillAppear(animated)
        setInitalCardImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initiateDesigner()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navToImageIndex = nil
        destroyTextField()
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
        setImageAtIndex(row)
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
    
    @IBAction func insertText(_ sender: UIBarButtonItem) {
        attachTextField()
    }

    @IBAction func showHelpPopup() {
        let helpText = "* Use insert icon to create texts. \n" +
            "* Move it around by touch and drag. \n" +
            "* Insert new text again and move it around. \n\n" +
            "* You can colorize as your preference. \n\n" +
        "* Save/delete card with right buttons."
        alertMessage("Help", message: helpText)
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        // generate card ..
        let genImage = generateCardImage()

        // If title is given, save card then navigate to it in viewer ..
        askForTitle() {
            let final = FinalCard(title: self.newCardTitle!, image: genImage, context: self.context)
            self.saveInStore()
            self.goToViewer(final)
        }
    }

    @IBAction func trash(_ sender: UIBarButtonItem) {
        alertQuestion("Discard", message: "Discard current card ?") { (alert) in
            self.closeDesigner()
        }
    }

    func setColorCallback (_ color: UIColor) {
        colorButton.tintColor = color
        textInsertColor = color
        textInsertButton.tintColor = color
        insertedText?.textColor = color
    }

    func listenToTemplatesArrival() {
        setInitalCardImage()
        templatePicker.reloadAllComponents()
    }

    // Mark: - Methods
    
    private func configureDesigner() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.listenToTemplatesArrival),
                                               name: NSNotification.Name(AllTemplates.templatesNotificationId),
                                               object: nil)
    }
    
    private func initiateDesigner() {
        if let i = navToImageIndex {
            setImageAtIndex(i)
            templatePicker.selectRow(i, inComponent: 0, animated: true)
        }
    }
    
    private func setInitalCardImage() {
        if let m = templates.first?.imgObject {
            cardImage.image = UIImage(data: m as Data)
        }
    }
    
    private func setImageAtIndex(_ index: Int) {
        if let m = templates[index].imgObject {
            cardImage.image = UIImage(data: m as Data)
        }
    }

    private func registerInsertedTextDragGestures() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged))
        insertedText?.addGestureRecognizer(gesture)
        insertedText?.isUserInteractionEnabled = true
    }

    private func unregisterInsertedTextDragGestures() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged))
        insertedText?.removeGestureRecognizer(gesture)
    }

    func userDragged(_ gesture: UIPanGestureRecognizer){
        var loc = gesture.location(in: self.view)

        let coords = getBoundingLimitsOfImage()
        let y = coords["y"]!, h = coords["h"]!

        if Int(loc.y) > (y + h) {
            loc.y = CGFloat(y + h - 1)
        }

        if Int(loc.y) < (y - h) {
            loc.y = CGFloat(y + 1)
        }

        self.insertedText?.center = loc
    }

    private func getBoundingLimitsOfImage() -> [String:Int] {
        let coords = calculateRectOfImage(imageView: cardImage)
        return ["x": Int(coords.origin.x),
                "y": Int(coords.origin.y),
                "w": Int(coords.size.width),
                "h": Int(coords.size.height)]
    }

    private func generateCardImage() -> UIImage {
        UIGraphicsBeginImageContext(cardImage.frame.size)
        cardImage.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    private func askForTitle(completed: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Title?",
                                                message: "please enter title for card:",
                                                preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }

        alertController.addAction(UIAlertAction(title: "Confirm", style: .default) { (action) in
            if let field = alertController.textFields?[0] {
                self.newCardTitle = field.text
                completed()
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) in })

        self.present(alertController, animated: true, completion: nil)
    }

    private func goToViewer(_ card: FinalCard) {
        let viewer = storyboard?.instantiateViewController(withIdentifier: "cardViewer")
                     as! CardViewerViewController
        viewer.setCard(card)
        navigationController?.pushViewController(viewer, animated: true)
    }

    // Mark: - Helpers
    
    private func attachTextField() {
        if insertedText != nil {
            unregisterInsertedTextDragGestures()
        }

        let coords = getBoundingLimitsOfImage()
        insertedText = generateTextField(x: coords["x"]! + 80, y: coords["y"]! + 20, w: 190, h: 30,
                                         tag: insertedTextTag)
        insertedTextTag += 1
        cardImage.isUserInteractionEnabled = true
        cardImage.addSubview(insertedText!)
        registerInsertedTextDragGestures()
    }
    
    private func destroyTextField() {
        let firstTag = CardDesignerViewController.insertedTextInitialTag
        let lastTag = insertedTextTag

        for tag in (firstTag...lastTag) {
            cardImage.viewWithTag(tag)?.removeFromSuperview()
        }
    }
    
    private func generateTextField(x: Int, y: Int, w: Int, h: Int, tag: Int) -> UITextField {
        let textField = UITextField(frame: CGRect(x: x, y: y, width: w, height: h))
        textField.placeholder = "Your text here ..."
        textField.tag = insertedTextTag
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = textInsertColor
        textField.borderStyle = UITextBorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.textAlignment = NSTextAlignment.center
        textField.isUserInteractionEnabled = true

        return textField
    }

    private func moveTextFieldAround(textfield: UITextField, x: Int, y: Int, width: Int, height: Int) {
        let x = CGFloat(x)
        let y = CGFloat(y)
        let w = CGFloat(width)
        let h = CGFloat(height)
        
        textfield.frame = CGRect(x: x, y: y, width: w, height: h)
    }

    private func calculateRectOfImage(imageView: UIImageView) -> CGRect {
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

    private func closeDesigner() {
        let _ = navigationController?.popViewController(animated: true)
    }
}
