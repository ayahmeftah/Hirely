//
//  EmploymentTypeViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 09/12/2024.
//

import UIKit
import FirebaseFirestore

class EmploymentTypeViewController: UIViewController {

    let db = Firestore.firestore()
    let user = currentUser()
    
    var employmentType: String = ""
    var selectedButton: UIButton?
    
    @IBOutlet weak var fullTimeBtn: UIButton!
    @IBOutlet weak var partTimeBtn: UIButton!
    @IBOutlet weak var internshipBtn: UIButton!
    @IBOutlet weak var contractBtn: UIButton!
    @IBOutlet weak var seasonalBtn: UIButton!
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Full text
        let fullText = "What Type of Employment\nare you looking for?"
        let wordToColor = "Type of Employment"
        
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
    
    func showErrorAlert(_ errorMessage: String){
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
            // If a button is already selected, remove the border
            selectedButton?.layer.borderWidth = 0

            // Set the new selected button
            selectedButton = sender

            // Add a border to the selected button
            sender.layer.borderWidth = 2.0
            sender.layer.borderColor = UIColor.orange.cgColor // Set the border color to red
            sender.layer.cornerRadius = 5.0  // Optional: Set rounded corners
    }
    
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if selectedButton == fullTimeBtn{
            employmentType = "Full-Time"
        }
        else if selectedButton == partTimeBtn{
            employmentType = "Part-Time"
        }
        else if selectedButton == internshipBtn{
            employmentType = "Internship"
        }
        else if selectedButton == contractBtn{
            employmentType = "Contract"
        }
        else if selectedButton == seasonalBtn{
            employmentType = "Seasonal"
        }
        else{
            showErrorAlert("Please choose one option")
        }
        
        updateDatabase()
        performSegue(withIdentifier: "goToExpectedSalary", sender: sender)
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
                    
                    // If the userId matches, update the employmentType value
                    if let userId = data["userId"] as? String, userId == userIdToFind {
                        // Document reference for updating
                        let documentRef = self.db.collection("Users").document(document.documentID)
                        
                        // Update the employmentType value
                        documentRef.updateData([
                            "employmentType" : self.employmentType
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
