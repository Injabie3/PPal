//
//  CustomQuizViewController.swift
//  PPal
//
//  Created by Harry Gong on 12/1/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class CustomQuizViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var customQuizList = QuizBank.shared.getCustomQuestions()
    
    @IBOutlet weak var customQuizTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customQuizTableView.delegate = self
        customQuizTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        customQuizList = QuizBank.shared.getCustomQuestions()
        customQuizTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return customQuizList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier="CustomQuizTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomQuizTableViewCell else {
            fatalError("The dequeued cell is not an instance of CustomQuizTableViewCell")
        }
        
        let quiz = customQuizList[indexPath.row]
        cell.customQuizLabel.text = "\(quiz.text)"
        
       
        
        
        
        if (indexPath.row % 2) != 0 {
            cell.backgroundColor = UIColor .white
        }
        else {
            cell.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.93, alpha: 1.0)
        }
        
        return cell
        
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            // Deselect the row so the colour goes back to normal.
            
            tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    /// Table view function to support swiping left for different options such as Edit and Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Program the Delete button for the Person List table view.
        let deleteQuestion = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            // Delete the row from the data source
            
            let personAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this question?", preferredStyle: .alert)
            
            let alertYes = UIAlertAction(title: "Yes", style: .destructive) { action in
                // This line below was before we implemented the search bar.
                // let people = PeopleBank.shared.getPeople()
                let questions = QuizBank.shared.getCustomQuestions()
                
                _ = Database.shared.deleteQuestionById(id: questions[indexPath.row].getId())
                _ = QuizBank.shared.delCustom(question: questions[indexPath.row])
                
                // Make the table view consistent again.
                self.customQuizList = QuizBank.shared.getCustomQuestions()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let alertNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            personAlert.addAction(alertYes)
            personAlert.addAction(alertNo)
            
            // Confirm with the user if they want to delete the person.
            self.present(personAlert, animated: true, completion: nil)
        }
        
        deleteQuestion.backgroundColor = .red
        
        // Display the corresponding buttons in the table views when we swipe left.
        return [deleteQuestion]
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
