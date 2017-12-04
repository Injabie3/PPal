//
//  QuizBank.swift
//  PPal
//
//  Created by rclui on 11/10/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//
import Foundation

/* extension MutableCollection where Index == Int {
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
 } */

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
    
    /// returns all custom questions
    func getCustomQuestions() -> [Question]
    {
        
        return customQuestions
    }
    
    // Exerpt taken from https://github.com/almata/Combinatorics in Combinatorics.swift
    // Maybe i should make this an extension instead?
    // This function works off of a template to take in various types. While the parameter elements will be of type [person] array and taking will be the size that we are choosing from the [Person] array (i.e [Harry, Ryan, Mirac] choose 2 will be [Harry, Ryan] and [Mirac, Ryan] and [Harry, Mirac]). Returns value is an array within an array. The function only returns combinations without repetition. Hence, [Harry, Mirac] and [Mirac, Harry] are the same and only one unique combination is taking.
    func combinationsWithoutRepetitionFrom<T>(_ elements: [T], taking: Int) -> [[T]] {
        guard elements.count >= taking else { return [] }
        guard elements.count > 0 && taking > 0 else { return [[]] }
        
        if taking == 1 {
            return elements.map {[$0]}
        }
        
        var combinations = [[T]]()
        for (index, element) in elements.enumerated() {
            var reducedElements = elements
            reducedElements.removeFirst(index + 1)
            combinations += combinationsWithoutRepetitionFrom(reducedElements, taking: taking - 1).map {[element] + $0}
        }
        
        return combinations
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
        
        let indexToRemove = customQuestions.index(of: question)
        customQuestions.remove(at: indexToRemove!)
        
        return true
    }
    
    /**
     Generates a quiz with 10 questions.
     - returns: A Quiz object with 10 questions.
     */
    func generateQuestions() -> Quiz {
        var randomNum = 0
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
        for index in 0...sizeOfPeopleBank-1 {
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
        
        
        if listOfLabels.count > 1 {
            
            for index in 0...sizeOfLabelBank-1 {
                if listOfLabels[index].getPeople().count > 2  {
                    var tempListOfLabels = listOfLabels
                    // var tempListOfLabel = listOfLabels[index]
                    var tempListOfPeople = listOfLabels[index].getPeople()
                    var choiceIndex: [Int] = [0, 1, 2, 3]
                    
                    tempQuestion = Question()
                    
                    tempChoice = Choice()
                    
                    // no label photo to display for this version yet
                    tempQuestion.text = "Who does not have the label \(tempListOfLabels[index].getName())"
                    // choice 1
                    
                    
                    randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count))) // get random label and then access the info of three people for the three false choices
                    tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
                    tempChoice.person = tempListOfPeople[randomNum]
                    tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
                    tempListOfPeople.remove(at: randomNum)
                    
                    randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
                    _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
                    choiceIndex.remove(at: randomNum)
                    
                    // choice 2
                    
                    tempChoice = Choice()
                    
                    randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count))) // get random label and then access the info of three people for the three false choices
                    tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
                    tempChoice.person = tempListOfPeople[randomNum]
                    tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
                    tempListOfPeople.remove(at: randomNum)
                    
                    randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
                    _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
                    choiceIndex.remove(at: randomNum)
                    
                    // choice 3
                    tempChoice = Choice()
                    
                    randomNum = Int(arc4random_uniform(UInt32(tempListOfPeople.count))) // get random label and then access the info of three people for the three false choices
                    tempChoice.pathToPhoto = tempListOfPeople[randomNum].getInfo().pathToPhoto
                    tempChoice.person = tempListOfPeople[randomNum]
                    tempChoice.text = "\(tempListOfPeople[randomNum].getName().firstName) " + "\(tempListOfPeople[randomNum].getName().lastName)"
                    tempListOfPeople.remove(at: randomNum)
                    
                    randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
                    _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
                    choiceIndex.remove(at: randomNum)
                    
                    // choice 4 correct choice
                    tempListOfLabels.remove(at: index)
                    tempChoice = Choice()
                    flag = true
                    flag1 = true
                    
                    while(!tempListOfLabels.isEmpty && flag) {
                        randomNum = Int(arc4random_uniform(UInt32(tempListOfLabels.count)))
                        var tempListOfPeople = tempListOfLabels[randomNum].getPeople()
                        while(!tempListOfPeople.isEmpty && flag1) {
                            
                            if listOfLabels[index].getPeople().contains(tempListOfPeople[0]) {
                                tempListOfPeople.remove(at: 0)
                            }
                            else {
                                // tempChoice.pathToPhoto = tempListOfLabels[randomNum].getPeople()[0].getInfo().pathToPhoto
                                tempChoice.pathToPhoto = tempListOfPeople[0].getInfo().pathToPhoto
                                // tempChoice.person = tempListOfLabels[randomNum].getPeople()[0]
                                tempChoice.person = tempListOfPeople[0]
                                // tempChoice.text = "\(tempListOfLabels[randomNum].getPeople()[0].getName().firstName) " + "\(tempListOfLabels[randomNum].getPeople()[0].getName().lastName)"
                                tempChoice.text = "\(tempListOfPeople[0].getName().firstName) \(tempListOfPeople[0].getName().lastName)"
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
        
        
        var tempListOfPeople = combinationsWithoutRepetitionFrom(listOfPeople, taking: 4) // this function returns an array within an array. Every array within the array consists of a distinct combination of four people.
        
        
        
        for index in 0...tempListOfPeople.count-1 // looping through all combinations of the 2d array.
        {   var tempListOfLabels = [Label]() // define a temporary list of labels to store all labels that belongs to a combination of four people.
            for i in 0...tempListOfPeople[index].count-1 // looping through the four people in one combination. Although i used .count just for consistency.
            {
                for j in 0...tempListOfPeople[index][i].getLabels().count-1 // getting the labels from one person
                {
                    tempListOfLabels.append(tempListOfPeople[index][i].getLabels()[j]) // appending those labels that belong to the person.
                    
                }
            }
            
            
            var unionTempListOfLabels = [Label]() // A temporary storage array of label type that will be used to store labels other than the intersection.
            
            for k in 0...tempListOfLabels.count-1 // Can't find a better way of doing this (i'm open to any suggestions). But the intention here is to loop through all the labels in templistOfLabels and then finding the duplicate labels which will not be appended to unionTempListOfLabels.
            {
                if tempListOfLabels.filter({$0 == tempListOfLabels[k]}).count == 1 // .filter returns an array but it does not change the original array itself. So here im extracting all labels tempListOfLabels[k] from tempListOfLabels and then .count to check if its unique.
                {
                    unionTempListOfLabels.append(tempListOfLabels[k]) // Appending all labels that are unique
                }
                
            }
            
            if(unionTempListOfLabels.count > 3) // At least four having four unique labels for question to be valid
            {
                flag = true // a flag to check if every person in the question have at least one unique label. If three people have unique labels and the fourth does not then question will not be appended.
                for l in 0...unionTempListOfLabels.count-1
                {
                    if(unionTempListOfLabels[l].getPeople().contains(tempListOfPeople[index][0]) || unionTempListOfLabels[l].getPeople().contains(tempListOfPeople[index][1]) || unionTempListOfLabels[l].getPeople().contains(tempListOfPeople[index][2]) || unionTempListOfLabels[l].getPeople().contains(tempListOfPeople[index][3])) // hardcoding here should be fine since there are always only 4 people to check
                    {
                        flag = true
                    }
                    else
                    {
                        flag = false
                    }
                }
                
                
                if(flag)
                {
                    tempQuestion = Question()
                    var tempQuestionText = "" // I dont immediately set the question here since i still don't know the matching pair (personN <-> labelN).
                    var choiceIndex: [Int] = [0, 1, 2, 3]
                    var tempChoiceIndex = 0
                    while(!unionTempListOfLabels.isEmpty) // I am going to randomly select a label and see who belongs to that label. While doing so any other unique labels that belongs to the same person is removed from UnionTempListOfLabels since that person is used as one of the choices. Therefore when all four people is set as the choices, there should be no labels left in UnionTempListOfLabels.
                    {
                        randomNum = Int(arc4random_uniform(UInt32(unionTempListOfLabels.count)))
                        
                        for m in 0...tempListOfPeople[index].count-1 { // I'm open to any better/more efficient ways to find out who contains the randomly selected label. Obviously one of the 4 people would contain that label i just need to find out who it is to generate the choices.
                            if tempListOfPeople[index][m].getLabels().contains(unionTempListOfLabels[randomNum]) {

                                tempQuestionText = "\(unionTempListOfLabels[randomNum].getName())" // This changes every iteration and the last iteration before exiting the while loop gets used in tempQuestion.text below. But it is still random since the position of the correct choice is also randomly generated.
                                
                                tempChoice = Choice()
                                tempChoice.pathToPhoto = tempListOfPeople[index][m].getInfo().pathToPhoto
                                tempChoice.person = tempListOfPeople[index][m]
                                tempChoice.text = "\(tempListOfPeople[index][m].getName().firstName) " + "\(tempListOfPeople[index][m].getName().lastName)"
                                randomNum = Int(arc4random_uniform(UInt32(choiceIndex.count)))
                                _ = tempQuestion.set(choice: tempChoice, atIndex: choiceIndex[randomNum])
                                tempChoiceIndex = choiceIndex[randomNum]
                                choiceIndex.remove(at: randomNum)
                                unionTempListOfLabels = unionTempListOfLabels.filter({!$0.getPeople().contains(tempListOfPeople[index][m])}) // not sure if this is a correct way of doing it. But the intention here is to filter out the all labels in UnionTempListOfLabels that belong to the person tempListOfPeople[index][m] and then returning that to UnionTempListOfLabels again.
                                break
                            }
                            
                            
                            
                        }
                        
                    }
                    
                    tempQuestion.text = "Who has the label \(tempQuestionText)" // getting the last iteration of tempQuestionText.
                    _ = tempQuestion.set(correctAnswerIndex: tempChoiceIndex) // last generated index from choiceIndex[random].
                    randomizedQuestionsArray.append(tempQuestion)
                }
                
            }
            
        }
        
        // Also include the custom questions in the mix of random questions
        // we want to generate.
        for question in customQuestions {
            randomizedQuestionsArray.append(question)
        }
        
        for _ in 0...9 { // randomizing the resulting question array to be returned as a quiz
            
            randomNum = Int(arc4random_uniform(UInt32(randomizedQuestionsArray.count)))
            
            // We need a different reference for each question, so the copy initializer (constructor)
            // will make a copy of each question (and implicitly each choice) as a new reference.
            let questionToAdd = Question(randomizedQuestionsArray[randomNum])

            quizToReturn.questions.append(questionToAdd)
        }
        
        return quizToReturn
    }

}
