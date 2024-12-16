//
//  expViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class expViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - Properties
    var cvData: CVData? // Property to hold the data passed from PersonalInfoViewController, SkillsViewController

    // MARK: - Outlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
   @IBOutlet weak var descriptionTextField: UITextField!

 //  @IBOutlet weak var descriptionTextField: UITextView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Debug: Verify cvData
               print("Received CV Data: \(String(describing: cvData))")
        setupUI()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        // Placeholder setup or any additional UI configuration if needed
    }

    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Validate input fields
                guard validateInputFields() else {
                    return
                }

                print("Next button tapped") // Debug log

                // Explicitly initialize cvData if nil
                let experience = CVData.JobExperience(
                    title: jobTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                    company: companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                    duration: "\(fromDateTextField.text ?? "") - \(toDateTextField.text ?? "")"
                )

                if cvData == nil {
                    cvData = CVData()
                }

                // Update cvData with experience
                cvData?.experience.append(experience)

                // Debug: Print updated cvData
                print("Updated CV Data (Experience): \(String(describing: cvData?.experience))")

                // Trigger the segue
                performSegue(withIdentifier: "toEducationScreen", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEducationScreen" {
                if let destinationVC = segue.destination as? educationViewController {
                    // Initialize cvData if nil
                    if cvData == nil {
                        cvData = CVData()
                    }

                    // Add experience to cvData
                    let experience = CVData.JobExperience(
                        title: jobTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                        company: companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                        duration: "\(fromDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") - \(toDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")"
                    )
                    cvData?.experience.append(experience)

                    // Pass the updated cvData
                    destinationVC.cvData = self.cvData
                    print("Passing CV Data to educationViewController: \(String(describing: cvData))")
                }
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

