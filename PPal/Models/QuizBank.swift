//
//  QuizBank.swift
//  PPal
//
//  Created by rclui on 11/10/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//
import Foundation


/**
 An encapsulating class that will hold the following:
 - Quiz history
 - Custom quiz questions (version 3)
 */

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
        /// Stub function, to be implemented in version 3.
        return true
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
        /// Stub function, to be implemented in version 3.
        return true
    }
    
    /**
     Generates a quiz with 10 questions.
     - returns: A Quiz object with 10 questions.
     */
    func generateQuestions() -> Quiz {
        var randomNum = 0
        let quizToReturn = Quiz()
        let sizeOfPeopleBank = PeopleBank.shared.getPeople().count
        var listOfPeople = PeopleBank.shared.getPeople()
    
        //var storePeople = [Person]()
        
        
        var idForChoices = 0
        var idForQuestions = 0
        
        var randomizedQuestionsArray = [Question]()
        var previousChoiceIndices = [Int]()
        //var randomizeChoiceIndex = 0
        
        var tempQuestion = Question()
        var tempChoice = Choice()

        // var hashTable_Choices = [Choice]()
        // var hashTable_People = [Person]()
        
        
        //PeopleBank.shared.getPeople()[].getInfo().lastName
        for index in 0...sizeOfPeopleBank-1
        {
            var tempListOfPeople = listOfPeople
            var choiceIndex : [Int] = [0,1,2,3]
//choice 1
            tempQuestion = Question()
            tempChoice = Choice()
            
            tempQuestion.image = tempListOfPeople[index].getInfo().pathToPhoto //stored but can be chosen not to be shown for this question
            tempQuestion.text = "Who is this person?"
            
            //storePeople.append(listOfPeople[index]) //adds a person into the array. Later used to check if a person is already in the array when randomly selecting the other 3 false choices from listOfPeople
            
            tempChoice.pathToPhoto = "\(tempListOfPeople[index].getInfo().pathToPhoto)"
            tempChoice.person = tempListOfPeople[index] //.person is optional. What im getting from you here Ryan is that you only want to associate the person with the choices that are the names of the person and not when choices are addresses?
            tempChoice.text = "\(tempListOfPeople[index].getName().firstName) " + "\(tempListOfPeople[index].getName().lastName)"
            //ummm so the tempChoice.valid checks the whether photostring and text are empty. What im getting from you Ryan is that you would still want these fields to not be null but just choose to display one of the two depending on the context of the question? Not sure how i would use this when i already set the fields. Or is it purely for testing purposes?
            randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))// returns an index in the range of 0 - 3. Purpose is to randomize the position of the correct answer
            previousChoiceIndices.append(randomNum) //append the choice positions so when randomly generating positions for other choices there will be no collision
            
            _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum]) //assuming result unused warning is due to the returned boolean for you to use in testing?
            _ = tempQuestion.set(correctAnswerIndex: choiceIndex[randomNum]) //set the correct index right away
            choiceIndex.remove(at: randomNum)
//choice 2
            tempChoice = Choice()
            
            randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count))) //randomly selecting a person from the listofpeople and get that person's info to set the appropriate fields below
            
            tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
            tempChoice.person = tempListOfPeople[randomNum]
            tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
            tempListOfPeople.remove(at: randomNum)
            
            randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count))) //randomize the choice positions
           
            _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
            
//choice 3
            tempChoice = Choice()
            
            randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count)))
      
            
            tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
            tempChoice.person = tempListOfPeople[randomNum]
            tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
            tempListOfPeople.remove(at: randomNum)
            randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
            
            previousChoiceIndices.append(randomNum)
            _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
         
            
//choice 4
            tempChoice = Choice()

            randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count)))
                
            tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
            tempChoice.person = tempListOfPeople[randomNum]
            tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
            //tempListOfPeople.remove(at: randomNum)

            _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[0])

            randomizedQuestionsArray.append(tempQuestion)
             //remember to set the correct index for the correct answer

            
            
          //quizToReturn.questions[index] = arc4random_uniform(UInt32(sizeOfPeopleBank))
            
        }
        
        for _ in 0...9 //randomizing the resulting question array to be returned as a quiz
        {
            
            randomNum = Int(arc4random_uniform(UInt32(randomizedQuestionsArray.count)))
            quizToReturn.questions.append(randomizedQuestionsArray[randomNum])
        }
        
        
        
        return quizToReturn
    }

    
}