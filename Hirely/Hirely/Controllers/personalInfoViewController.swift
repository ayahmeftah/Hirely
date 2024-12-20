//
//  personalInfoViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class personalInfoViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - Properties
    var cvData: CVData? // CVData object to pass data between screens
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var professionalSummaryTextView: UITextView!
    
    @IBOutlet weak var skillsTextView: UITextView!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set placeholder for Professional Summary TextView
        professionalSummaryTextView.text = "Write a short professional summary..."
        professionalSummaryTextView.textColor = .lightGray
        professionalSummaryTextView.delegate = self
        
        skillsTextView.text = "List your skills here..."
        skillsTextView.textColor = .lightGray
        skillsTextView.delegate = self
    }
    
//    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
//        print("tapped")
//        performSegue(withIdentifier: "toExperienceScreen", sender: self)
//        
//    }

   
    //MARK: - Actions
    @IBAction func nextButtonTapped2(_ sender: Any) {
        // Validate input fields
            guard let name = nameTextField.text, !name.isEmpty,
                  let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty,
                  let email = emailTextField.text, !email.isEmpty else {
                showAlert(title: "Missing Information", message: "Please fill out all fields before proceeding.")
                return
            }

            print("Next button tapped") // Debug log

            // Explicitly initialize cvData
            let personalInfo = CVData.PersonalInfo(
                name: name,
                email: email,
                phoneNumber: phoneNumber,
                professionalSummary: professionalSummaryTextView.text == "Write a short professional summary..." ? "" : professionalSummaryTextView.text,
                skills: skillsTextView.text == "List your skills here..." ? "" : skillsTextView.text

            )
        

            if cvData == nil {
                cvData = CVData()
            }

            // Update CVData with personal info
            cvData?.personalInfo = personalInfo

            // Debug: Print updated cvData
            print("Updated CV Data: \(String(describing: cvData))")

            // Trigger the segue
            performSegue(withIdentifier: "toExperienceScreen", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue: \(segue.identifier ?? "No identifier")")

           if segue.identifier == "toExperienceScreen" {
               if let destinationVC = segue.destination as? expViewController {
                   if cvData == nil {
                       // Create cvData explicitly
                       cvData = CVData()
                       cvData?.personalInfo = CVData.PersonalInfo(
                           name: nameTextField.text ?? "",
                           email: emailTextField.text ?? "",
                           phoneNumber: phoneNumberTextField.text ?? "",
                           professionalSummary: professionalSummaryTextView.text == "Write a short professional summary..." ? "" : professionalSummaryTextView.text,
                           skills: skillsTextView.text == "List your skills here..." ? "" : skillsTextView.text

                       )
                   }
                   destinationVC.cvData = self.cvData
                   print("CV Data passed to expViewController: \(String(describing: cvData))")
               } else {
                   print("Destination VC could not be cast to expViewController")
               }
           }
    }


    
    // MARK: - UITextViewDelegate
       func textViewDidBeginEditing(_ textView: UITextView) {
           // Remove placeholder text when editing begins
           if textView == professionalSummaryTextView && textView.text == "Write a short professional summary..." {
               textView.text = ""
               textView.textColor = .black
           } else if textView == skillsTextView && textView.text == "List your skills here..." {
               textView.text = ""
               textView.textColor = .black
           }
       }
       
       func textViewDidEndEditing(_ textView: UITextView) {
           // Add placeholder text if the user leaves the field empty
           if textView == professionalSummaryTextView && textView.text.isEmpty {
               textView.text = "Write a short professional summary..."
               textView.textColor = .lightGray
           } else if textView == skillsTextView && textView.text.isEmpty {
               textView.text = "List your skills here..."
               textView.textColor = .lightGray
           }
       }
       
       // MARK: - Helper Methods
       private func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
   
    
}
