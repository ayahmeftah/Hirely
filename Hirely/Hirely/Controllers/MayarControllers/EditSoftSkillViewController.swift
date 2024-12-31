//
//  EditSoftSkillViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 12/12/2024.
//

import UIKit
import FirebaseFirestore

protocol EditSoftSkillDelegate: AnyObject {
    func didUpdateSoftSkills(updatedSkills: [String])
}

class EditSoftSkillViewController: UIViewController {
    
    let db = Firestore.firestore()
    let userId = currentUser().getCurrentUserId()
    let addSoftSkillAlert = AddSoftSkillAlert()
    weak var delegate: EditSoftSkillDelegate?
    var skills: [String] = []
    
    @IBOutlet weak var addSkillBtn: UIButton!
    @IBOutlet weak var skillsTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableViews()
        fetchSoftSkills()
    }
    
    @IBAction func addSkillClicked(_ sender: UIButton) {
        let alertVC = addSoftSkillAlert.alert()
        alertVC.delegate = self
        present(alertVC, animated: true)
    }
    
    func fetchSoftSkills() {
        let collection = db.collection("Users")
        
        collection.whereField("userId", isEqualTo: userId!).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    if let softSkillsArray = data["softSkills"] as? [String] {
                        self.skills = softSkillsArray
                    }
                }
            }
            
            // Reload data on the main thread after fetching is complete
            DispatchQueue.main.async {
                self.skillsTblView.reloadData()
            }
        }
    }
    
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}


extension EditSoftSkillViewController: UITableViewDelegate, UITableViewDataSource, AddSoftSkillDelegate {
    
    func didAddNewSoftSkill(newSkill: String) {
        // Add the new skill to the array
        self.skills.append(newSkill)
        
        // Update the table view
        DispatchQueue.main.async {
            self.skillsTblView.reloadData()
        }
        
        // Notify the delegate (SoftTechnicalSkillsViewController) if necessary
        self.delegate?.didUpdateSoftSkills(updatedSkills: self.skills)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "editSoftSkillCell", for: indexPath)
        
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
                self.delegate?.didUpdateSoftSkills(updatedSkills: self.skills)
            }
            
            // Create the swipe actions configuration with the delete action
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }
}
