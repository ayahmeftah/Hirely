//
//  SignUpViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 08/12/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    //Database reference
    let db = Firestore.firestore()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .newPassword
        confirmPasswordTextField.textContentType = .newPassword
    }
    
    func getCurrentUserId() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            print("No user is signed in.")
            return nil
        }
    }
    
    //Validate text fields, if everything is fine, return nil. Otherwise, return error message
    func validateFields() -> String?{
        
        //check if fields are empty
        if (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return "All fields are required, Please make sure to fill all the fields"
        }
        
        //Check if email format is correct
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (isValidEmail(cleanedEmail) == false){
            return "Please make sure you entered your email in an appropriate format."
        }
        
        //Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(isPasswordValid(cleanedPassword) == false){
            return "Please make sure your password is at least 10 characters, contains a special character and a number"
        }
        
        //Check if confirm password value equals the password value
        if (confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return "Passwords do not match. Please try again"
        }
        
        return nil
    }
    
    
    //Validate the entered email format using a regular expression
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    //Validate the entered password format using a regular expression
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    //Function for preseting error alert
    func showErrorAlert(_ errorMessage: String){
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Function for presenting success alert
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Success",
                                      message: "You have Signed Up Successfully!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Trigger the segue
            self.performSegue(withIdentifier: "goToRegisterDetails", sender: self)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: sender)
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        //Check if value returned by validateFields
        let error = validateFields()
        
        if error != nil{ //if the value of error is not nil, it means there was an error, display alert
            showErrorAlert(error!)
        }
        else{ //In case everything is valid, create user, show success alet then navigate to Register Details
            Auth.auth().createUser(withEmail: email, password: password) { (results, err) in
                
                if err != nil{
                    self.showErrorAlert("Something went wrong, try again.")
                    print(err!.localizedDescription)
                }
                else{
                    let usersCollection = self.db.collection("Users")
                    
                    let newDocRef = usersCollection.document()
                    
                    let docId = newDocRef.documentID
                    let userId = self.getCurrentUserId()
                    let currentDate = Date()
                    let currentTimestamp = Timestamp(date: currentDate)
                    
                    let data: [String: Any] = [
                        "docId": docId,
                        "userId": userId!,
                        "email" : self.emailTextField.text!,
                        "password" : self.passwordTextField.text!,
                        "firstName" : "",
                        "lastName" : "",
                        "gender" : "",
                        "dateOfBirth" : currentTimestamp,
                        "phoneNumber" : "",
                        "city" : "",
                        "profilePhoto" : "https://res.cloudinary.com/drkt3vace/image/upload/v1735392629/twpxlpisathxefjmexoy.jpg",
                        "interests" : [],
                        "expertise" : [],
                        "experienceLevel": "",
                        "minimumExpectedSalary" : 0,
                        "maximumExpectedSalary" : 0,
                        "softSkills" : [],
                        "technicalSkills": [],
                        "experience": [],
                        "appliedJobs": [],
                        "jobsBookmark": [],
                        "resourcesBookmark" : [],
                        "cvs" : [],
                        "isApplicant" : true,
                        "isAdmin" : false,
                        "isEmployer" : false
                    ]
                    
                    newDocRef.setData(data){ error in
                        if let error = error{
                            print(error)
                        }
                        else{
                            print("success")
                        }
                    }
                    
                    self.showSuccessAlert()
                }
            }
        }
    }
}
