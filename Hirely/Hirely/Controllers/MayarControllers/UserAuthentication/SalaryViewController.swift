//
//  SalaryViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 09/12/2024.
//

import UIKit
import FirebaseFirestore

class SalaryViewController: UIViewController {

    let db = Firestore.firestore()
    let user = currentUser()
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    
    @IBOutlet weak var minimumSalarySlider: UISlider!
    
    @IBOutlet weak var maximumSalarySlider: UISlider!
    
    @IBOutlet weak var minimumSalaryLabel: UILabel!
    
    @IBOutlet weak var maximumSalaryLabel: UILabel!
    
    var valOfMinSalary: Int = 300
    var valOfMaxSalary: Int = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        minimumSalarySlider.value = Float(valOfMaxSalary)
        maximumSalarySlider.value = Float(valOfMaxSalary)
        minimumSalarySlider.minimumValue = 300
        minimumSalarySlider.maximumValue = 5000
        maximumSalarySlider.minimumValue = 400
        maximumSalarySlider.maximumValue = 10000
        minimumSalaryLabel.text = "\(minimumSalarySlider.value)"
        maximumSalaryLabel.text = "\(maximumSalarySlider.value)"
        
        // Full text
        let fullText = "What Salary Range\nare you expecting?"
        let wordToColor = "Salary Range"
        
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
    
    
    func updateView(){
        let currentValOfMin = minimumSalarySlider.value
        let currentValOfMax = maximumSalarySlider.value
        
        if currentValOfMin > 300.0{
            valOfMinSalary = Int(currentValOfMin)
        }
        
        if currentValOfMax > 400.0{
            valOfMaxSalary = Int(currentValOfMax)
        }
    }
    
    
    @IBAction func minimumSalaryValueChanged(_ sender: UISlider) {
        let intValue = Int(sender.value)
        sender.value = Float(intValue)
        minimumSalaryLabel.text = "\(intValue)"
        updateView()
    }
    
    @IBAction func maximumSalaryValueChanged(_ sender: UISlider) {
        let intValue = Int(sender.value)
        sender.value = Float(intValue)
        maximumSalaryLabel.text = "\(intValue)"
        updateView()
    }

    @IBAction func nextBtnClicked(_ sender: UIButton) {
        updateDatabase()
        performSegue(withIdentifier: "goToSoftSkills", sender: sender)
    }
    
    func updateDatabase(){
        
        let collection = db.collection("Users")
        let userIdToFind = user.getCurrentUserId()
        
        let minVal = Double(minimumSalarySlider.value)
        let maxVal = Double(maximumSalarySlider.value)
        
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
                            "maximumExpectedSalary" : maxVal,
                            "minimumExpectedSalary" : minVal
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
