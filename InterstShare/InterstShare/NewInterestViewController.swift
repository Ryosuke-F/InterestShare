//
//  NewInterestViewController.swift
//  InterstShare
//
//  Created by Ryosuke Fukuda on 7/22/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Photos

class NewInterestViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var newInterestTitleTextField: DesignableTextField!
    @IBOutlet weak var newInterestDescriptionTextView: UITextView!
    
    @IBOutlet weak var createNewInterest: DesignableButton!
    @IBOutlet weak var selectFeaturedImageButton: DesignableButton!
    
    @IBOutlet var hideKeyboardInputAxccessaryView: UIView!
    
    private var featuredImage: UIImage!
    
    //MARK: - VC Life circle
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newInterestTitleTextField.inputAccessoryView = hideKeyboardInputAxccessaryView
        newInterestDescriptionTextView.inputAccessoryView = hideKeyboardInputAxccessaryView

        newInterestTitleTextField.becomeFirstResponder()
        newInterestTitleTextField.delegate = self
        newInterestDescriptionTextView.delegate = self
        
        //Notification Center - keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    //MARK: - Text View Handler
    //it will remove all the obsserver when I close it
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
        
        self.newInterestDescriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.newInterestDescriptionTextView.scrollIndicatorInsets = self.newInterestDescriptionTextView.contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.newInterestDescriptionTextView.contentInset = UIEdgeInsetsZero
        self.newInterestDescriptionTextView.scrollIndicatorInsets = UIEdgeInsetsZero
        
    }

    
    

    //Target action
    @IBAction func dismiss(sender: UIButton) {
        print("dismiss")
        
        hideKeyboard()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func selectFeaturedImageButtonClicked(sender: DesignableButton) {
        print("selectFeaturedImageButtonClicked")
        
        if newInterestDescriptionTextView.text == "Describe your new interest..." || newInterestTitleTextField.text.isEmpty {
            
            shakeTextField()
        } else if featuredImage == nil {
            
            shakePhotoButton()
        } else {
            //create a new interest
            //..
            
            self.hideKeyboard()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    
    
    @IBAction func createNewInterestButtonClicked(sender: DesignableButton) {
        print("createNewInterestButtonClicked")
        
        let authrization = PHPhotoLibrary.authorizationStatus()
        
        if authrization == .NotDetermined {
            
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.selectFeaturedImageButtonClicked(sender)
                })
            })
            
            return
        }
        
        if authrization == .Authorized {
            let controller = ImagePickerSheetController()
            
            controller.addAction(ImageAction(title: NSLocalizedString("Take a Photo or Video",  comment: "ActionTitle"), secondaryTitle: NSLocalizedString("Use this one", comment: "Action Title"), handler: { (_) -> () in
                self.presentCamera()
                
                }, secondaryHandler: { (action, numberOfPhoto) -> () in
                    
                    controller.getSelectedImagesWithCompletion({ (images) -> Void in
                        self.featuredImage = images[0]
                        self.backgroundImageView.image = self.featuredImage
                        self.backgroundColorView.alpha = 0.8
                        
                    })
            }))
            
            
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
        }

    }
    
    func presentCamera() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func shakeTextField() {
        
        newInterestTitleTextField.animation = "shake"
        newInterestTitleTextField.curve = "spring"
        newInterestTitleTextField.duration = 1.0
        newInterestTitleTextField.animate()
        
    }
    
    func shakePhotoButton() {
        
        selectFeaturedImageButton.animation = "shake"
        selectFeaturedImageButton.curve = "spring"
        selectFeaturedImageButton.duration = 1.0
        selectFeaturedImageButton.animate()
        
    }
    
    @IBAction func hideKeyboard() {
        
        if newInterestDescriptionTextView.isFirstResponder() {
            
            newInterestDescriptionTextView.resignFirstResponder()
        
        } else if newInterestTitleTextField.isFirstResponder() {
            
            newInterestTitleTextField.resignFirstResponder()
        }
    }
}


//MARK: - UItextFieldDelegate
extension NewInterestViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if newInterestDescriptionTextView.text == "Describe your new interest..." && !textField.text!.isEmpty {
            newInterestDescriptionTextView.becomeFirstResponder()
            
        } else if (newInterestTitleTextField.text?.isEmpty != nil) {
            
            shakeTextField()
        } else {
            textField.resignFirstResponder()
            
        }
        
        return true
    }
    
}


extension NewInterestViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        textView.text = ""
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        if textView.text.isEmpty {
            
            textView.text = "Describe your new interest..."
        }
        
        return true
    }
    
}

extension NewInterestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        self.backgroundImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        featuredImage = self.backgroundImageView.image
        self.backgroundColorView.alpha = 0.8
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}


















