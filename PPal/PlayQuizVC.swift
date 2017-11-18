//
//  PlayQuizVC.swift
//  PPal
//
//  Created by Matthew Thomas on 11/14/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class PlayQuizVC: UIViewController {

    // An aray of questions, replace with strings of questions, separated with commas
    let questions = ["Who is this person?", "What month is it?", "What is your phone number?"]
    
    // An array of answers, with the right answer as the first index
    let answers = [["Ryan", "Mirac", "Ranbir", "Harry"], ["November", "October", "December", "January"], ["604-604-6044", "604-123-4567", "778-456-7890", "778-123-4567"]]
    
    // An array of photos, replace with others
    let photos = ["test1.jpg", "test2.jpg", "test3.jpeg", "test4.jpg"]
    
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
        newQuestion()
    }
    
    // When currentQuestion != question.count, create a new question
    func newQuestion() {
        questionText.text = questions[currentQuestion]
        quizPhoto.image = UIImage(named: photos[currentQuestion])
        
        // Randomizes the placement of the correct answer
        rightAnswerPlacement = arc4random_uniform(4) + 1
        
        var button: UIButton = UIButton()
        var questionNumber = 1
        
        for i in 1...4 {
            button = view.viewWithTag(i) as! UIButton
            
            // If i equals the randomly generated number from arc4random, then set the button with tag i as the correct answer
            if i == Int(rightAnswerPlacement) {
                button.setTitle(answers[currentQuestion][0], for: .normal)
            }
            else {
                button.setTitle(answers[currentQuestion][questionNumber], for: .normal)
                questionNumber += 1
            }
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
