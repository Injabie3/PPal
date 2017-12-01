//
//  EditQuestionsVC.swift
//  PPal
//
//  Created by Maple Tan on 2017-11-30.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class EditQuestionsVC: UIViewController {

    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var correctAnswerText: UITextField!
    @IBOutlet weak var answerTwoField: UITextField!
    @IBOutlet weak var answerThreeField: UITextField!
    @IBOutlet weak var answerFourField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.saveButton.isEnabled = false
        
        questionTextField.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        correctAnswerText.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerTwoField.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerThreeField.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerFourField.addTarget(self, action: #selector(EditQuestionsVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(questionTextField?.text?.isEmpty)! || (correctAnswerText?.text?.isEmpty)! || (answerTwoField?.text?.isEmpty)! || (answerThreeField?.text?.isEmpty)! || (answerFourField?.text?.isEmpty)! {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}
