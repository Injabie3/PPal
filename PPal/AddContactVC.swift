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
var selectedLabels = [Label]()

class AddContactVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CNContactPickerDelegate {

    var contact1: CNContact = CNContact()
    var isImported = Bool()
    
    var isPhotoSelected = Bool()
    var isTextFieldsFilled = Bool()
    
    var person: Person? // A person object that we will pass on a segue.
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var displayLabels: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.doneBarButton?.isEnabled = false
        firstNameField?.delegate = self
        lastNameField?.delegate = self
        phoneNumberField?.delegate = self
        emailField?.delegate = self
        addressField?.delegate = self
        
        isPhotoSelected = false
        isTextFieldsFilled = false
        
        firstNameField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        lastNameField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        phoneNumberField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        emailField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        addressField.addTarget(self, action: #selector(CreateUserProfileVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        if isImported {
            isImported = false
            if contact1.givenName != "" {
                self.firstNameField.text = contact1.givenName
            }
            if contact1.familyName != "" {
                self.lastNameField.text = contact1.familyName
            }
            
            if contact1.phoneNumbers.count > 0 {
                print("there is a number here")
                self.phoneNumberField.text = ((contact1.phoneNumbers.first?.value)! as CNPhoneNumber).stringValue
            }
            
            if contact1.postalAddresses.count > 0 {
                print("there is an address here")
                self.addressField.text = CNPostalAddressFormatter().string(from: (contact1.postalAddresses.first?.value)!)
            }
            
            if contact1.emailAddresses.first?.value as String? != "" {
                self.emailField.text = contact1.emailAddresses.first?.value as String?
            }
            if contact1.imageData != nil {
                self.contactPhoto.image = UIImage(data: contact1.imageData!)
            }
        }
        
        textFieldDidChange(firstNameField)
        // setHiddenImage()
        
        // Set the fields if we're passing in a person.
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
            // labelField.text = labelTextArray.joined(separator: ",")
        }
        updateDisplayLabelsTextbox()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDisplayLabelsTextbox()
    }
    
    // update label text field
    func updateDisplayLabelsTextbox() {
        var labelArray = [String]()
        for label in selectedLabels {
            labelArray.append(label.getName())
        }
        
        let labelString = labelArray.joined(separator: ",")
        
        self.displayLabels.text = (labelString)
        print (labelString)
        print(labelArray)
    }
    

    // Done pressed, save data.
    @IBAction func donePressed() {
        // 1. Validate data.
        
        // 2. Create person class object
        
        
        if person == nil {
            let profile = Person()

            for label in selectedLabels {
                // _ = PeopleBank.shared.add(label: label)
                // _ = Database.shared.saveLabelToDatabase(label: label)
                profile.add(label: label)
            }
            _ = profile.set(firstName: self.firstNameField.text!, lastName: self.lastNameField.text!)
            _ = profile.set(phoneNumber: phoneNumberField.text!)
            _ = profile.set(email: emailField.text!)
            // profile.add(label: label01)
            // Setting the photo to this for now.
            _ = profile.setInfo(pathToPhoto: firstNameField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, phoneNumber: phoneNumberField.text!, email: emailField.text!, address: addressField.text!, hasHouseKeys: false)
            // 3. Save to PeopleBank object.
            _ = PeopleBank.shared.add(person: profile)
            
            // 4. Add to database.
            if profile.valid {
                _ = Database.shared.saveProfileToDatabase(profile: profile)
            }
            
        } else {
            // label01.editLabel(name: "Cool People")
            
            for label in selectedLabels {
                // _ = PeopleBank.shared.add(label: label)
                // _ = Database.shared.saveLabelToDatabase(label: label)
                _ = person!.add(label: label)
            }
            // _ = PeopleBank.shared.add(label: label01)
            // _ = Database.shared.saveLabelToDatabase(label: label01)
            _ = person!.set(firstName: self.firstNameField.text!, lastName: self.lastNameField.text!)
            _ = person!.set(phoneNumber: phoneNumberField.text!)
            _ = person!.set(email: emailField.text!)
            // _ = person!.add(label: label01)
            _ = person!.setInfo(pathToPhoto: "test12234", firstName: firstNameField.text!, lastName: lastNameField.text!, phoneNumber: phoneNumberField.text!, email: emailField.text!, address: addressField.text!, hasHouseKeys: false)
            
            
            // 4. Update database.
            if person!.valid {
                _ = Database.shared.updateProfile(profile: person!)
            }
            
            
            
        }
        
        // 5. Clear variables
        selectedLabels.removeAll()
        
        // 6. Go back to previous screen.
        // This did not work, but will remind us of the nice progress we made :)
        // performSegue(withIdentifier: "unwindFromCreateProfileVCWithUnwindSegue", sender: self)
        self.navigationController!.popViewController(animated: true)
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was providied the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        contactPhoto.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // Checks if the fields are full, greys out the Done button if not
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if (firstNameField?.text?.isEmpty)! || (lastNameField?.text?.isEmpty)! || (phoneNumberField?.text?.isEmpty)! || (emailField?.text?.isEmpty)! || (addressField?.text?.isEmpty)! {
            isTextFieldsFilled = false
        } else {
            isTextFieldsFilled = true
        }
        fieldsAllFilled()
    }
    
    func setHiddenImage() {
        
        isPhotoSelected = false
        // let img = UIImage(named: "default-user.png")
        
        if contactPhoto.image != nil {
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

    @IBAction func cancelPressed(_ sender: Any) {
        // Clear the variables and go back.
        selectedLabels.removeAll()
        self.navigationController!.popViewController(animated: true)
    }
    
}
