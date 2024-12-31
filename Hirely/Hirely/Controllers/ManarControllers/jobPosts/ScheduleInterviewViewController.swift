//
//  ScheduleInterviewViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 28/12/2024.
//

import UIKit
import FirebaseFirestore

class ScheduleInterviewViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var locationTextView: UITextView!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    var applicationDocId: String? // This will store the appliedJobs document ID
    
    var applicantId: String!
    var employerId: String!
    var jobId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        timePicker.datePickerMode = .time
    }
    
    @IBAction func saveInterviewDetails(_ sender: UIButton) {
        guard let location = locationTextView.text, !location.isEmpty else {
                    showAlert(title: "Error", message: "Please provide a location.")
                    return
                }
                
                let notes = notesTextView.text ?? ""
                let date = datePicker.date
                let time = timePicker.date
                
                saveInterviewDetailsToFirestore(location: location, notes: notes, date: date, time: time)
            }
            
    private func saveInterviewDetailsToFirestore(location: String, notes: String, date: Date, time: Date) {
        let db = Firestore.firestore()
        let documentRef = db.collection("scheduledInterviews").document() 
        let docId = documentRef.documentID // Get the generated document ID

        let interviewData: [String: Any] = [
            "docId": docId, // Save the document ID
            "applicantId": applicantId ?? "",
            "employerId": "", //change later
            "jobId": jobId ?? "",
            "location": location,
            "notes": notes,
            "date": Timestamp(date: date),
            "time": Timestamp(date: time)
        ]

        documentRef.setData(interviewData) { error in
            if let error = error {
                self.showAlert(title: "Error", message: "Failed to save interview details: \(error.localizedDescription)")
            } else {
                // Update the `scheduledInterviewId` in the appliedJobs collection
                self.updateScheduledInterviewId(docId: docId)
            }
        }
    }

    private func updateScheduledInterviewId(docId: String) {
        guard let applicationDocId = applicationDocId else {
            print("Error: applicationDocId is nil")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("appliedJobs").document(applicationDocId).updateData([
            "scheduledInterviewId": docId,
            "applicationStatus": "Scheduled Interview" // Update status
        ]) { error in
            if let error = error {
                print("Error updating scheduledInterviewId: \(error.localizedDescription)")
            } else {
                print("scheduledInterviewId and status updated successfully.")
                self.showAlert(title: "Success", message: "Interview scheduled and application updated.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }


            private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completion?()
                }))
                present(alert, animated: true)
            }
        }
    

