//
//  PersonalInfoViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 10/12/2024.
//

import UIKit
import FirebaseFirestore
import Cloudinary

class PersonalInfoViewController: UIViewController {
    
    let db = Firestore.firestore()
    let userId = currentUser().getCurrentUserId()
    let cloudinary = CloudinarySetup.cloudinarySetup()
    
    @IBOutlet weak var profilePhoto: CLDUIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePhoto.layer.cornerRadius = profilePhoto.layer.frame.size.width / 2
        profilePhoto.clipsToBounds = true
        
        firstNameTextField.isUserInteractionEnabled = false
        lastNameTextField.isUserInteractionEnabled = false
        genderTextField.isUserInteractionEnabled = false
        dateOfBirthTextField.isUserInteractionEnabled = false
        phoneNumberTextField.isUserInteractionEnabled = false
        cityTextField.isUserInteractionEnabled = false
        fetchFill()
    }
    
    func fetchFill(){
        let collection = db.collection("Users")
        
        collection.whereField("userId", isEqualTo: userId!).getDocuments { snapshot, error in
            if let error = error{
                print("Error getting document: \(error)")
                return
            }
            
            if let snapshot = snapshot{
                for doc in snapshot.documents{
                    let data = doc.data()
                    
                    if let userId = data["userId"] as? String, userId == self.userId{
                        
                        if let profilePhotoLink = data["profilePhoto"] as? String{
                            self.profilePhoto.cldSetImage(profilePhotoLink, cloudinary: self.cloudinary)
                        }
                        
                        if let firstName = data["firstName"] as? String{
                                self.firstNameTextField.text = firstName
                        }
                        
                        if let lastName = data["lastName"] as? String{
                            self.lastNameTextField.text = lastName
                        }
                        
                        if let gender = data["gender"] as? String{
                            self.genderTextField.text = gender
                        }
                        
                        if let dateOfBirth = data["dateOfBirth"] as? Timestamp{
                            self.dateOfBirthTextField.text = self.formatDate(date: dateOfBirth.dateValue())
                        }
                        
                        if let phoneNumber = data["phoneNumber"] as? String{
                            self.phoneNumberTextField.text = phoneNumber
                        }
                        
                        if let city = data["city"] as? String{
                            self.cityTextField.text = city
                        }
                    }
                }
            }
        }
    }
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "goToEditDetails", sender: sender)
    }
}
