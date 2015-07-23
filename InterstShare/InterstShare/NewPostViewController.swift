//
//  NewPostViewController.swift
//  InterstShare
//
//  Created by Ryosuke Fukuda on 7/20/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Photos

class NewPostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var currentUserProfileImageView: UIImageView!
    @IBOutlet weak var currentUserFullName: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postContentTextView: UITextView!

    private var postImage: UIImage! //use this one to store post image - send it to Parse
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postContentTextView.becomeFirstResponder()
        postContentTextView.text = ""
        
        currentUserProfileImageView.layer.cornerRadius = currentUserProfileImageView.layer.bounds.width/2
        currentUserProfileImageView.layer.masksToBounds = true
        
        //Notification Center - keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    //MARK: - Text View Handler
    //it will remove all the obsserver when I close it
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
        
        self.postContentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.postContentTextView.scrollIndicatorInsets = self.postContentTextView.contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.postContentTextView.contentInset = UIEdgeInsetsZero
        self.postContentTextView.scrollIndicatorInsets = UIEdgeInsetsZero
        
    }
    
    //MARK: - Pick Featured Image

    @IBAction func PicFeaturedImage(sender: AnyObject) {
        
        let authrization = PHPhotoLibrary.authorizationStatus()
        
        if authrization == .NotDetermined {
            
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.PicFeaturedImage(sender)
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
                    self.postImage = images[0]
                    self.postImageView.image = self.postImage
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.postImageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func dismiss() {
        
        postContentTextView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func post() {
        
        postContentTextView.resignFirstResponder()
        
        //TODO: - create a new post
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
}
