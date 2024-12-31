//
//  changePassword2ViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 29/12/2024.
//

import UIKit
import FirebaseAuth

class changePassword2ViewController: UIViewController {
    
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    var currentPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func chnageBtnClicked(_ sender: UIButton) {
        
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmNewPasswordTextField.text, !confirmPassword.isEmpty else {
            self.showErrorAlert("All fields are required.")
            return
        }
        
        // Check if the new password and confirm password match
        if newPassword != confirmPassword {
            self.showErrorAlert("New password and confirm password do not match.")
            return
        }
        
        // Get the currently signed-in user
        guard let user = Auth.auth().currentUser else {
            self.showErrorAlert("No user is signed in.")
            return
        }
        
        // Reauthenticate the user before updating the password
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: self.currentPassword!)
        
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                self.showErrorAlert("Reauthentication failed: \(error.localizedDescription)")
            } else {
                // Update the user's password
                user.updatePassword(to: newPassword) { error in
                    if let error = error {
                        self.showErrorAlert("Password update failed: \(error.localizedDescription). Please try again.")
                    } else {
                        self.showSuccessAlert()
                    }
                }
            }
        }
    }
    
    //Function for preseting error alert
    func showErrorAlert(_ errorMessage: String){
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Success",
                                      message: "Your password has been successfully updated.",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Trigger the segue
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
