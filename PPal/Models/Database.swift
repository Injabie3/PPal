//
//  Database.swift
//  PPal
//
//  Created by Mirac Chen on 10/29/2017.
//  Copyright © 2017 CMPT275. All rights reserved.
//


import Foundation
import SQLite
import UIKit

class Database {

    static var shared = Database()
    
    // Table variable declaration for persons
    let personsTable = Table("persons")
    let id = Expression<Int>("id")
    let pathToPhoto = Expression<String>("pathToPhoto")
    let firstName = Expression<String>("firstName")
    let lastName = Expression<String>("lastName")
    let phoneNumber = Expression<String>("phoneNumber")
    let email = Expression<String>("email")
    let address = Expression<String>("address")
    let hasHouseKeys = Expression<Bool>("hasHouseKeys")
    let labels = Expression<String>("labels")
    var database: Connection!
    
    // Table variable declaration for labels
    let labelTable = Table("labels")
    let labelId = Expression<Int>("id")
    let label = Expression<String>("label")
    var labelDatabase: Connection!
    
    //Table variable declaration for questions
    let questionTable = Table("question")
    let questionId = Expression<Int>("questionId")
    let question = Expression<String>("question")
    let questionPhoto = Expression<String>("questionPhoto")
    let choice1 = Expression<Int>("choice1")
    let choice2 = Expression<Int>("choice2")
    let choice3 = Expression<Int>("choice3")
    let choice4 = Expression<Int>("choice4")
    let correctAns = Expression<Int>("correctAns")
    let selectedAns = Expression<Int>("selectedAns")
    var questionsDatabase: Connection!
    
    //Table variable declaration for choices
    let choiceTable = Table("choices")
    let choiceId = Expression<Int>("choiceId")
    let choiceText = Expression<String>("choiceText")
    let choicePhoto = Expression<String>("choicePhoto")
    let personId = Expression<Int?>("personId")
    var choicesDatabase: Connection!
    
    //Table variable declaration for quiz
    let quizTable = Table("quizzes")
    let sessionId = Expression<Int>("sessionId")
    let date = Expression<Date>("date")
    let questions = Expression<String>("questions")
    let score = Expression<Int>("score")
    var quizzesDatabase: Connection!
    
    // create document path URL if not existed
    private init() {
        do {
            // creating persons database
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("persons").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            self.createTable()
            
            // creating labels database
            let labelDocumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let labelFileUrl = labelDocumentDirectory.appendingPathComponent("labels").appendingPathExtension("sqlite3")
            let labelDatabase = try Connection(labelFileUrl.path)
            self.labelDatabase = labelDatabase
            self.createTableForLabel()
            
            // creating questions database
            let questionsDocumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let questionsFileUrl = questionsDocumentDirectory.appendingPathComponent("questions").appendingPathExtension("sqlite3")
            let questionsDatabase = try Connection(questionsFileUrl.path)
            self.questionsDatabase = questionsDatabase
            self.createTableForQuestions()
            
            // creating choices database
            let choicesDocumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let choicesFileUrl = choicesDocumentDirectory.appendingPathComponent("choices").appendingPathExtension("sqlite3")
            let choicesDatabase = try Connection(choicesFileUrl.path)
            self.choicesDatabase = choicesDatabase
            self.createTableForChoices()
            
            // creating quizzes database
            let quizzesDocumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let quizzesFileUrl = quizzesDocumentDirectory.appendingPathComponent("quizzes").appendingPathExtension("sqlite3")
            let quizzesDatabase = try Connection(quizzesFileUrl.path)
            self.quizzesDatabase = quizzesDatabase
            self.createTableForQuizzes()
            
        } catch {
            print(error)
        }    // Establish connection to the database file
    }
    
