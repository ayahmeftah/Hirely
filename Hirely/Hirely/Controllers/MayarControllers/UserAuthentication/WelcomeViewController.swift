//
//  WelcomeViewController.swift
//  Hirely
//
//  Created by BP-36-208-05 on 28/12/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let defaults = UserDefaults.standard
//        
//        if defaults.bool(forKey: "isUserLoggedIn") {
//            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "applicantProfile") as! UINavigationController
//            //viewController.modalTransitionStyle = .crossDissolve
//            viewController.modalPresentationStyle = .overFullScreen
//            self.present(viewController, animated: false, completion: nil)
//        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "fromWelcomeToLogin", sender: sender)
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "fromWelcomeToSignUp", sender: sender)
    }
    
    
}
