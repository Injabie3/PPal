//
//  EditQuestionsVC.swift
//  PPal
//
//  Created by Maple Tan on 2017-11-30.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class EditQuestionsVC: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var correctAnswerText: UITextField!
    @IBOutlet weak var answerTwoField: UITextField!
    @IBOutlet weak var answerThreeField: UITextField!
    @IBOutlet weak var answerFourField: UITextField!
    @IBOutlet weak var quizPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.saveButton.isEnabled = false
        
        questionTextField.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        correctAnswerText.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerTwoField.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerThreeField.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerFourField.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        correctAnswerText.backgroundColor = UIColor(red: 0.06, green: 0.74, blue: 0.46, alpha: 1.0)
        answerTwoField.backgroundColor = UIColor.red
        answerThreeField.backgroundColor = UIColor.red
        answerFourField.backgroundColor = UIColor.red
        
        correctAnswerText.borderStyle = .roundedRect
        answerTwoField.borderStyle = .roundedRect
        answerThreeField.borderStyle = .roundedRect
        answerFourField.borderStyle = .roundedRect
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(questionTextField?.text?.isEmpty)! || (correctAnswerText?.text?.isEmpty)! || (answerTwoField?.text?.isEmpty)! || (answerThreeField?.text?.isEmpty)! || (answerFourField?.text?.isEmpty)! {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func selectImageFromLibrary(_ sender: Any) {
        
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
        quizPhoto.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}
