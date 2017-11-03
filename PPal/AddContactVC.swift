//
//  AddContactVC.swift
//  PPal
//
//  Created by rmakkar on 10/31/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class AddContactVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var labelField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var contactPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.doneBarButton?.isEnabled = false
        firstNameTextField?.delegate = self
        lastNameTextField?.delegate = self
        phoneField?.delegate = self
        emailField?.delegate = self
        labelField?.delegate = self
        addressField?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UIImagePickerControllerDelegate
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard
      // firstNameTextField.resignFirstResponder()
        
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
        if (firstNameTextField?.text?.isEmpty)! || (lastNameTextField?.text?.isEmpty)! || (phoneField?.text?.isEmpty)! || (emailField?.text?.isEmpty)! || (addressField?.text?.isEmpty)! {
            //self.doneBarButton.isEnabled = false
        } else {
            //self.doneBarButton.isEnabled = true
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
