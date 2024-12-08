//
//  educationViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class educationViewController: UIViewController {
    
    // MARK: - Properties
    var cvData: CVData? // Property to hold the data passed from previous view controllers

    // MARK: - Outlets
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var institutionTextField: UITextField!
    @IBOutlet weak var graduationYearTextField: UITextField!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        // Any additional UI setup can be added here
    }

    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Validate and update education
        guard validateInputFields() else {
            return
        }
        
        // Initialize cvData if nil
        if cvData == nil {
            cvData = CVData()
        }
        
        // Update the education section of cvData
        addEducationToCVData()

        // Perform segue to the next screen
        performSegue(withIdentifier: "toCertificationsScreen", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCertificationsScreen",
           let destinationVC = segue.destination as? certiViewController {
            destinationVC.cvData = self.cvData // Pass the updated cvData
            print("Passing CV Data to CertiViewController: \(String(describing: cvData))")
        }
    }

    // MARK: - Helper Methods
    private func validateInputFields() -> Bool {
        let degree = degreeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let major = majorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let institution = institutionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let graduationYear = graduationYearTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if degree.isEmpty || major.isEmpty || institution.isEmpty || graduationYear.isEmpty {
            showAlert(title: "Missing Information", message: "Please fill out all fields before proceeding.")
            return false
        }

        if Int(graduationYear) == nil {
            showAlert(title: "Invalid Graduation Year", message: "Please enter a valid numeric graduation year.")
            return false
        }

        return true
    }

    private func addEducationToCVData() {
        let degree = degreeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let major = majorTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let institution = institutionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let graduationYear = graduationYearTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        let newEducation = CVData.Education(
            degree: degree,
            institution: "\(major) - \(institution)",
            year: graduationYear
        )

        cvData?.education.append(newEducation)

        // Debugging: Log new education and updated CV data
        print("New Education Added: \(newEducation)")
        print("Updated CV Data (Education): \(String(describing: cvData?.education))")
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

