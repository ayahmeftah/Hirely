//
//  expViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class expViewController: UIViewController {
    
    // MARK: - Properties
    var cvData: CVData? // Property to hold the data passed from PersonalInfoViewController, SkillsViewController

    // MARK: - Outlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        // Placeholder setup or any additional UI configuration if needed
    }

    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Validate input and update experience
        guard validateInputFields() else {
            return
        }
        
        // Initialize cvData if nil
        if cvData == nil {
            cvData = CVData()
        }
        
        // Update the experience section of cvData
        addExperienceToCVData()

        // Perform segue to the next screen
        performSegue(withIdentifier: "toEducationScreen", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEducationScreen",
           let destinationVC = segue.destination as? educationViewController {
            destinationVC.cvData = self.cvData // Pass the updated cvData
            print("Passing CV Data to EducationViewController: \(String(describing: cvData))")
        }
    }

    // MARK: - Helper Methods
    private func validateInputFields() -> Bool {
        let jobTitle = jobTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let company = companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let fromDate = fromDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let toDate = toDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let jobDescription = descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if jobTitle.isEmpty || company.isEmpty || fromDate.isEmpty || toDate.isEmpty || jobDescription.isEmpty {
            showAlert(title: "Missing Information", message: "Please fill out all fields before proceeding.")
            return false
        }
        return true
    }

    private func addExperienceToCVData() {
        let jobTitle = jobTitleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let company = companyTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let fromDate = fromDateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let toDate = toDateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let jobDescription = descriptionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        let duration = "\(fromDate) - \(toDate)"
        let newExperience = CVData.JobExperience(
            title: jobTitle,
            company: company,
            duration: duration
        )

        cvData?.experience.append(newExperience)

        // Debugging: Log new experience and updated CV data
        print("New Experience Added: \(newExperience)")
        print("Updated CV Data (Experience): \(String(describing: cvData?.experience))")
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

