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
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickFromCameraButton: UIBarButtonItem!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let memeTextAttributes: [String : Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSStrokeWidthAttributeName : -3.0,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        topTextField.tag = 0
        bottomTextField.tag = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pickFromCameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: Delegate Attributes
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            switch text {
            case "TOP TEXT...", "BOTTOM TEXT...":
                textField.text = ""
            default:
                self.currentTextField.text = textField.text
            }
        }
        self.toolBar.isHidden = true
        self.currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.toolBar.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions from view
    
    @IBAction func pickImage(_ sender: UIButton) {
        if sender.tag == 0 {
            pickImage(from: .camera)
        } else {
            pickImage(from: .photoLibrary)
        }
    }
    
    // MARK: Custom methods
    
    func pickImage(from source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func getDistanceFromBottom() -> CGFloat {
        let distance = ((self.view.frame.height) - (self.viewContainer.frame.height))
        return round(distance/2)
    }
    
    func getDistanceFromTop() -> CGFloat {
        let distance = self.viewContainer.frame.height + getDistanceFromBottom()
        return round(distance)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification)
        
        if currentTextField.tag == 0 {
            let distanceFromTop = getDistanceFromTop()
            if keyboardHeight > distanceFromTop {
                // Reset the view
                self.view.frame.origin.y = 0
                // Adjust the view
                self.view.frame.origin.y -= keyboardHeight - distanceFromTop
            }
        }
        
        if currentTextField.tag == 1 {
            let distanceFromBottom = getDistanceFromBottom()
            if keyboardHeight > distanceFromBottom {
                // Reset the view
                self.view.frame.origin.y = 0
                // Adjust the view
                self.view.frame.origin.y -= (keyboardHeight - distanceFromBottom)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification)
        
        if currentTextField.tag == 0 {
            let distanceFromTop = getDistanceFromTop()
            if keyboardHeight > distanceFromTop {
                self.view.frame.origin.y = 0
            }
        }
        
        if currentTextField.tag == 1 {
            let distanceFromBottom = getDistanceFromBottom()
            if keyboardHeight > distanceFromBottom {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
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
}

