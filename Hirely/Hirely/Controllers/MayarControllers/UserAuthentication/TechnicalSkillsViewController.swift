//
//  TechnicalSkillsViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 10/12/2024.
//

import UIKit
import FirebaseFirestore

class TechnicalSkillsViewController: UIViewController {
    
    //Databse Reference
    let db = Firestore.firestore()
    
    let user = currentUser()
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var tblTechnicalSkillsList: UITableView!
    
    var expertiseToUse: [String] = []
    
    var skills: [SkillItem] = []
    
    var selectedSkills: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExpertise()
        fetchTechnicalSkills()
        
        
        let fullText = "Register Your\nTechnical Skills"
        let wordToColor = "Technical Skills"
        
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
    
    func fetchExpertise(){
        print("Fetching expertise....")
        
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
                        if let expertise = data["expertise"] as? [String]{
                            for ex in expertise{
                                self.expertiseToUse.append(ex)
                                print(ex)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func fetchSkillsArray(forTitle title: String, completion: @escaping ([String]?) -> Void) {
        print("Fetching Skills array...")
        
        // Reference to the collection
        let collectionRef = db.collection("defaultTechnicalSkills")
        
        // Query to find the document where the 'title' field matches the provided title
        collectionRef.whereField("title", isEqualTo: title).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                completion(nil)
                return
            }
            
            // Ensure we have a valid snapshot
            guard let documents = querySnapshot?.documents, let document = documents.first else {
                print("No document found with the given title.")
                completion(nil)
                return
            }
            
            // Access the 'skills' field from the document
            if let skills = document.data()["skills"] as? [String] {
                for i in skills{
                    self.skills.append(SkillItem(label: i, isSelected: false))
                }
                completion(skills)
            } else {
                print("No skills array found in the document.")
                completion(nil)
            }
        }
    }
    
    func fetchTechnicalSkills(){
        
        db.collection("defaultTechnicalSkills").getDocuments { snapshot, error in
            if let error = error{
                print("Something went wrong: \(error.localizedDescription)")
            }
            else{
                self.skills.removeAll()
                
                for ex in self.expertiseToUse{
                    if ex == "Technology & Innovation"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "technology"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Health & Wellness"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "health"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Languages & Linguistics"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "languages"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Science & Research"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "science"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Literature & Writing"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "writing"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Travel & Adventure"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "travel"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Business & Entrepreneurship"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "business"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Art & Design"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "art"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Cooking & Culinary Art"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "cooking"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Public Speaking & Debate"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "publicSpeaking"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Social Engagement"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "social"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Performing Art"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "performingArt"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "History & Culture"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "history"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                    else if ex == "Environmental Sustainability"{
                        for doc in snapshot?.documents ?? []{
                            if doc["title"] as! String == "environment"{
                                if let skills = doc["skills"] as? [String]{
                                    for skill in skills {
                                        self.skills.append(SkillItem(label: skill, isSelected: false))
                                    }
                                }
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tblTechnicalSkillsList.reloadData()
                }
            }
        }
    }
    
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        updateDatabase()
        //performSegue(withIdentifier: "goToPS", sender: sender)
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
                            "technicalSkills" : self.selectedSkills
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

extension TechnicalSkillsViewController: UITableViewDelegate, UITableViewDataSource{
    
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
