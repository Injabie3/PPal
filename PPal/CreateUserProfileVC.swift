//
//  CreateUserProfileVC.swift
//  PPal
//
//  Created by Maple Tan on 2017-11-02.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class CreateUserProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CNContactPickerDelegate {
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    var contact: CNContact = CNContact()
    var isImported = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doneBarButton?.isEnabled = false
        firstNameTextField?.delegate = self
        lastNameTextField?.delegate = self
        phoneField?.delegate = self
        emailField?.delegate = self
        addressField?.delegate = self
        
        if isImported {
            isImported = false
            self.firstNameTextField.text = contact.givenName
            self.lastNameTextField.text = contact.familyName
            self.phoneField.text = (contact.phoneNumbers.first?.value as! CNPhoneNumber).value(forKey: "digits") as? String
            self.emailField.text = contact.emailAddresses.first?.value as String?
            self.addressField.text = CNPostalAddressFormatter().string(from: (contact.postalAddresses.first?.value)!)
            if contact.imageData != nil {
                self.photoImageView.image = UIImage(data: contact.imageData!)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Checks if the fields are full, greys out the Done button if not
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (firstNameTextField?.text?.isEmpty)! || (lastNameTextField?.text?.isEmpty)! || (phoneField?.text?.isEmpty)! || (emailField?.text?.isEmpty)! || (addressField?.text?.isEmpty)! {
        } else {
            setHiddenImage()
        }
    }
    
    func setHiddenImage() {
        
        self.doneBarButton.isEnabled = false
        if (photoImageView.image != nil) {
            self.doneBarButton.isEnabled = true
        }
    }
}
