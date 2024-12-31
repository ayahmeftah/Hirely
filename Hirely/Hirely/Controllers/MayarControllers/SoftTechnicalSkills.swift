//
//  SkillsExperienceViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 10/12/2024.
//

import UIKit
import FirebaseFirestore

class SoftTechnicalSkills: UIViewController{
    
    let db = Firestore.firestore()
    let userId = currentUser().getCurrentUserId()
    
    @IBOutlet weak var softSkillsTableView: UITableView!
    @IBOutlet weak var technicalSkillsTableView: UITableView!
    
    var softSkills: [String] = []
    var technicalSkills: [String] = []
    
    let editSoftskills = EditSoftSkill()
    let editTechSkills = EditTechnicalSkill()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableViews()
        fetchSoftSkills()
        fetchTechnicalSkills()
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
                        self.softSkills = softSkillsArray
                    }
                }
            }
            
            // Reload data on the main thread after fetching is complete
            DispatchQueue.main.async {
                self.softSkillsTableView.reloadData()
            }
        }
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
                        self.technicalSkills = technicalSkillsArray
                    }
                }
            }
            
            // Reload data on the main thread after fetching is complete
            DispatchQueue.main.async {
                self.technicalSkillsTableView.reloadData()
            }
        }
    }
    
    @IBAction func editSoftSkillsBtnTapped(_ sender: UIButton) {
        let editVC = editSoftskills.show()
        editVC.delegate = self
        present(editVC, animated: true)
    }
    
    @IBAction func editTechnicalSkillsBtnTapped(_ sender: UIButton) {
        let editVC = editTechSkills.show()
        editVC.delegate = self
        present(editVC, animated: true)
    }
}

extension SoftTechnicalSkills: UITableViewDelegate, UITableViewDataSource, EditSoftSkillDelegate, EditTechnicalSkillsDelegate{
    
    func didUpdateSoftSkills(updatedSkills: [String]) {
        self.softSkills = updatedSkills
        DispatchQueue.main.async {
            self.softSkillsTableView.reloadData()
        }
    }
    
    func didUpdateTechSkills(updatedSkills: [String]) {
        self.technicalSkills = updatedSkills
        DispatchQueue.main.async {
            self.technicalSkillsTableView.reloadData()
        }
    }
    
    func configTableViews(){
        softSkillsTableView.tag = 1
        technicalSkillsTableView.tag = 2
        softSkillsTableView.delegate = self
        softSkillsTableView.dataSource = self
        technicalSkillsTableView.delegate = self
        technicalSkillsTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 1 {
            return 1
        }
        else if tableView.tag == 2 {
            return 1 // Number of sections for tableView2
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return softSkills.count
        }
        else if tableView.tag == 2{
            return technicalSkills.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        if tableView.tag == 1 {
            cell.textLabel?.text = softSkills[indexPath.row]
        }
        else if tableView.tag == 2{
            cell.textLabel?.text = technicalSkills[indexPath.row]
        }
        return cell
    }
}
