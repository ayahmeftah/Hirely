//
//  educationViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class educationViewController: UITableViewController, UITextViewDelegate {
    
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
        setupDatePickerForGraduationYear()

    }
    private func setupDatePickerForGraduationYear() {
            // Create the date picker
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels

            // Set a maximum date to today's date (Optional)
            datePicker.maximumDate = Date()

            // Add a target to update the text field when the value changes
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

            // Assign the date picker to the graduationYearTextField
            graduationYearTextField.inputView = datePicker

            // Add a toolbar with a Done button
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickingDate))
            toolbar.setItems([doneButton], animated: true)
            graduationYearTextField.inputAccessoryView = toolbar
        }

    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Validate input fields
        guard let degree = degreeTextField.text, !degree.isEmpty,
              let major = majorTextField.text, !major.isEmpty,
              let institution = institutionTextField.text, !institution.isEmpty,
              let graduationYear = graduationYearTextField.text, !graduationYear.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill out all fields before proceeding.")
            return
        }

        // Ensure graduation year is numeric
        if Int(graduationYear) == nil {
            showAlert(title: "Invalid Graduation Year", message: "Please enter a valid numeric graduation year.")
            return
        }

        print("Next button tapped") // Debug log

        // Initialize cvData if nil
        if cvData == nil {
            cvData = CVData()
        }

        // Create and add the education entry to cvData
        let newEducation = CVData.Education(
            degree: degree,
            institution: "\(major) - \(institution)", // Combine major and institution
            year: graduationYear
        )
        cvData?.education.append(newEducation)

        // Debug: Print updated cvData
        print("Updated CV Data: \(String(describing: cvData))")

        // Trigger the segue
        performSegue(withIdentifier: "toCertificationsScreen", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCertificationsScreen" {
                if let destinationVC = segue.destination as? certiViewController {
                    // Initialize cvData if nil
                    if cvData == nil {
                        cvData = CVData()
                    }

                    // Add education to cvData
                    let education = CVData.Education(
                        degree: degreeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                        institution: "\(majorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") - \(institutionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")",
                        year: graduationYearTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    )
                    cvData?.education.append(education)

                    // Pass the updated cvData
                    destinationVC.cvData = self.cvData
                    print("Passing CV Data to certiViewController: \(String(describing: cvData))")
                }
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
    
    // MARK: - Date Picker Handlers
        @objc func dateChanged(_ sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/yyyy" // Show month and year only
            graduationYearTextField.text = formatter.string(from: sender.date)
        }

        @objc func donePickingDate() {
            // Dismiss the date picker
            graduationYearTextField.resignFirstResponder()
        }

        
}

