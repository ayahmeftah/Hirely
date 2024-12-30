//
//  LoginViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 08/12/2024.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
                                      message: "You have Loged in Successfully!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Trigger the segue
            self.performSegue(withIdentifier: "goToProfile", sender: self)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
