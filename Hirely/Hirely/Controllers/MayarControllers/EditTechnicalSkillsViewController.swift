//
//  EditTechnicalSkillsViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 29/12/2024.
//

import UIKit
import FirebaseFirestore

protocol EditTechnicalSkillsDelegate: AnyObject {
    func didUpdateTechSkills(updatedSkills: [String])
}

class EditTechnicalSkillsViewController: UIViewController {
    
    let db = Firestore.firestore()
    let userId = currentUser().getCurrentUserId()
    
    weak var delegate: EditTechnicalSkillsDelegate?

    @IBOutlet weak var skillsTblView: UITableView!
    
    var skills: [String] = []
    var addTechSkill = AddTechnicalSkillAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableViews()
        fetchTechnicalSkills()
    }
    
    func fetchTechnicalSkills() {
        let collection = db.collection("Users")
        
        collection.whereField("userId", isEqualTo: userId!).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    if let technicalSkillsArray = data["technicalSkills"] as? [String] {
                        self.skills = technicalSkillsArray
                    }
                }
            }
            
            // Reload data on the main thread after fetching is complete
            DispatchQueue.main.async {
                self.skillsTblView.reloadData()
            }
        }
    }
    
    @IBAction func addSkillClicked(_ sender: UIButton) {
        let alertVC = addTechSkill.alert()
        alertVC.delegate = self
        present(alertVC, animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}


extension EditTechnicalSkillsViewController: UITableViewDelegate, UITableViewDataSource, AddTechnicalSkillDelegate{
    
    func didAddNewTechSkill(newSkill: String) {
        // Add the new skill to the array
        self.skills.append(newSkill)
        
        // Update the table view
        DispatchQueue.main.async {
            self.skillsTblView.reloadData()
        }
        
        // Notify the delegate (SoftTechnicalSkillsViewController) if necessary
        self.delegate?.didUpdateTechSkills(updatedSkills: self.skills)
        dismiss(animated: true)
    }
    
    func configTableViews(){
        skillsTblView.delegate = self
        skillsTblView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editTechnicalSkillsCell", for: indexPath)
        
        cell.textLabel?.text = skills[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            // Create the delete action
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                // Remove item from your data source
                self.skills.remove(at: indexPath.row)
                
                // Delete the row from the table view with animation
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                // Call completion handler to finish the action
                completionHandler(true)
            }
            
            // Create the swipe actions configuration with the delete action
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }
}
