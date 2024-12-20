//
//  expViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class expViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    var cvData: CVData? // Property to hold the data passed from PersonalInfoViewController, SkillsViewController

    // MARK: - Outlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
   @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var descTextField: UITextView!
    var activeTextField: UITextField?


 //  @IBOutlet weak var descriptionTextField: UITextView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Debug: Verify cvData
               print("Received CV Data: \(String(describing: cvData))")
        setupUI()
        fromDateTextField.delegate = self
        toDateTextField.delegate = self
        
        descTextField.text = "Write a short desciption ..."
        descTextField.textColor = .lightGray
        descTextField.delegate = self
        
        // Set up the date pickers for both text fields
        setupDatePicker(for: fromDateTextField)
        setupDatePicker(for: toDateTextField)

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
            duration: "\(fromDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") - \(toDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")",
            description: descTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "Write a short description..." ? "" : descTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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

                    // Explicitly initialize cvData if nil
                    let experience = CVData.JobExperience(
                        title: jobTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                        company: companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                        duration: "\(fromDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") - \(toDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")",
                        description: descTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "Write a short description..." ? "" : descTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    )

                    cvData?.experience.append(experience)

                    // Pass the updated cvData
                    destinationVC.cvData = self.cvData
                    print("Passing CV Data to educationViewController: \(String(describing: cvData))")
                }
            }
    }



    private func addExperienceToCVData() {
        let jobTitle = jobTitleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let company = companyTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let fromDate = fromDateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let toDate = toDateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let jobDescription = descTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        let duration = "\(fromDate) - \(toDate)"
        let newExperience = CVData.JobExperience(
            title: jobTitle,
            company: company,
            duration: duration,
            description: jobDescription == "Write a short description..." ? "" : jobDescription
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
    
    func setupDatePicker(for textField: UITextField) {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

            // Assign the date picker as the input view
            textField.inputView = datePicker

            // Add a toolbar with a Done button
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickingDate))
            toolbar.setItems([doneButton], animated: true)
            toolbar.isUserInteractionEnabled = true
            textField.inputAccessoryView = toolbar
        }

        // MARK: - Date Picker Handlers
        @objc func dateChanged(_ sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none

            // Update the active text field
            activeTextField?.text = formatter.string(from: sender.date)
        }

        @objc func donePickingDate() {
            // Dismiss the date picker
            activeTextField?.resignFirstResponder()
        }

        // Track the active text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField

        // Update the date picker if there's an existing value
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        if let text = textField.text, let date = formatter.date(from: text) {
            let datePicker = textField.inputView as? UIDatePicker
            datePicker?.date = date
        }
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Remove placeholder text when editing begins
        if textView == descTextField && textView.text == "Write a short description..." {
            textView.text = ""
            textView.textColor = .black // Set to default text color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // Restore placeholder text if the user leaves the field empty
        if textView == descTextField && textView.text.isEmpty {
            textView.text = "Write a short description..."
            textView.textColor = .lightGray
        }
    }
    private func validateInputFields() -> Bool {
        let jobTitle = jobTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let company = companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let fromDate = fromDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let toDate = toDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let jobDescription = descTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if jobTitle.isEmpty || company.isEmpty || fromDate.isEmpty || toDate.isEmpty || jobDescription.isEmpty || jobDescription == "Write a short description..." {
            showAlert(title: "Missing Information", message: "Please fill out all fields before proceeding.")
            return false
        }
        return true
    }



}

