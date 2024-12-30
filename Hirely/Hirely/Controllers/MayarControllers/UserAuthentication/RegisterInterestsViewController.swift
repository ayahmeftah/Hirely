//
//  RegisterInterestsViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 09/12/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterInterestsViewController: UIViewController {
    
    let db = Firestore.firestore()
    let user = currentUser()
    
    var interests: [String] = []
    var selectedButtons: [UIButton?] = []
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    
    @IBOutlet weak var techButton: UIButton!{
        didSet{
            techButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var healthButton: UIButton!{
        didSet{
            healthButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var languagesButton: UIButton!{
        didSet{
            languagesButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var scienceButton: UIButton!{
        didSet{
            scienceButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var writingButton: UIButton!{
        didSet{
            writingButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var travelButton: UIButton!{
        didSet{
            travelButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var businessButton: UIButton!{
        didSet{
            businessButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var artButton: UIButton!{
        didSet{
            artButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var cookingButton: UIButton!{
        didSet{
            cookingButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var publicSpeakingButton: UIButton!{
        didSet{
            publicSpeakingButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var socialButton: UIButton!{
        didSet{
            socialButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var performingArtButton: UIButton!{
        didSet{
            performingArtButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var historyButton: UIButton!{
        didSet{
            historyButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var envButton: UIButton!{
        didSet{
            envButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullText = "Register Your Interests"
        let wordToColor = "Interests"
        
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
    
    @objc func optionTapped(_ sender: UIButton){
        sender.isSelected.toggle()
    }
    
    func showErrorAlert(_ errorMessage: String){
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        
        let buttons: [UIButton] = [techButton, healthButton, languagesButton, scienceButton, writingButton, travelButton, businessButton, artButton, cookingButton, publicSpeakingButton, socialButton, performingArtButton, historyButton, envButton]
        
        for button in buttons {
            if button.isSelected == true {
                selectedButtons.append(button)
            }
        }
        
        if selectedButtons.count == 0{
            showErrorAlert("You have to at least choose one option")
        }
        else{
            for btn in selectedButtons{
                if btn == techButton{
                    interests.append("Technology & Innovation")
                }
                else if btn == healthButton{
                    interests.append("Health & Wellness")
                }
                else if btn == languagesButton{
                    interests.append("Languages & Linguistics")
                }
                else if btn == scienceButton{
                    interests.append("Science & Research")
                }
                else if btn == writingButton{
                    interests.append("Literature & Writing")
                }
                else if btn == travelButton{
                    interests.append("Travel & Adventure")
                }
                else if btn == businessButton{
                    interests.append("Business & Entrepreneurship")
                }
                else if btn == artButton{
                    interests.append("Art & Design")
                }
                else if btn == cookingButton{
                    interests.append("Cooking & Culinary Art")
                }
                else if btn == publicSpeakingButton{
                    interests.append("Public Speaking & Debate")
                }
                else if btn == socialButton{
                    interests.append("Social Engagement")
                }
                else if btn == performingArtButton{
                    interests.append("Performing Art")
                }
                else if btn == historyButton{
                    interests.append("History & Culture")
                }
                else if btn == envButton{
                    interests.append("Environmental Sustainability")
                }
            }
            
            updateDatabase()
            performSegue(withIdentifier: "goToRegisterExpertise", sender: sender)
        }
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
                    
                    // If the userId matches, update the firstName field
                    if let userId = data["userId"] as? String, userId == userIdToFind {
                        // Document reference for updating
                        let documentRef = self.db.collection("Users").document(document.documentID)
                        
                        // Update the firstName field
                        documentRef.updateData([
                            "interests" : self.interests
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
