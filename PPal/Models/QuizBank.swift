//
//  QuizBank.swift
//  PPal
//
//  Created by rclui on 11/10/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//
import Foundation

/*extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}*/

/**
 An encapsulating class that will hold the following:
 - Quiz history
 - Custom quiz questions (version 3)
 */
class QuizBank {
    
    /**
     The static variable to hold a copy of QuizBank, so that it is accessible
     from anywhere in the code
     */
    static var shared = QuizBank()
    
    // An array to store quizHistory
    var quizHistory: [Quiz]
    
    
    /// An array to hold the custom questions for the quiz, to be implemented
    /// in version 3
    private var customQuestions: [Question]
    
    private init() {
        quizHistory = [Quiz]()
        customQuestions = [Question]()
    }
    
    /**
     Adds a custom question into the quiz bank.
     - parameter question: A valid Question object.
     - returns: true or false
     - True if the Question was successfully added.
     - False if the Question was not added.  This is due to the Question being invalid.
     */
    func addCustom(question: Question) -> Bool {
        if !question.valid {
            return false
        }
        else { // Valid question, time to add.
            customQuestions.append(question)
            return true
        }
    }
    
    /**
     Removes the custom question into the quiz bank.
     - parameter question: A Question object, obtained from the getQuestions() method.
     - returns: true or false
     - True if the Question was successfully removed.
     - False if the Question was not removed.  This is due to the Question not being on
     the list.
     */
    func delCustom(question: Question) -> Bool {
        // Check to see if this question is on the list.
        if !customQuestions.contains(question) {
            return false
        }
        
        return true
    }
    
    /**
     Generates a quiz with 10 questions.
     - returns: A Quiz object with 10 questions.
     */
    func generateQuestions() -> Quiz {
        var randomNum = 0
        var randomNum1 = 0
        var flag = true
        var flag1 = true
        let quizToReturn = Quiz()
        let sizeOfPeopleBank = PeopleBank.shared.getPeople().count
        let sizeOfLabelBank = PeopleBank.shared.getLabels().count
        let listOfPeople = PeopleBank.shared.getPeople()
        let listOfLabels = PeopleBank.shared.getLabels()
        
        var randomizedQuestionsArray = [Question]()
        var previousChoiceIndices = [Int]()
        // var randomizeChoiceIndex = 0
        
        var tempQuestion = Question()
        var tempChoice = Choice()
        
        // PeopleBank.shared.getPeople()[].getInfo().lastName
        for index in 0...sizeOfPeopleBank-1
        {
            var tempListOfPeople = listOfPeople
            var choiceIndex: [Int] = [0, 1, 2, 3]
            
            tempQuestion = Question()
            
            // choice 1
            tempChoice = Choice()
            
            tempQuestion.image = tempListOfPeople[index].getInfo().pathToPhoto // stored but can be chosen not to be shown for this question
            tempQuestion.text = "Who is this person?"
            
            tempChoice.pathToPhoto = "\(tempListOfPeople[index].getInfo().pathToPhoto)"
            tempChoice.person = tempListOfPeople[index] // .person is optional. What im getting from you here Ryan is that you only want to associate the person with the choices that are the names of the person and not when choices are addresses?
            tempChoice.text = "\(tempListOfPeople[index].getName().firstName) " + "\(tempListOfPeople[index].getName().lastName)"
            tempListOfPeople.remove(at: index)
            // ummm so the tempChoice.valid checks the whether photostring and text are empty. What im getting from you Ryan is that you would still want these fields to not be null but just choose to display one of the two depending on the context of the question? Not sure how i would use this when i already set the fields. Or is it purely for testing purposes?
            randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))// returns an index in the range of 0 - 3. Purpose is to randomize the position of the correct answer
            previousChoiceIndices.append(randomNum) // append the choice positions so when randomly generating positions for other choices there will be no collision
            
