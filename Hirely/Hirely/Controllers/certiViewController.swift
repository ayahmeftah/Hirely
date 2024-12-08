//
//  certiViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class certiViewController: UIViewController {

    // MARK: - Properties
    var cvData: CVData? // Property to hold the data passed from previous screens

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
        // Ensure text fields are cleared or pre-populated (if needed)
        [cert1NameTextField, cert1IssuedByTextField,
         cert2NameTextField, cert2IssuedByTextField,
         cert3NameTextField, cert3IssuedByTextField].forEach { $0?.text = "" }
    }

    // MARK: - Actions
    @IBAction func generateButtonTapped(_ sender: Any) {
        print("Generate button tapped.") // Debugging message

        // Initialize cvData if nil
        if cvData == nil {
            cvData = CVData()
        }

        
        
        
        
        
        // Validate and add certifications
        addCertification(from: cert1NameTextField, issuedBy: cert1IssuedByTextField)
        addCertification(from: cert2NameTextField, issuedBy: cert2IssuedByTextField)
        addCertification(from: cert3NameTextField, issuedBy: cert3IssuedByTextField)

        // Ensure at least one certification has been added
        guard let certifications = cvData?.certifications, !certifications.isEmpty else {
            showAlert(title: "Missing Certifications", message: "Please enter at least one certification before generating the CV.")
            return
        }

        // Debugging: Log updated certifications
        print("Updated Certifications: \(certifications)")

        // Navigate to the next screen
        performSegue(withIdentifier: "toGeneratedCVScreen", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGeneratedCVScreen",
           let destinationVC = segue.destination as? generatedCvViewController {
            destinationVC.cvData = self.cvData // Pass the updated cvData
            print("Passing CV Data to GeneratedCVViewController: \(String(describing: self.cvData))")
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
}

