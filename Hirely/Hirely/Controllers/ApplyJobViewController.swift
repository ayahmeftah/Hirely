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

    var cv: [CVs] = [] // Array to store CVs

    override func viewDidLoad() {
        super.viewDidLoad()
        uploadCVbtn.addTarget(self, action: #selector(uploadCVTapped), for: .touchUpInside)
    }

    @objc func uploadCVTapped() {
        // Show options to the user
        let alert = UIAlertController(title: "Upload CV", message: "Choose an option to upload your CV.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Upload from Device", style: .default, handler: { _ in
            self.presentDocumentPicker()
        }))
        
        alert.addAction(UIAlertAction(title: "Fetch from Hirely", style: .default, handler: { _ in
            self.fetchFirstCVAndDisplay()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }

    func presentDocumentPicker() {
        // Create a document picker for PDFs
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    func fetchFirstCVAndDisplay() {
        let db = Firestore.firestore()
        
        // Fetch all CVs and select the first one
        db.collection("CVs").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching CVs: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.uploadCVbtn.setTitle("Upload Failed", for: .normal)
                }
                return
            }
            
            self.cv.removeAll() // Clear the array to prevent appending duplicate data
            
            for document in snapshot?.documents ?? [] {
                let data = document.data()
                let cvItem = CVs(data: data)
                self.cv.append(cvItem)
            }
            
            // Use the first CV if available
            if let firstCV = self.cv.first {
                print("Fetched First CV: \(firstCV.cvUrl)")
                DispatchQueue.main.async {
                    self.uploadCVbtn.setTitle("File Uploaded", for: .normal)
                }
            } else {
                DispatchQueue.main.async {
                    self.uploadCVbtn.setTitle("No CV Found", for: .normal)
                }
            }
        }
    }

    // MARK: - UIDocumentPickerDelegate Methods
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Optionally handle cancellation (e.g., reset button title)
            DispatchQueue.main.async {
                self.uploadCVbtn.setTitle("Upload CV", for: .normal)
            }
            print("Document picker was cancelled")
        }

}
