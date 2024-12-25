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

    @IBOutlet weak var companyLogoimg: UIImageView!
    @IBOutlet weak var positionlbl: UILabel!
    @IBOutlet weak var companyNamelbl: UILabel!

    @IBOutlet weak var fullNametxt: UITextField!
    @IBOutlet weak var agetxt: UITextField!
    @IBOutlet weak var phoneNumbertxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var uploadCVbtn: UIButton!
    @IBOutlet weak var applybtn: UIButton!

    var fetchedCVURL: String? // Stores the fetched CV URL from Hirely
    var selectedCVURL: String? // Stores the selected CV file URL
    var jobPosting: JobPosting? // Holds the fetched job posting data
    var companyDetails: CompanyDetails? // Holds the fetched company details

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add actions to buttons
        uploadCVbtn.addTarget(self, action: #selector(uploadCVTapped), for: .touchUpInside)
        applybtn.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)

        // Add input validation for phone number
        phoneNumbertxt.addTarget(self, action: #selector(validatePhoneNumber), for: .editingChanged)

        // Fetch job posting and company details data
        fetchJobPostingData()
        fetchCompanyDetails(companyId: "RYINaYeqoq6WXBkdCOoK")
    }

    // Fetch job posting data from Firestore
    func fetchJobPostingData() {
        let db = Firestore.firestore()
        let jobId = "6zdg3JhufgPeqIoQgiPH" // Replace with the actual job document ID

        db.collection("jobPostings").document(jobId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching job posting: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.jobPosting = JobPosting(data: data)
                print("Fetched Job Posting: \(self.jobPosting!)") // Debug log

                self.updateUIWithJobPosting()
            }
        }
    }

    // Fetch company details from Firestore using the fixed company ID
    func fetchCompanyDetails(companyId: String) {
        let db = Firestore.firestore()
        db.collection("companies").document(companyId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching company details: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.companyDetails = CompanyDetails(data: data)
                print("Fetched Company Details: \(self.companyDetails!)") // Debug log
                self.updateUIWithCompanyDetails()
            } else {
                print("No company data found for ID: \(companyId)")
            }
        }
    }

    // Update the UI with the fetched job posting data
    func updateUIWithJobPosting() {
        guard let jobPosting = self.jobPosting else { return }

        DispatchQueue.main.async {
            self.positionlbl.text = jobPosting.jobTitle
        }
    }

    // Update the UI with the fetched company details
    func updateUIWithCompanyDetails() {
        guard let companyDetails = self.companyDetails else { return }

        DispatchQueue.main.async {
            self.companyNamelbl.text = companyDetails.name
        }
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
        documentPicker.accessibilityHint = "CV"
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
        fetchedCVURL = nil
        selectedCVURL = nil
    }
}
