//
//  EditPersonalInfoViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 24/12/2024.
//

import UIKit
import FirebaseFirestore
import Cloudinary

class EditPersonalInfoViewController: UIViewController {
    
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
    let pickerView = UIPickerView()
    
    var pickerData =  ["Manama", "Muharraq", "Isa Town", "Riffa", "Sitra",
                       "Hamad Town", "Budaiya", "Jidhafs", "A'ali", "Sanabis",
                       "Zallaq", "Amwaj Islands", "Duraz", "Tubli", "Seef",
                       "Hoora", "Adliya", "Juffair", "Salmaniya", "Diyar Al Muharraq"]

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFill()
        genderTextField.isUserInteractionEnabled = false
        dateOfBirthTextField.isUserInteractionEnabled = false
        
        profilePhoto.layer.cornerRadius = profilePhoto.layer.frame.size.width / 2
        profilePhoto.clipsToBounds = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        cityTextField.inputView = pickerView
        cityTextField.resignFirstResponder()
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
    
    func updateDatabase(){
        let fName = firstNameTextField.text!
        let lname = lastNameTextField.text!
        let phoneNumber = phoneNumberTextField.text!
        let city = cityTextField.text!
        
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
                    
                    // If the userId matches, update the firstName field
                    if let userId = data["userId"] as? String, userId == userId {
                        // Document reference for updating
                        let documentRef = self.db.collection("Users").document(document.documentID)
                        
                        // Update the firstName field
                        documentRef.updateData([
                            "firstName": fName,
                            "lastName" : lname,
                            "phoneNumber" : phoneNumber,
                            "city" : city
                        ]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                self.showSuccessAlert()
                                print("Document successfully updated!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Success",
                                      message: "Changes have been saved successfully!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Trigger the segue
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveChangesClicked(_ sender: Any) {
        updateDatabase()
    }
}


extension EditPersonalInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTextField.text = pickerData[row]
        cityTextField.resignFirstResponder()
    }
}
