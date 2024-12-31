//
//  LoginViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 08/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let db = Firestore.firestore()
    let userId = currentUser().getCurrentUserId()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isApplicant = false
    var isEmployer = false
    var isAdmin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: sender)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let error = validateFields()
        
        if error != nil {
            self.showErrorAlert(error!)
        }
        else{
            Auth.auth().signIn(withEmail: email, password: password) { (results, err) in
                if err != nil{
                    self.showErrorAlert("Incorrect email or password, plese try again")
                }
                else{
                    self.showSuccessAlert()
                    // Assume login is successful
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    
                    // Navigate to Main Screen
//                    let mainStoryboard = UIStoryboard(name: "ApplicantProfile", bundle: nil)
//                    let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "applicantProfile")
//                    
//                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                       let window = windowScene.windows.first {
//                        window.rootViewController = mainVC
//                        window.makeKeyAndVisible()
//                    }
                }
            }
        }
    }
    
    func validateFields() -> String?{
        if (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return "All fields are required, Please make sure to fill all the fields"
        }
        return nil
    }
    
    func showErrorAlert(_ errorMessage: String){
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Success",
                                      message: "You have logged in successfully!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Fetch user role before performing any segue
            self.checkUserRole { isApplicant, isEmployer, isAdmin in
                if isApplicant {
                    self.performSegue(withIdentifier: "goToApplicantDashboard", sender: self)
                } 
//                else if isEmployer {
//                    self.performSegue(withIdentifier: "", sender: self)
//                } else if isAdmin {
//                    self.performSegue(withIdentifier: "", sender: self)
//                } 
                else {
                    // Handle unexpected case
                    self.showErrorAlert("No valid role found.")
                }
            }
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkUserRole(completion: @escaping (Bool, Bool, Bool) -> Void) {
        let collection = db.collection("Users")
        
        collection.whereField("userId", isEqualTo: userId!).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
                completion(false, false, false) // Return default values on error
                return
            }
            
            var isApplicant = false
            var isEmployer = false
            var isAdmin = false
            
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    
                    if let applicant = data["isApplicant"] as? Bool, applicant {
                        isApplicant = true
                    }
                    
                    if let employer = data["isEmployer"] as? Bool, employer {
                        isEmployer = true
                    }
                    
                    if let admin = data["isAdmin"] as? Bool, admin {
                        isAdmin = true
                    }
                }
            }
            
            // Call completion handler with fetched values
            completion(isApplicant, isEmployer, isAdmin)
        }
    }
    
//    func checkUserRole(){
//        let collection = db.collection("Users")
//        
//        collection.whereField("userId", isEqualTo: userId!).getDocuments { snapshot, error in
//            if let error = error{
//                print("Error getting document: \(error)")
//                return
//            }
//            
//            if let snapshot = snapshot{
//                for doc in snapshot.documents{
//                    let data = doc.data()
//                    
//                    if let userId = data["userId"] as? String, userId == self.userId{
//                        if let applicant = data["isApplicant"]{
//                            if applicant as! Bool == true{
//                                self.isApplicant = true
//                            }
//                        }
//                        
//                        if let employer = data["isEmployer"]{
//                            if employer as! Bool == true{
//                                self.isEmployer = true
//                            }
//                        }
//                        
//                        if let admin = data["isAdmin"]{
//                            if admin as! Bool == true{
//                                self.isAdmin = true
//                            }
//                        }
//                        
//                    }
//                }
//            }
//        }
//    }
}