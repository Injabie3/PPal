//
//  PlayQuizVC.swift
//  PPal
//
//  Created by Matthew Thomas on 11/14/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class PlayQuizVC: UIViewController {

    let quiz = QuizBank.shared.generateQuestions()
    
    // An aray of questions, replace with strings of questions, separated with commas
    var questions = [Question]()
    
    var currentQuestion = 0
    var rightAnswerPlacement: UInt32 = 0
    var points = 0
    
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var quizPhoto: UIImageView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var nextQuestionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reviewButton.isHidden = true
        self.nextQuestionButton.isHidden = true
        self.resultText.isHidden = true
 
        for i in 1...4 {
            let button = view.viewWithTag(i) as! UIButton
            button.isEnabled = true
        }
    }
    
    // If any answer is chosen, check if the answer is right
    @IBAction func buttonAction(_ sender: AnyObject) {
        
        // If the button we pressed is the correct one, then make it green, disable the choice buttons,
        // and show the review and next question/end quiz buttons.
        if sender.tag == Int(rightAnswerPlacement) {
            print("right answer")
            resultText.text = "Correct"
            resultText.textColor = UIColor(red: 0.06, green: 0.74, blue: 0.46, alpha: 1.0)
            self.resultText.isHidden = false
            self.self.view.viewWithTag(Int(rightAnswerPlacement))?.backgroundColor = UIColor(red: 0.06, green: 0.74, blue: 0.46, alpha: 1.0)
            
            // Uncomment if you want other answers to disappear
            for i in 1...4 {
                if (i != (Int(rightAnswerPlacement))) {
                    print(i)
                    self.self.view.viewWithTag(i)?.isHidden = true
                }
            }
            points += 1
        }
        // Else the choice was incorrect, and we put the incorrect answer in red, and show the correct answer in
        // green.  Also show the review and next question/end quiz buttons.
        else {
            print("wrong answer")
            resultText.text = "Incorrect"
            resultText.textColor = UIColor.red
            self.resultText.isHidden = false
            self.self.view.viewWithTag(Int(rightAnswerPlacement))?.backgroundColor = UIColor(red: 0.06, green: 0.74, blue: 0.46, alpha: 1.0)
            self.self.view.viewWithTag(sender.tag)?.backgroundColor = UIColor.red

            // Uncomment if you want other answers to disappear
            for i in 1...4 {
                if (i != sender.tag) && (i != (Int(rightAnswerPlacement))) {
                    print(i)
                    self.self.view.viewWithTag(i)?.isHidden = true
                }
            }
        }
        
        hiddenButtons()
    }
    
    // Pressing the next question button will
    @IBAction func nextQuestion(_ sender: AnyObject) {
        self.resultText.isHidden = true
        hiddenButtons()
        if currentQuestion != questions.count {
            for i in 1...4 {
                // Uncomment if you want other answers to disappear
                if (self.self.view.viewWithTag(i)?.isHidden)! {
                    self.self.view.viewWithTag(i)?.isHidden = !((self.self.view.viewWithTag(i)?.isHidden)!)
                }
                
                self.self.view.viewWithTag(i)?.backgroundColor = UIColor(red: 0.50, green: 0.52, blue: 1.00, alpha: 1.0)
            }
            newQuestion()
        }
        else {
            performSegue(withIdentifier: "segueToEndQuiz", sender: self)
        }
    }
    
    func hiddenButtons() {
        self.reviewButton.isHidden = !self.reviewButton.isHidden
        self.nextQuestionButton.isHidden = !self.nextQuestionButton.isHidden
        
        for i in 1...4 {
            let button = view.viewWithTag(i) as! UIButton
            button.isEnabled = !(button.isEnabled)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        questions = quiz.questions
        newQuestion()
    }
    
    // When currentQuestion != question.count, create a new question
    func newQuestion() {
        // questionText.text = questions[currentQuestion]
        // quizPhoto.image = UIImage(named: photos[currentQuestion])
        questionText.text = questions[currentQuestion].text
        quizPhoto.image = questions[currentQuestion].image.toImage
        
        var button: UIButton = UIButton()
        
        // Get the choices from the question.
        let choices = questions[currentQuestion].getChoices()
        
        // Set the correct answer. We need to add one because the tags go from 1 to 4.
        rightAnswerPlacement = UInt32(questions[currentQuestion].getCorrectAnswer() + 1)
        
        // Set the choice text on the buttons.
        for i in 1...4 {
            button = view.viewWithTag(i) as! UIButton
            button.setTitle(choices[i-1].text, for: .normal)

        }
        
        currentQuestion += 1
        
        if currentQuestion == questions.count {
            nextQuestionButton.setTitle("End Quiz", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToEndQuiz" {
            let viewVC = segue.destination as! EndQuizVC
            viewVC.endPoints = points
        }
    }
    
}
