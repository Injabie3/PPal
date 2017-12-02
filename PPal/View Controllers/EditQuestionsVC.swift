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
    
    
    
    var choiceIndex = [0,1,2,3]
    var randomNum: Int = 0
    var customQuestion = Question()
    
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
    
    // Moves the view up by 200 when the user starts editing any text fields
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -200, up: true)
    }
    
    // Moves the view back down by 200 when the user finishes editing any text fields
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -200, up: false)
    }
    
    // When the next button is pressed on the keyboard, it should go to the next text field. The last text field will have a done button which will dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == questionTextField {
            textField.resignFirstResponder()
            correctAnswerText.becomeFirstResponder()
        }
        else if textField == correctAnswerText {
            textField.resignFirstResponder()
            answerTwoField.becomeFirstResponder()
        }
        else if textField == answerTwoField {
            textField.resignFirstResponder()
            answerThreeField.becomeFirstResponder()
        }
        else if textField == answerThreeField {
            textField.resignFirstResponder()
            answerFourField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }

        return true
    }
    
    // Animates the movement of the text fields
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
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
        
        customQuestion.image = (quizPhoto.image?.resizeImageWith(newSize: CGSize(width: 50, height: 50)).toBase64)!

        //customQuestion.image = selectedImage

        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        var customChoice = Choice()
        customQuestion.text = questionTextField.text!
        randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
        
        
        customChoice.pathToPhoto = #imageLiteral(resourceName: "default-user").resizeImageWith(newSize: CGSize(width: 50, height: 50)).toBase64
        customChoice.person = nil
        customChoice.text = correctAnswerText.text!
        _ = customQuestion.set(choice: customChoice, atIndex: choiceIndex[randomNum])
        _ = customQuestion.set(correctAnswerIndex: choiceIndex[randomNum])
        choiceIndex.remove(at: randomNum)
        
        
        customChoice = Choice()
        customChoice.pathToPhoto = #imageLiteral(resourceName: "default-user").toBase64
        customChoice.person = nil
        customChoice.text = answerTwoField.text!
        randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
        _ = customQuestion.set(choice: customChoice, atIndex: choiceIndex[randomNum])
        choiceIndex.remove(at: randomNum)
        
        customChoice = Choice()
        customChoice.pathToPhoto = #imageLiteral(resourceName: "default-user").resizeImageWith(newSize: CGSize(width: 50, height: 50)).toBase64
        customChoice.person = nil
        customChoice.text = answerThreeField.text!
        randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
        _ = customQuestion.set(choice: customChoice, atIndex: choiceIndex[randomNum])
        choiceIndex.remove(at: randomNum)
        
        customChoice = Choice()
        customChoice.pathToPhoto = #imageLiteral(resourceName: "default-user").resizeImageWith(newSize: CGSize(width: 50, height: 50)).toBase64
        customChoice.person = nil
        customChoice.text = answerFourField.text!
        randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
        _ = customQuestion.set(choice: customChoice, atIndex: choiceIndex[randomNum])
        choiceIndex.remove(at: randomNum)
        

        let result = QuizBank.shared.addCustom(question: customQuestion)
        
        for choice in customQuestion.getChoices() {
            _ = Database.shared.saveCustomizedChoiceToDatabase(choice: choice)
        }
     
        _ = Database.shared.saveCustomizedQuestionToDatabase(question: customQuestion)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // Hides keyboard when the view sees a touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
