//
//  ViewController.swift
//  MemeMe
//
//  Created by Alan Campos on 5/8/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var currentTextField: UITextField!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickFromCameraButton: UIBarButtonItem!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var chooseImageLabel: UILabel!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    let memeTextAttributes: [String : Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSStrokeWidthAttributeName : -3.0,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        share.isEnabled = false
        prepareTextField(textField: topTextField)
        prepareTextField(textField: bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chooseImageLabel.layer.masksToBounds = true
        chooseImageLabel.layer.cornerRadius = 5
        super.viewWillAppear(animated)
        pickFromCameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func prepareTextField(textField: UITextField) {
        textField.delegate = self
        textField.tag = (textField == topTextField) ? 0 : 1
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    // MARK: Delegate Attributes
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            switch text {
            case "TOP TEXT...", "BOTTOM TEXT...":
                textField.text = ""
            default:()
            }
        }
        bottomToolbar.isHidden = true
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text == "" && currentTextField.tag == 0 {
                textField.text = "TOP TEXT..."
            }
            if text == "" && currentTextField.tag == 1 {
                textField.text = "BOTTOM TEXT..."
            }
        }
        currentTextField = textField
        bottomToolbar.isHidden = false
    }
    
    // MARK: Actions from view
    
    @IBAction func pickImage(_ sender: UIButton) {
        (sender.tag == 0) ? chooseImage(from: .camera) : chooseImage(from: .photoLibrary)
    }
    
    // MARK: Custom methods
    
    func chooseImage(from source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: {
            self.share.isEnabled = true
            self.chooseImageLabel.isHidden = true
        })
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func getDistanceFromBottom() -> CGFloat {
        let distance = ((view.frame.height) - (viewContainer.frame.height))
        return round(distance/2)
    }
    
    func getDistanceFromTop() -> CGFloat {
        let distance = viewContainer.frame.height + getDistanceFromBottom()
        return round(distance)
    }
    
    // Detect automatically if the view needs to move to accomodate the currently active text field and move the view just the right amount
    
    func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification)
        
        if currentTextField.tag == 0 {
            let distanceFromTop = getDistanceFromTop()
            if keyboardHeight > distanceFromTop {
                // Reset the position to avoid an issue where the view keeps moving up if you switch between fields without hitting the return key
                self.view.frame.origin.y = 0
                // Adjust the view
                self.view.frame.origin.y -= keyboardHeight - distanceFromTop
            }
        }
        
        if currentTextField.tag == 1 {
            let distanceFromBottom = getDistanceFromBottom()
            if keyboardHeight > distanceFromBottom {
                // Reset the position to avoid an issue where the view keeps moving up if you switch between fields without hitting the return key
                self.view.frame.origin.y = 0
                
                self.view.frame.origin.y -= (keyboardHeight - distanceFromBottom)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Others
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        appDelegate.memes.append(meme)
    }
    
    func hideToolbar(_ bool: Bool) {
        topToolbar.isHidden = bool
        bottomToolbar.isHidden = bool
    }
    
    func generateMemedImage() -> UIImage {
        
        hideToolbar(true)
        
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbar(false)

        return memedImage
    }
    
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.save()
                //Dismiss the view controller
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
}
