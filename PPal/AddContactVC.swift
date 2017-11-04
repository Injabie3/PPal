//
//  AddContactVC.swift
//  PPal
//
//  Created by rmakkar on 10/31/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class AddContactVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CNContactPickerDelegate {

    var contact1: CNContact = CNContact()
    var isImported = Bool()
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var labelField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.doneBarButton?.isEnabled = false
        firstNameField?.delegate = self
        lastNameField?.delegate = self
        phoneNumberField?.delegate = self
        emailField?.delegate = self
        labelField?.delegate = self
        addressField?.delegate = self
        
        if isImported {
            isImported = false
            self.firstNameField.text = contact1.givenName
            self.lastNameField.text = contact1.familyName
            self.phoneNumberField.text = (contact1.phoneNumbers.first?.value as! CNPhoneNumber).value(forKey: "digits") as? String
            self.emailField.text = contact1.emailAddresses.first?.value as String?
            self.addressField.text = CNPostalAddressFormatter().string(from: (contact1.postalAddresses.first?.value)!)
            if contact1.imageData != nil {
                self.contactPhoto.image = UIImage(data: contact1.imageData!)
            }
        }
    }

    // MARK: UIImagePickerControllerDelegate
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard
        firstNameField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Make sure AddContactVC is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was providied the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        contactPhoto.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Grey out Done button if the fields are not all filled
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (firstNameField?.text?.isEmpty)! || (lastNameField?.text?.isEmpty)! || (phoneNumberField?.text?.isEmpty)! || (emailField?.text?.isEmpty)! || (addressField?.text?.isEmpty)! {
        } else {
            setHiddenImage()
        }
    }
    
    func setHiddenImage() {

        self.doneBarButton.isEnabled = false
        if (contactPhoto.image != nil) {
            self.doneBarButton.isEnabled = true
        }
    }
}
