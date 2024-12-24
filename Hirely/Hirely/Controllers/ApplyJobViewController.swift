//
//  ApplyJobViewController.swift
//  Hirely
//
//  Created by BP-36-201-01 on 24/12/2024.
//

import UIKit
import UniformTypeIdentifiers
import FirebaseFirestore

class ApplyJobViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var fullNametxt: UITextField!
    @IBOutlet weak var agetxt: UITextField!
    @IBOutlet weak var phoneNumbertxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var uploadCVbtn: UIButton!
    @IBOutlet weak var uploadCoverLetterbtn: UIButton!
    @IBOutlet weak var applybtn: UIButton!

    var fetchedCVURL: String? // Stores the fetched CV URL from Hirely
    var selectedCVURL: String? // Stores the selected CV file URL
    var selectedCoverLetterURL: String? // Stores the selected Cover Letter file URL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add actions to buttons
        uploadCVbtn.addTarget(self, action: #selector(uploadCVTapped), for: .touchUpInside)
        uploadCoverLetterbtn.addTarget(self, action: #selector(uploadCoverLetterTapped), for: .touchUpInside)
        applybtn.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)

        // Add input validation targets
        phoneNumbertxt.addTarget(self, action: #selector(validatePhoneNumber), for: .editingChanged)
        print("View did load: Button actions and field validations added.") // Debug log
    }

    @objc func uploadCVTapped() {
        // Show options for CV
        let alert = UIAlertController(title: "Upload CV", message: "Choose an option to upload your CV.", preferredStyle: .actionSheet)
        
        // Option 1: Upload from Device
        alert.addAction(UIAlertAction(title: "Upload from Device", style: .default, handler: { _ in
            self.presentDocumentPicker(for: self.uploadCVbtn)
        }))
        
        // Option 2: Fetch from Hirely
        alert.addAction(UIAlertAction(title: "Fetch from Hirely", style: .default, handler: { _ in
            self.fetchFirstCVAndDisplay()
        }))
        
        // Cancel Option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present the action sheet
        present(alert, animated: true, completion: nil)
    }

    @objc func uploadCoverLetterTapped() {
        // Open document picker for Cover Letter
        presentDocumentPicker(for: uploadCoverLetterbtn)
    }

    @objc func applyButtonTapped() {
        // Validate input fields
        guard let fullName = fullNametxt.text, !fullName.isEmpty else {
            showAlert(title: "Error", message: "Please enter your full name.")
            return
        }
        
        guard let age = agetxt.text, !age.isEmpty else {
            showAlert(title: "Error", message: "Please enter your age.")
            return
        }

        guard let phoneNumber = phoneNumbertxt.text, !phoneNumber.isEmpty, isValidPhoneNumber(phoneNumber) else {
            showAlert(title: "Error", message: "Please enter a valid phone number (8 digits).")
            return
        }

        guard let email = emailtxt.text, !email.isEmpty, isValidEmail(email) else {
            showAlert(title: "Error", message: "Please enter a valid email address.")
            return
        }
        
        // Ensure a valid CV is uploaded (fetched or selected)
        let cvLink = fetchedCVURL ?? selectedCVURL
        guard let validCVLink = cvLink, !validCVLink.isEmpty else {
            showAlert(title: "Error", message: "Please upload your CV. It is mandatory.")
            return
        }

        // Prepare data to save in Firestore
        let applicationData: [String: Any] = [
            "fullName": fullName,
            "age": Int(age) ?? 0,
            "phoneNumber": phoneNumber,
            "email": email,
            "cvLink": validCVLink, // Save the CV link
            "coverLetterLink": selectedCoverLetterURL ?? "", // Save the Cover Letter link or an empty string
            "applicationDate": Timestamp(date: Date()) // Add the current date and time
        ]
        
        saveApplicationData(data: applicationData)
    }

    func saveApplicationData(data: [String: Any]) {
        let db = Firestore.firestore()
        db.collection("jobsApplied").addDocument(data: data) { error in
            if let error = error {
                print("Error saving application: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to submit your application. Please try again.")
            } else {
                print("Application submitted successfully!")
                self.showAlert(title: "Success", message: "Your application has been submitted.")
                self.clearForm()
            }
        }
    }

    @objc func validatePhoneNumber() {
        guard let phoneNumber = phoneNumbertxt.text else { return }
        // Restrict phone number to 8 digits
        if phoneNumber.count > 8 {
            phoneNumbertxt.text = String(phoneNumber.prefix(8))
        }
    }

    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // Check if the phone number contains exactly 8 digits
        let phoneRegex = "^[0-9]{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }

    func isValidEmail(_ email: String) -> Bool {
        // Check if the email contains "@" and a basic valid format
        return email.contains("@")
    }

    func presentDocumentPicker(for button: UIButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.accessibilityHint = button == uploadCVbtn ? "CV" : "Cover Letter"
        present(documentPicker, animated: true, completion: nil)
    }

    // MARK: - UIDocumentPickerDelegate Methods
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileTypeHint = controller.accessibilityHint,
              let selectedFileURL = urls.first else { return }
        
        let selectedFilePath = selectedFileURL.absoluteString
        DispatchQueue.main.async {
            if fileTypeHint == "CV" {
                self.selectedCVURL = selectedFilePath
                self.uploadCVbtn.setTitle("Selected: \(selectedFileURL.lastPathComponent)", for: .normal)
            } else if fileTypeHint == "Cover Letter" {
                self.selectedCoverLetterURL = selectedFilePath
                self.uploadCoverLetterbtn.setTitle("Selected: \(selectedFileURL.lastPathComponent)", for: .normal)
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }

    func fetchFirstCVAndDisplay() {
        let db = Firestore.firestore()
        db.collection("CVs").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching CVs: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.uploadCVbtn.setTitle("Upload Failed", for: .normal)
                }
                return
            }
            
            self.fetchedCVURL = nil // Clear any existing CV URL
            
            if let document = snapshot?.documents.first {
                let data = document.data()
                if let cvURL = data["cvUrl"] as? String {
                    self.fetchedCVURL = cvURL
                    DispatchQueue.main.async {
                        self.uploadCVbtn.setTitle("File Uploaded", for: .normal)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.uploadCVbtn.setTitle("No CV Found", for: .normal)
                }
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    func clearForm() {
        fullNametxt.text = ""
        agetxt.text = ""
        phoneNumbertxt.text = ""
        emailtxt.text = ""
        uploadCVbtn.setTitle("Upload CV", for: .normal)
        uploadCoverLetterbtn.setTitle("Upload Cover Letter", for: .normal)
        fetchedCVURL = nil
        selectedCVURL = nil
        selectedCoverLetterURL = nil
    }
}
