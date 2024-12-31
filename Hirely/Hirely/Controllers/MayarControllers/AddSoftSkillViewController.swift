//
//  AddSoftSkillViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 12/12/2024.
//

import UIKit
import FirebaseFirestore

protocol AddSoftSkillDelegate: AnyObject {
    func didAddNewSoftSkill(newSkill: String)
}

class AddSoftSkillViewController: UIViewController {
    
    let db = Firestore.firestore()
    let userId = currentUser().getCurrentUserId()
    weak var delegate: AddSoftSkillDelegate?
    
    @IBOutlet weak var skillTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    var softSkills: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maskPath = UIBezierPath(roundedRect: self.contentView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 30, height: 30))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        self.contentView.layer.mask = shapeLayer
        
        fetchSoftSkills()
    }
    
    @IBAction func addBtnClicked(_ sender: UIButton) {
        let newSkill = skillTextField.text!
                softSkills.append(newSkill)
                updateDatabase()

                // Notify delegate when a new skill is added
                delegate?.didAddNewSoftSkill(newSkill: newSkill)
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func fetchSoftSkills(){
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
        }
    }
    
    func updateDatabase(){
        let collection = db.collection("Users")
        
        // Query for documents where the userId field matches the specified value
        collection.whereField("userId", isEqualTo: userId!).getDocuments { snapshot, error in
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
                    
                    // If the userId matches, update softSkillsArray
                    if let userId = data["userId"] as? String, userId == userId {
                        // Document reference for updating
                        let documentRef = self.db.collection("Users").document(document.documentID)
                        
                        // Update the softSkills array
                        documentRef.updateData([
                            "softSkills" : self.softSkills
                        ]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated!")
                                self.showSuccessAlert()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Success",
                                      message: "Skill is added sucessfully!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Trigger the segue
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
