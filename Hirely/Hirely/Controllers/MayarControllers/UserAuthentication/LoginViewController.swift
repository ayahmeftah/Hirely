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
    var userId: String? = nil
    
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
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (results, err) in
                guard let self = self else { return }
                
                if err != nil {
                    self.showErrorAlert("Incorrect email or password, please try again")
                } else {
                    // Update userId and fetch role
                    self.userId = results?.user.uid
                    
                    self.checkUserRole {
                        // Once roles are determined, show success alert
                        DispatchQueue.main.async {
                            self.showSuccessAlert()
                        }
                    }
                    
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
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
            
            if self.isApplicant == true{
                self.performSegue(withIdentifier: "goToApplicantDashboard", sender: self)
            }
            else if self.isAdmin == true{
                self.performSegue(withIdentifier: "goToAdminDashboard", sender: self)
            }
            else if self.isEmployer == true{
                self.performSegue(withIdentifier: "goToEmployerDashboard", sender: self)
            }
            else{
                self.showErrorAlert("No valid role found.")
            }
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkUserRole(completion: @escaping () -> Void) {
        guard let userId = self.userId else {
            print("User ID is nil")
            completion() // Exit early if userId is nil
            return
        }
        
        let collection = db.collection("Users")
        
        collection.whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
                completion() // Return early on error
                return
            }
            
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    
                    if let userId = data["userId"] as? String, userId == self.userId {
                        self.isApplicant = data["isApplicant"] as? Bool ?? false
                        self.isEmployer = data["isEmployer"] as? Bool ?? false
                        self.isAdmin = data["isAdmin"] as? Bool ?? false
                    }
                }
            }
            completion() // Notify that role checking is complete
        }
    }
}
