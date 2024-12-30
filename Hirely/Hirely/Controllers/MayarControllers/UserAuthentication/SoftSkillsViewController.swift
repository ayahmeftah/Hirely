//
//  SoftSkillsViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 09/12/2024.
//

import UIKit
import FirebaseFirestore

class SoftSkillsViewController: UIViewController {
    
    let db = Firestore.firestore()
    let user = currentUser()
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tblSoftSkillsList: UITableView!
    
    var skills: [SkillItem] = []
    
    var selectedSkills: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSoftSkills()
        
        let fullText = "Register Your\nSoft Skills"
        let wordToColor = "Soft Skills"
        
        // Create an attributed string
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: wordToColor) {
            let nsRange = NSRange(range, in: fullText)
            let customColor = UIColor(red: 38/255, green: 139/255, blue: 221/255, alpha: 1.0) // Custom color
            attributedString.addAttribute(.foregroundColor, value: customColor, range: nsRange)
        }
        
        // Assign the attributed string to the label
        screenTitleLabel.attributedText = attributedString
        
    }
    
    func fetchSoftSkills(){
        
        db.collection("defaultSoftSkills").getDocuments { snapshot, error in
            if let error = error{
                print("Something went wrong: \(error.localizedDescription)")
            }
            else{
                self.skills.removeAll()
                for doc in snapshot?.documents ?? []{
                    if let skills = doc["skills"] as? [String]{
                        for skill in skills {
                            self.skills.append(SkillItem(label: skill, isSelected: false))
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tblSoftSkillsList.reloadData()
                }
            }
        }
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        updateDatabase()
        performSegue(withIdentifier: "goToTechnicalSkills", sender: sender)
    }
    
    func updateDatabase(){
        
        let collection = db.collection("Users")
        let userIdToFind = user.getCurrentUserId()
        
        // Query for documents where the userId field matches the specified value
        collection.whereField("userId", isEqualTo: userIdToFind!).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            // Loop through the documents in the snapshot
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    // You have the document, so you can access its data
                    let data = document.data()
                    print("Document data: \(data)")
                    
                    // If the userId matches, update the min and max salary
                    if let userId = data["userId"] as? String, userId == userIdToFind {
                        // Document reference for updating
                        let documentRef = self.db.collection("Users").document(document.documentID)
                        
                        // Update the min and max salary
                        documentRef.updateData([
                            "softSkills" : self.selectedSkills
                        ]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated!")
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SoftSkillsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillListCell") as? SkillTableViewCell
        
        let item = skills[indexPath.row]
        cell?.checkUncheckBtn.isSelected = item.isSelected
        cell?.skillNameLabel.text = item.label
        cell?.checkUncheckBtn.tag = indexPath.row
        cell?.checkUncheckBtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        
        return cell!
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        skills[rowIndex].isSelected.toggle() // Toggle selection state
        sender.isSelected = skills[rowIndex].isSelected
        
        // Update the selected labels array
        selectedSkills = skills.filter { $0.isSelected }.map { $0.label }
        
        //print(selectedSkills) // For debugging purposes
    }
}