            _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum]) // assuming result unused warning is due to the returned boolean for you to use in testing?
            _ = tempQuestion.set(correctAnswerIndex: choiceIndex[randomNum]) // set the correct index right away
            choiceIndex.remove(at: randomNum)
            // choice 2
            tempChoice = Choice()
            
            randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count))) // randomly selecting a person from the listofpeople and get that person's info to set the appropriate fields below
            
            tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
            tempChoice.person = tempListOfPeople[randomNum]
            tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
            tempListOfPeople.remove(at: randomNum)
            
            randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count))) // randomize the choice positions
            
            _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
            choiceIndex.remove(at: randomNum)
            
            // choice 3
            tempChoice = Choice()
            
            randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count)))
            
            
            tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
            tempChoice.person = tempListOfPeople[randomNum]
            tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
            tempListOfPeople.remove(at: randomNum)
            randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
            
            previousChoiceIndices.append(randomNum)
            _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
            choiceIndex.remove(at: randomNum)
            
            // choice 4
            tempChoice = Choice()
            
            randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count)))
            
            tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
            tempChoice.person = tempListOfPeople[randomNum]
            tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
            // tempListOfPeople.remove(at: randomNum)
            
            _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[0])
            
            randomizedQuestionsArray.append(tempQuestion)
            // remember to set the correct index for the correct answer
            
            // quizToReturn.questions[index] = arc4random_uniform(UInt32(sizeOfPeopleBank))
            
        }
        
        
        if(listOfLabels.count > 1)
        {
            for index in 0...sizeOfLabelBank-1
            {
                if(listOfLabels[index].getPeople().count > 2){
                    var tempListOfLabels = listOfLabels
                    //var tempListOfLabel = listOfLabels[index]
                    var tempListOfPeople = listOfLabels[index].getPeople()
                    var choiceIndex: [Int] = [0, 1, 2, 3]
                    
                    tempQuestion = Question()
                    
                    tempChoice = Choice()
                    
                    //no label photo to display for this version yet
                    tempQuestion.text = "If there are three people with a common label: Who does not belong to the label \(tempListOfLabels[index].getName())"
                    //choice 1
                    
                    
                    randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count))) //get random label and then access the info of three people for the three false choices
                    tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
                    tempChoice.person = tempListOfPeople[randomNum]
                    tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
                    tempListOfPeople.remove(at: randomNum)
                    
                    randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
                    _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
                    choiceIndex.remove(at: randomNum)
                    
                    //choice 2
                    
                    tempChoice = Choice()
                    
                    randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count))) //get random label and then access the info of three people for the three false choices
                    tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
                    tempChoice.person = tempListOfPeople[randomNum]
                    tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
                    tempListOfPeople.remove(at: randomNum)
                    
                    randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
                    _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
                    choiceIndex.remove(at: randomNum)
                    
                    //choice 3
                    tempChoice = Choice()
                    
                    randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count))) //get random label and then access the info of three people for the three false choices
                    tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
                    tempChoice.person = tempListOfPeople[randomNum]
                    tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
                    tempListOfPeople.remove(at: randomNum)
                    
                    randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
                    _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
                    choiceIndex.remove(at: randomNum)
                    
                    //choice 4 correct choice
                    tempListOfLabels.remove(at: index)
                    tempChoice = Choice()
                    flag = true
                    flag1 = true
                    
                    while(!tempListOfLabels.isEmpty && flag)
                    {
                        randomNum = Int(arc4random_uniform(UInt32(tempListOfLabels.count)))
                        var tempListOfPeople = tempListOfLabels[randomNum].getPeople()
                        while(!tempListOfPeople.isEmpty && flag1)
                        {
                            
                            if(listOfLabels[index].getPeople().contains(tempListOfPeople[0]))
                            {
                                tempListOfPeople.remove(at: 0)
                            }
                            else
                            {
                                tempChoice.pathToPhoto = tempListOfLabels[randomNum].getPeople()[0].getInfo().pathToPhoto
                                tempChoice.person = tempListOfLabels[randomNum].getPeople()[0]
                                tempChoice.text = "\(tempListOfLabels[randomNum].getPeople()[0].getName().firstName) " + "\(tempListOfLabels[randomNum].getPeople()[0].getName().lastName)"
                                _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[0])
                                _ = tempQuestion.set(correctAnswerIndex: choiceIndex[0])
                                randomizedQuestionsArray.append(tempQuestion)
                                
                                flag = false
                                flag1 = false
                                
                            }
                        }
                        
                        tempListOfLabels.remove(at: randomNum)
                    }
                    
                    
                    
                }
                
                
            }
        }
        
        
        for _ in 0...9 { // randomizing the resulting question array to be returned as a quiz
            
            randomNum = Int(arc4random_uniform(UInt32(randomizedQuestionsArray.count)))
            quizToReturn.questions.append(randomizedQuestionsArray[randomNum])
        }
        
        return quizToReturn
    }

    
}