    /// Recreate tables for the database.  For testing purposes.
    func recreateDatabase() {
        do {
            // creating persons database
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("persons").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            self.createTable()
            
            // creating labels database
            let labelDocumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let labelFileUrl = labelDocumentDirectory.appendingPathComponent("labels").appendingPathExtension("sqlite3")
            let labelDatabase = try Connection(labelFileUrl.path)
            self.labelDatabase = labelDatabase
            self.createTableForLabel()
            
            // creating questions database
            let questionsDocumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let questionsFileUrl = questionsDocumentDirectory.appendingPathComponent("questions").appendingPathExtension("sqlite3")
            let questionsDatabase = try Connection(questionsFileUrl.path)
            self.questionsDatabase = questionsDatabase
            self.createTableForQuestions()
            
            // creating choices database
            let choicesDocumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let choicesFileUrl = choicesDocumentDirectory.appendingPathComponent("choices").appendingPathExtension("sqlite3")
            let choicesDatabase = try Connection(choicesFileUrl.path)
            self.choicesDatabase = choicesDatabase
            self.createTableForChoices()
            
            // creating quizzes database
            let quizzesDocumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let quizzesFileUrl = quizzesDocumentDirectory.appendingPathComponent("quizzes").appendingPathExtension("sqlite3")
            let quizzesDatabase = try Connection(quizzesFileUrl.path)
            self.quizzesDatabase = quizzesDatabase
            self.createTableForQuizzes()
            
            
        } catch {
            print(error)
        }    // Establish connection to the database file
    }
    
    
    /// Table creation for Persons
    private func createTable() {
        
        let tryCreatingTable = self.personsTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.pathToPhoto)
            table.column(self.firstName)
            table.column(self.lastName)
            table.column(self.phoneNumber, unique: true)
            table.column(self.email, unique: true)
            table.column(self.address)
            table.column(self.hasHouseKeys)
            table.column(self.labels)
            print("Person Table Created!")
        }
        
        do {
            try self.database.run(tryCreatingTable)
        } catch {
            print(error)
        }
        
    }
    
    
    /// Table creation for Labels
    private func createTableForLabel() {
        
        let tryCreatingLabelTable = self.labelTable.create { (table) in
            table.column(self.labelId, primaryKey: true)
            table.column(self.label, unique: true)
            print("Label Table Created!")
        }
        
        do {
            try self.labelDatabase.run(tryCreatingLabelTable)
        } catch {
            print(error)
        }
    }
    
    
    
    
    
    /// Table creation for Questions
    private func createTableForQuestions() {
        
        let tryCreatingQuestionsTable = self.questionTable.create { (table) in
            table.column(self.questionId, primaryKey: true)
            table.column(self.question)
            table.column(self.questionPhoto)
            table.column(self.choice1)
            table.column(self.choice2)
            table.column(self.choice3)
            table.column(self.choice4)
            table.column(self.correctAns)
            table.column(self.selectedAns)
            print("Questions Table Created!")
        }
        
        do {
            try self.questionsDatabase.run(tryCreatingQuestionsTable)
        } catch {
            print(error)
        }
    }
    
    /// Table creation for Choices
    private func createTableForChoices() {
        
        let tryCreatingChoicesTable = self.choiceTable.create { (table) in
            table.column(self.choiceId, primaryKey: true)
            table.column(self.choiceText)
            table.column(self.choicePhoto)
            table.column(self.personId)
            print("Choices Table Created!")
        }
        
        do {
            try self.choicesDatabase.run(tryCreatingChoicesTable)
        } catch {
            print(error)
        }
    }
    
    /// Table creation for Quizzes
    private func createTableForQuizzes() {
        
        let tryCreatingQuizTable = self.quizTable.create { (table) in
            table.column(self.sessionId, primaryKey: true)
            table.column(self.date)
            table.column(self.questions)
            table.column(self.score)
            print("Quizzes Table Created!")
        }
        
        do {
            try self.quizzesDatabase.run(tryCreatingQuizTable)
        } catch {
            print(error)
        }
    }
    
    /**
     Saves a person to the database for the first time.
     - parameter profile: A Person object.
     - returns: true or false.
         - True if the person was saved to the database.
         - False if the person could not be saved.
     */
    func saveProfileToDatabase(profile: Person) -> Bool {
        
        var labelArray = [String]()
        for label in profile.getInfo().labels {
            labelArray.append(label.getName())
        }
        
        let labelString = labelArray.joined(separator: ",")
        
        // Save profile entry to database
        let saveProfile = self.personsTable.insert(self.pathToPhoto <- profile.getInfo().pathToPhoto,
                                                   self.firstName <- profile.getInfo().firstName,
                                                   self.lastName <- profile.getInfo().lastName,
                                                   self.phoneNumber <- profile.getInfo().phoneNumber,
                                                   self.email <- profile.getInfo().email,
                                                   self.address <- profile.getInfo().address,
                                                   self.hasHouseKeys <- profile.getInfo().hasHouseKeys,
                                                   self.labels <- labelString)
        do {
            let rowid = try self.database.run(saveProfile)
            profile.set(id: Int(truncatingIfNeeded: rowid))
            print("Saved profile (rowid: \(rowid)) to database")
            return true
        } catch {
            print(error)
            return false
        }

    }
    
    /**
     Saves a label to the database for the first time.
     - parameter label: A Label object.
     - returns: true or false.
     - True if the label was saved to the database.
     - False if the label could not be saved.
     */
    func saveLabelToDatabase(label: Label) -> Bool {
        
        let saveLabel = self.labelTable.insert(self.label <- label.getName())
        do {
            let rowid = try self.labelDatabase.run(saveLabel)
            label.set(id: Int(truncatingIfNeeded: rowid))
            print("Saved label (rowid: \(rowid)) to database")
            return true
        } catch {
            print(error)
            return false
        }
        
    }
    
    
    
    /**
     Saves a question to the database for the first time.
     - parameter label: A Question object.
     - returns: true or false.
     - True if the question was saved to the database.
     - False if the question could not be saved.
     */
    func saveQuestionToDatabase(question: Question) -> Bool {
        
        let saveQuestion = self.questionTable.insert(self.question <- question.text, self.questionPhoto <- question.image, self.choice1 <- question.getChoices()[0].id, self.choice2 <- question.getChoices()[1].id, self.choice3 <- question.getChoices()[2].id, self.choice4 <- question.getChoices()[3].id, self.correctAns <- question.getCorrectAnswer(), self.selectedAns <- question.getSelectedAnswer())
        do {
            let rowid = try self.questionsDatabase.run(saveQuestion)
            question.set(id: Int(truncatingIfNeeded: rowid))
            print("Saved question (rowid: \(rowid)) to database")
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    
    /**
     Saves a choice to the database for the first time.
     - parameter choice: A Label object.
     - returns: true or false.
     - True if the choice was saved to the database.
     - False if the choice could not be saved.
     */
    func saveChoiceToDatabase(choice: Choice) -> Bool {
        
        let saveChoice = self.choiceTable.insert(self.choiceText <- choice.text, self.choicePhoto <- choice.pathToPhoto) //self.personId <- choice.person.getId()
        do {
            let rowid = try self.choicesDatabase.run(saveChoice)
            choice.id = Int(truncatingIfNeeded: rowid)
            print("Saved choice (rowid: \(rowid)) to database")
            return true
        } catch {
            print(error)
            return false
        }
        
    }
    
    
    /**
     Saves a quiz to the database for the first time.
     - parameter quiz: A Label object.
     - returns: true or false.
     - True if the quiz was saved to the database.
     - False if the quiz could not be saved.
     */
    func saveQuizToDatabase(quiz: Quiz) -> Bool {
        
        var questionArray = [String]()
        for question in quiz.questions {
            questionArray.append("\(question.getId())")
        }
        
        let questionString = questionArray.joined(separator: ",")
        
        let saveQuiz = self.quizTable.insert(self.date <- quiz.dateTaken, self.questions <- questionString, self.score <- quiz.score)
        do {
            let rowid = try self.quizzesDatabase.run(saveQuiz)
            quiz.id = Int(truncatingIfNeeded: rowid)
            print("Saved quiz (rowid: \(rowid)) to database")
            return true
        } catch {
            print(error)
            return false
        }
        
    }
    
    
    
    // Search and return label by ID
    func retrieveLabelById(id: Int) {
        
        let label = self.labelTable.filter(self.labelId == id)
        do {
            let labels = try self.labelDatabase!.prepare(label)
            for selectedLabel in labels {
                print("labelID: \(selectedLabel[self.labelId]), label: \(selectedLabel[self.label])")
            }
        } catch {
            print (error)
        }
        
    }
    
	

    // Search and return profile by ID
    func retrieveProfileById(id: Int) {

        let profile = self.personsTable.filter(self.id == id)
        do {
            let people = try self.database!.prepare(profile)
            for person in people {
                print("userId: \(person[self.id]), firstName: \(person[self.firstName]), lastName: \(person[self.lastName]), phoneNumber: \(person[self.phoneNumber]), email: \(person[self.email]), address: \(person[self.address]), hasHouseKeys: \(person[self.hasHouseKeys]), labels: \(person[self.labels])")
            }
        } catch {
            print (error)
        }

    }



    /**
     Deletes a Person from the database
     - parameter id: The ID of the Person, which can be obtained from the getId() method of the person.
     - returns: true or false
         - True if the person was successfully deleted from the database.
         - False if the person could not be deleted.
     */
    func deleteProfileById(id: Int) -> Bool {
            
        let profile = self.personsTable.filter(self.id == id)
        let deleteProfile = profile.delete()
        do {
            try self.database.run(deleteProfile)
            return true
        } catch {
            print(error)
            return false
        }
    }
	
    /**
     Deletes a Label from the database
     - parameter id: The ID of the Label, which can be obtained from the getId() method of the label.
     - returns: true or false
         - True if the label was successfully deleted from the database.
         - False if the label could not be deleted.
     */
    func deleteLabelById(id: Int) -> Bool {
        
        let label = self.labelTable.filter(self.id == id)
        let deleteLabel = label.delete()
        do {
            try self.labelDatabase.run(deleteLabel)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    /**
     Updates a Person profile in the database.
     - parameter profile: A person object.
     - returns: true or false
         - True if the update was successful.
         - False if it could not be updated.
     */
    func updateProfile(profile: Person) -> Bool {
        
        var labelArray = [String]()
        for label in profile.getInfo().labels {
            labelArray.append(label.getName())
        }
        
        let labelString = labelArray.joined(separator: ",")
        
        let updateProfile = self.personsTable.update(self.pathToPhoto <- profile.getInfo().pathToPhoto,
                                                     self.firstName <- profile.getInfo().firstName,
                                                     self.lastName <- profile.getInfo().lastName,
                                                     self.phoneNumber <- profile.getInfo().phoneNumber,
                                                     self.email <- profile.getInfo().email,
                                                     self.address <- profile.getInfo().address,
                                                     self.hasHouseKeys <- profile.getInfo().hasHouseKeys,
                                                     self.labels <- labelString)
        do {
            try self.database.run(updateProfile)
            let rowid = profile.getId()
            print("Updated profile (rowid: \(rowid)) in database")
            return true
        } catch {
            print(error)
            return false
        }
        
        
    }
    
    /**
     Updates a Label in the database.
     - parameter label: A Label object.
     - returns: true or false
         - True if the update was successful.
         - False if it could not be updated.
     */
    func updateLabel(label: Label) -> Bool {

        let updateLabel = self.labelTable.update(self.label <- label.getName())
        do {
            try self.labelDatabase.run(updateLabel)
            let rowid = label.getId()
            print("Updated label (rowid: \(rowid)) in database")
            return true
        } catch {
            print(error)
            return false
        }

    }
    
    /**
     Builds the PeopleBank class from the database.
     
     - returns: A PeopleBank object.
     - by Ryan on Oct 31, 2017
     */
    func getAllData() -> PeopleBank {
        let bank = PeopleBank.shared
        
        do {
            let labelsInDatabase = try self.labelDatabase!.prepare(labelTable)
            for label in labelsInDatabase {
                print("Id: \(label[self.labelId]), name: \(label[self.label])")
                
                // Create a Label object per result, and add this label into the bank.
                let labelObject = Label()
                labelObject.set(id: label[self.labelId])
                labelObject.editLabel(name: label[self.label])
                
                _ = bank.add(label: labelObject)
            }
        } catch {
            print (error)
        }
        
        // At this point, all the labels are in the PeopleBank.
        let labelObjectArray = bank.getLabels()
        do {
            // Get all the people from the database.
            let peopleInDatabase = try self.database!.prepare(personsTable)
            
            for person in peopleInDatabase {
                print("userId: \(person[self.id]), firstName: \(person[self.firstName]), lastName: \(person[self.lastName]), phoneNumber: \(person[self.phoneNumber]), email: \(person[self.email]), address: \(person[self.address]), hasHouseKeys: \(person[self.hasHouseKeys]), labels: \(person[self.labels])")
                
                // For each person, construct a Person object with the information from the database.
                let personObject = Person()
                _ = personObject.setInfo(pathToPhoto: person[pathToPhoto],
                                         firstName: person[firstName],
                                         lastName: person[lastName],
                                         phoneNumber: person[phoneNumber],
                                         email: person[email],
                                         address: person[address],
                                         hasHouseKeys: person[hasHouseKeys])
                
                personObject.set(id: person[self.id])
                let labelTextArray = person[self.labels].components(separatedBy: ",")
                
                // Now add the labels that this person has to it.  Since we only have the names of the labels, we have to search for the label
                // object using this.
                for labelText in labelTextArray {
                    // Get the associated label object, and associate it with the person.
                    // If the label object doesn't exist, then don't add it to the person.
                    let labelIndex = labelObjectArray.index(where: { $0.getName().lowercased() == labelText.lowercased() })
                    if labelIndex != nil {
                        personObject.add(label: labelObjectArray[labelIndex!])
                    }
                }
                
                // Now this person object is ready, and we can now add it to the bank.
                _ = bank.add(person: personObject)
            }
        } catch {
            print (error)
        }
        
        return bank
    }
	
	
    /**
     Builds the QuizBank class from the database.
     
     - returns: A QuizBank object.
     */
    func getAllQuizData() { //-> QuizBank or not?
        let bank = QuizBank.shared
        var choiceArray = [Choice]()
        var questionArray = [Question]()

        //loading choices from database into choiceArray
        do {
            let choicesInDatabase = try self.choicesDatabase!.prepare(choiceTable)
            for choice in choicesInDatabase {
                print("Id: \(choice[self.choiceId]), choiceText: \(choice[self.choiceText]), personID: \(String(describing: choice[self.personId]))")

                // Create a Choice object per result, and add this choice into the choiceArray.
                let choiceObject = Choice()
                choiceObject.id = choice[self.choiceId]
                choiceObject.text = choice[self.choiceText]
                choiceObject.pathToPhoto = choice[self.choicePhoto]
                //not sure about the following line yet***
                //choiceObject.person = choice[self.person]
                choiceArray.append(choiceObject)
            }
        } catch {
            print (error)
        }
        
        //At this point, we should have an array of choices ready to be loaded into questions
        do {
            let questionInDatabase = try self.questionsDatabase!.prepare(questionTable)
            for question in questionInDatabase {
                print("Id: \(question[self.questionId]), question: \(question[self.question]), choice1: \(question[self.choice1]), choice2: \(question[self.choice2]), choice3: \(question[self.choice3]), choice4: \(question[self.choice4]), correctAns: \(question[self.correctAns]), selectedAns: \(question[self.selectedAns])")
                let questionObject = Question()
                // Set the question id from the primary key in the database.
                questionObject.set(id: question[self.questionId])
                
                // Set the text and image.
                questionObject.text = question[self.question]
                questionObject.image = question[self.questionPhoto]
                
                // Add each choice in from the choice array above, will double check to make sure the index is not nil.
                if let index0 = choiceArray.index(where: { $0.id == question[self.choice1] }) {
                    _ = questionObject.set(choice: choiceArray[index0], atIndex: 0)
                }
                if let index1 = choiceArray.index(where: { $0.id == question[self.choice2] }) {
                    _ = questionObject.set(choice: choiceArray[index1], atIndex: 1)
                }
                if let index2 = choiceArray.index(where: { $0.id == question[self.choice3] }) {
                    _ = questionObject.set(choice: choiceArray[index2], atIndex: 2)
                }
                if let index3 = choiceArray.index(where: { $0.id == question[self.choice4] }) {
                    _ = questionObject.set(choice: choiceArray[index3], atIndex: 3)
                }
                
                // Set the correct answer, and selected answer indices.
                _ = questionObject.set(correctAnswerIndex: question[self.correctAns])
                _ = questionObject.set(selectedAnswerIndex: question[self.selectedAns])
                questionArray.append(questionObject)
            }
        } catch {
            print (error)
        }


        // At this point, all the questions are loaded in questionArray
        do {
            let quizInDatabase = try self.quizzesDatabase!.prepare(quizTable)
            for quiz in quizInDatabase {
                print("Id: \(quiz[self.sessionId]), date: \(quiz[self.date]), questions: \(quiz[self.questions]), score: \(quiz[self.score])")
                // Create a Choice object per result, and add this choice into the bank.
                let quizObject = Quiz()
                quizObject.id = quiz[self.sessionId]
                quizObject.dateTaken = quiz[self.date]
                quizObject.score = quiz[self.score]
                //Make the question ID string back to an array of question IDs
                //***The following code needs to be tested
                let array = quiz[self.questions].components(separatedBy: ",")
                //Above might be a String array, need to think of a way cast them back to Int before next lines to work
                for questionID in array {
                    quizObject.questions.append(questionArray[Int(questionID)!-1])
		}
                bank.quizHistory.append(quizObject)
            }
        } catch {
            print (error)
        }

        //return bank or not
    }

}
