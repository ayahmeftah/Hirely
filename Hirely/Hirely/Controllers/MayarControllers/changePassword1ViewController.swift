//
//  changePassword1ViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 29/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class changePassword1ViewController: UIViewController {

    let userId = currentUser().getCurrentUserId()
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        
        if currentPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            showErrorAlert("Please provide your current password")
        }
            
        let currentUser = Auth.auth().currentUser
        let currentPasswordInput = currentPasswordTextField.text!
        
        let credential = EmailAuthProvider.credential(withEmail: currentUser!.email ?? "", password: currentPasswordInput)
        currentUser!.reauthenticate(with: credential) { _, error in
            if let error = error {
                self.showErrorAlert("\(error)")
                //print("Reauthentication failed: \(error.localizedDescription)")
            } else {
                print("Reauthentication successful.")
                self.performSegue(withIdentifier: "goToSetNewPassword", sender: sender)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSetNewPassword"{
            if let destinationVC = segue.destination as? changePassword2ViewController{
                destinationVC.currentPassword = currentPasswordTextField.text!
            }
        }
    }
}
