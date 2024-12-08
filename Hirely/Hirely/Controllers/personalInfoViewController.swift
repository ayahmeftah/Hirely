//
//  personalInfoViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class personalInfoViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    var cvData: CVData? // CVData object to pass data between screens
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var professionalSummaryTextView: UITextView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set placeholder for Professional Summary TextView
        professionalSummaryTextView.text = "Write a short professional summary..."
        professionalSummaryTextView.textColor = .lightGray
        professionalSummaryTextView.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Validate input fields
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill out all fields before proceeding.")
            return
        }
        
        // Initialize cvData if nil
        if cvData == nil {
            cvData = CVData()
        }
        
        // Update CVData with personal info
        cvData?.personalInfo = CVData.PersonalInfo(
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            professionalSummary: professionalSummaryTextView.text == "Write a short professional summary..." ? "" : professionalSummaryTextView.text
        )
        
        // Debug: Print updated cvData
        print("Updated CV Data (Personal Info): \(String(describing: cvData?.personalInfo))")
        
        // Navigate to the Skills Screen
        performSegue(withIdentifier: "toSkillsScreen", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSkillsScreen", // Match the segue identifier
           let destinationVC = segue.destination as? skillsViewController { // Cast to SkillsViewController
            destinationVC.cvData = self.cvData // Pass the cvData object
            print("Passing CV Data to SkillsViewController: \(String(describing: cvData))")
        }
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Remove placeholder text when editing begins
        if textView.text == "Write a short professional summary..." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Add placeholder text if the user leaves the field empty
        if textView.text.isEmpty {
            textView.text = "Write a short professional summary..."
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
