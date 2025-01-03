//
//  certiViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class certiViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    // MARK: - Properties
    var cvData: CVData? // Property to hold the data passed from previous screens
    var activeTextField: UITextField?


    // MARK: - Outlets for Certification Fields
    @IBOutlet weak var cert1NameTextField: UITextField!
    @IBOutlet weak var cert1IssuedByTextField: UITextField!
    @IBOutlet weak var cert2NameTextField: UITextField!
    @IBOutlet weak var cert2IssuedByTextField: UITextField!
    @IBOutlet weak var cert3NameTextField: UITextField!
    @IBOutlet weak var cert3IssuedByTextField: UITextField!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup Methods
    private func setupUI() {
           // Clear or pre-populate fields
           [cert1NameTextField, cert1IssuedByTextField,
            cert2NameTextField, cert2IssuedByTextField,
            cert3NameTextField, cert3IssuedByTextField].forEach { $0?.text = "" }
           
           // Set up date pickers for issuedBy fields
           setupDatePicker(for: cert1IssuedByTextField)
//           setupDatePicker(for: cert2IssuedByTextField)
           //setupDatePicker(for: cert3IssuedByTextField)
       }
    private func setupDatePicker(for textField: UITextField) {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels

            // Add target for value change
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

            // Assign date picker as input view
            textField.inputView = datePicker

            // Add a toolbar with a Done button
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickingDate))
            toolbar.setItems([doneButton], animated: true)
            textField.inputAccessoryView = toolbar

            // Set delegate to track active field
            textField.delegate = self
        }

    // MARK: - Actions
    @IBAction func generateButtonTapped(_ sender: Any) {
        print("Generate button tapped.") // Debugging

                // Initialize cvData if nil
                if cvData == nil {
                    cvData = CVData()
                }

                // Create and add the certifications to cvData
                addCertification(from: cert1NameTextField, issuedBy: cert1IssuedByTextField)
                addCertification(from: cert2NameTextField, issuedBy: cert2IssuedByTextField)
                addCertification(from: cert3NameTextField, issuedBy: cert3IssuedByTextField)

                // Ensure at least one certification is added
                guard let certifications = cvData?.certifications, !certifications.isEmpty else {
                    showAlert(title: "Missing Certifications", message: "Please enter at least one certification before generating the CV.")
                    return
                }

                // Debugging: Log updated certifications
                print("Updated Certifications: \(certifications)")

                // Trigger segue to the generated CV screen
                performSegue(withIdentifier: "toGeneratedCVScreen", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue: \(segue.identifier ?? "No identifier")")

                if segue.identifier == "toGeneratedCVScreen" {
                    // Ensure cvData contains updated certifications
                    if cvData == nil {
                        cvData = CVData()
                    }

                    // Create and add the certifications to cvData
                    addCertification(from: cert1NameTextField, issuedBy: cert1IssuedByTextField)
//                    addCertification(from: cert2NameTextField, issuedBy: cert2IssuedByTextField)
                   // addCertification(from: cert3NameTextField, issuedBy: cert3IssuedByTextField)

                    if let destinationVC = segue.destination as? generatedCvViewController {
                        destinationVC.cvData = self.cvData
                        print("Passing CV Data to GeneratedCVViewController: \(String(describing: self.cvData))")
                    } else {
                        print("Destination VC could not be cast to GeneratedCVViewController.")
                    }
                }
    }

    // MARK: - Helper Methods
    /// Adds a certification to the `cvData` if valid.
    private func addCertification(from nameTextField: UITextField, issuedBy issuedByTextField: UITextField) {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty,
              let issuedBy = issuedByTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !issuedBy.isEmpty else {
            return
        }

        let certification = CVData.Certification(name: name, year: issuedBy)
        cvData?.certifications.append(certification)
        print("Certification Added: \(certification)") // Debugging
    }

    /// Displays an alert with a title and message.
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    // MARK: - Date Picker Handlers
        @objc func dateChanged(_ sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/yyyy" // Month and year format

            // Update the active text field with the formatted date
            activeTextField?.text = formatter.string(from: sender.date)
        }

        @objc func donePickingDate() {
            // Dismiss the picker
            activeTextField?.resignFirstResponder()
        }

        // MARK: - UITextFieldDelegate
        func textFieldDidBeginEditing(_ textField: UITextField) {
            // Track the active text field
            activeTextField = textField

            // Update the date picker with the existing value if possible
            if let text = textField.text, let date = DateFormatter().date(from: text) {
                let datePicker = textField.inputView as? UIDatePicker
                datePicker?.date = date
            }
        }
}

