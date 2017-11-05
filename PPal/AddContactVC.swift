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
    
    var person: Person? // A person object that we will pass on a segue.
    
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
        
        // Set the fields if we're passing in a field.
        if let person = person {
            firstNameField.text = person.getName().firstName
            lastNameField.text = person.getName().lastName
            phoneNumberField.text = person.getInfo().phoneNumber
            emailField.text = person.getInfo().email
            addressField.text = person.getInfo().address
            
            // We don't have the selection implemented right now, so put it in a text field.
            var labelTextArray = [String]()
            for item in person.getInfo().labels {
                labelTextArray.append(item.getName())
            }
         
            labelField.text = labelTextArray.joined(separator: ",")
        }
    }

    // Done pressed, save data.
    override func viewWillDisappear(_ animated: Bool) {
        // 1. Validate data.
        
        // 2. Create person class object
        let label01 = Label()
        
        if person == nil {
            let profile = Person()
            let label01 = Label()
            label01.editLabel(name: "Cool People")
            _ = PeopleBank.shared.add(label: label01)
            _ = Database.shared.saveLabelToDatabase(label: label01)
            _ = profile.set(firstName: self.firstNameField.text!, lastName: self.lastNameField.text!)
            _ = profile.set(phoneNumber: phoneNumberField.text!)
            _ = profile.set(email: emailField.text!)
            profile.add(label: label01)
            // Setting the photo to this for now.
            _ = profile.setInfo(pathToPhoto: firstNameField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, phoneNumber: phoneNumberField.text!, email: emailField.text!, address: addressField.text!, hasHouseKeys: false)
            // 3. Save to PeopleBank object.
            _ = PeopleBank.shared.add(person: profile)
            
            // 4. Add to database.
            _ = Database.shared.saveProfileToDatabase(profile: profile)
            
        } else {
            label01.editLabel(name: "Cool People")
            _ = PeopleBank.shared.add(label: label01)
            _ = Database.shared.saveLabelToDatabase(label: label01)
            _ = person!.set(firstName: self.firstNameField.text!, lastName: self.lastNameField.text!)
            _ = person!.set(phoneNumber: phoneNumberField.text!)
            _ = person!.set(email: emailField.text!)
            _ = person!.add(label: label01)
            _ = person!.setInfo(pathToPhoto: "test12234", firstName: firstNameField.text!, lastName: lastNameField.text!, phoneNumber: phoneNumberField.text!, email: emailField.text!, address: addressField.text!, hasHouseKeys: false)
            
            
            // 4. Update database.
            _ = Database.shared.updateProfile(profile: person!)
        }
        
        
        // 5. Go back to previous screen.
        // This is handled by the unwind segue
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
