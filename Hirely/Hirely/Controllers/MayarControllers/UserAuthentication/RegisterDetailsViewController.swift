//
//  RegisterDetailsViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 08/12/2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class RegisterDetailsViewController: UIViewController{
    
    let db = Firestore.firestore()
    let user = currentUser()
    
    @IBOutlet weak var selectGenderBtn: UIButton!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    
    
    var pickerData =  ["Manama", "Muharraq", "Isa Town", "Riffa", "Sitra",
                       "Hamad Town", "Budaiya", "Jidhafs", "A'ali", "Sanabis",
                       "Zallaq", "Amwaj Islands", "Duraz", "Tubli", "Seef",
                       "Hoora", "Adliya", "Juffair", "Salmaniya", "Diyar Al Muharraq"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.text = formatDate(date: Date())
        
        pickerView.delegate = self
        pickerView.dataSource = self
        cityTextField.inputView = pickerView
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        dateOfBirthTextField.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    
    @IBAction func optionSelction(_ sender: UIAction){
        print(sender.title)
        self.selectGenderBtn.setTitle(sender.title, for: .normal)
    }
    
    
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        let err = validateFields()
        
        if err != nil{
            showErrorAlert(err!)
        }
        else{
            updateDatabase()
            performSegue(withIdentifier: "goToUploadProfilePhoto", sender: sender)
        }
    }
    
    func updateDatabase(){
        let fName = firstNameTextField.text!
        let lname = lastNameTextField.text!
        let gender = selectGenderBtn.title(for: .normal)
        let dateNotConverted = datePicker.date
        let dateOfBirth = Timestamp(date: dateNotConverted)
        let phoneNumber = phoneNumberTextField.text!
        let city = cityTextField.text!
        
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
                            "firstName": fName,
                            "lastName" : lname,
                            "gender" : gender!,
                            "dateOfBirth" : dateOfBirth,
                            "phoneNumber" : phoneNumber,
                            "city" : city
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
    
    func showErrorAlert(_ errorMessage: String){
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateFields() -> String?{
        if (firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (dateOfBirthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return "All fields are required, Please make sure to fill all the fields"
        }
        
        if (selectGenderBtn.title(for: .normal) == "  Select Gender"){
            return "Please select an option for Gender"
        }
        
        let ageValid = validateAge()
        
        if (ageValid == false){
            return "You must be at least 18 years old to register"
        }
        
        return nil
    }
    
    func validateAge() -> Bool {
        // Get the selected date from the date picker
        let selectedDate = self.datePicker.date
        
        // Calculate the difference between the current date and the selected date
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Ensure the age is calculated based on years
        let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: currentDate)
        if let age = ageComponents.year, age >= 18 {
            // The person is 18 or older
            return true
        } else {
            return false
        }
    }
}

extension RegisterDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
