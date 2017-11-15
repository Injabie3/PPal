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
    var rightAnswerPlacement:UInt32 = 0
    var points = 0
    
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var quizPhoto: UIImageView!
    @IBOutlet weak var answerButton: UIButton!
    
    @IBAction func buttonAction(_ sender: AnyObject) {
        if sender.tag == Int(rightAnswerPlacement) {
            print("right answer")
            points += 1
        }
        else {
            print("wrong answer")
        }
        
        if(currentQuestion != questions.count) {
            newQuestion()
        }
        else {
            performSegue(withIdentifier: "segueToEndQuiz", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newQuestion()
    }
    
    func newQuestion() {
        questionText.text = questions[currentQuestion]
        quizPhoto.image = UIImage(named: photos[currentQuestion])
        rightAnswerPlacement = arc4random_uniform(4) + 1
        
        var button:UIButton = UIButton()
        var questionNumber = 1
        
        for i in 1...4 {
            button = view.viewWithTag(i) as! UIButton
            
            if i == Int(rightAnswerPlacement) {
                button.setTitle(answers[currentQuestion][0], for: .normal)
            }
            else {
                button.setTitle(answers[currentQuestion][questionNumber], for: .normal)
                questionNumber += 1
            }
        }
        currentQuestion += 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToEndQuiz" {
            let viewVC = segue.destination as! EndQuizVC
            viewVC.endPoints = points
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
