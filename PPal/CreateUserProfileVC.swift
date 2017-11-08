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
    
    var isPhotoSelected = Bool()
    var isTextFieldsFilled = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        self.doneBarButton?.isEnabled = false
        firstNameTextField?.delegate = self
        lastNameTextField?.delegate = self
        phoneField?.delegate = self
        emailField?.delegate = self
        addressField?.delegate = self
        
        isPhotoSelected = false
        isTextFieldsFilled = false
        
        firstNameTextField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        lastNameTextField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        phoneField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        emailField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        addressField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        if isImported {
            isImported = false
            if contact.givenName != "" {
                self.firstNameTextField.text = contact.givenName
            }
            if contact.familyName != "" {
                self.lastNameTextField.text = contact.familyName
            }
            
            if contact.phoneNumbers.count > 0 {
                print("there is a number here")
                self.phoneField.text = ((contact.phoneNumbers.first?.value)! as CNPhoneNumber).stringValue
            }
            
            if contact.postalAddresses.count > 0 {
                print("there is an address here")
                self.addressField.text = CNPostalAddressFormatter().string(from: (contact.postalAddresses.first?.value)!)
            }
            
            if contact.emailAddresses.first?.value as String? != "" {
                self.emailField.text = contact.emailAddresses.first?.value as String?
            }
            if contact.imageData != nil {
                self.photoImageView.image = UIImage(data: contact.imageData!)
            }
        }
        
        textFieldDidChange(firstNameTextField)
        // setHiddenImage()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
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
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if (firstNameTextField?.text?.isEmpty)! || (lastNameTextField?.text?.isEmpty)! || (phoneField?.text?.isEmpty)! || (emailField?.text?.isEmpty)! || (addressField?.text?.isEmpty)! {
            isTextFieldsFilled = false
        } else {
            isTextFieldsFilled = true
        }
        fieldsAllFilled()
    }
    
    func setHiddenImage() {
        
        isPhotoSelected = false
        // let img = UIImage(named: "default-user.png")
        
        if photoImageView.image != nil {
            isPhotoSelected = true
            print("there is an image here")
        }
        fieldsAllFilled()
    }
    
    func fieldsAllFilled() {
        print("check if all fields are filled")
        doneBarButton.isEnabled = false
        // if isTextFieldsFilled && isPhotoSelected {
        if isTextFieldsFilled {
            doneBarButton.isEnabled = true
        }
    }
    
    // hides keyboard when the view sees a touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
