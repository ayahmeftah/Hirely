//
//  ScheduledInterviewsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit
import FirebaseFirestore

class ScheduledInterviewsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scheduledInterviewTableView: UITableView!
    var interviews: [InterviewDetail] = [] // Store fetched interviews
        var applicantNames: [String: String] = [:] // Maps applicantId to fullName

        override func viewDidLoad() {
            super.viewDidLoad()
            let nib = UINib.init(nibName: "ScheduledInterviewsTableViewCell", bundle: nil)
            scheduledInterviewTableView.register(nib, forCellReuseIdentifier: "Interview")
            scheduledInterviewTableView.backgroundColor = .clear
            fetchScheduledInterviews()
        }
        
        // Fetch all scheduled interviews
        private func fetchScheduledInterviews() {
            let db = Firestore.firestore()
            db.collection("scheduledInterviews").getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching interviews: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                
                let group = DispatchGroup()
                var interviews: [InterviewDetail] = []

                for doc in documents {
                    var data = doc.data()
                    data["docId"] = doc.documentID
                    let interview = InterviewDetail(data: data)
                    interviews.append(interview)

                    group.enter()
                    db.collection("appliedJobs")
                        .whereField("userId", isEqualTo: interview.applicantId)
                        .getDocuments { snapshot, error in
                            if let error = error {
                                print("Error fetching applicant name: \(error.localizedDescription)")
                            } else if let snapshot = snapshot, let document = snapshot.documents.first {
                                if let name = document.data()["fullName"] as? String {
                                    self?.applicantNames[interview.applicantId] = name
                                }
                            }
                            group.leave()
                        }
                }

                group.notify(queue: .main) {
                    self?.interviews = interviews
                    self?.scheduledInterviewTableView.reloadData()
                }
            }
        }
        
        // MARK: - UITableViewDataSource Methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return interviews.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Interview", for: indexPath) as! ScheduledInterviewsTableViewCell
                
                let interview = interviews[indexPath.row]
                let applicantName = applicantNames[interview.applicantId] ?? "Unknown"
                
                cell.configure(with: interview, applicantName: applicantName)
                cell.delegate = self // Set the delegate
                cell.parentViewController = self
                
                cell.backgroundColor = .clear
                cell.contentView.backgroundColor = .clear
                
                return cell
            
        }
        
        // View Details Button Action
        @objc func viewDetailsTapped(_ sender: UIButton) {
            let index = sender.tag
            let selectedInterview = interviews[index]
            performSegue(withIdentifier: "goToInterviewDetails", sender: selectedInterview)
        }
        

        
        private func fetchApplicantName(applicantId: String, completion: @escaping (String) -> Void) {
            let db = Firestore.firestore()
            db.collection("appliedJobs").document(applicantId).getDocument { (document, error) in
                if let error = error {
                    print("Error fetching applicant name: \(error.localizedDescription)")
                    completion("Unknown Name")
                    return
                }
                
                if let document = document, let name = document.data()?["fullName"] as? String {
                    completion(name)
                } else {
                    completion("Unknown Name")
                }
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInterviewDetails",
           let destinationVC = segue.destination as? InterviewInfoTableViewController,
           let interviewDetail = sender as? InterviewDetail {

            // Fetch applicant name
            fetchApplicantName(applicantId: interviewDetail.applicantId) { [weak self] applicantName in
                guard self != nil else { return }
                
                destinationVC.info = [
                    interviewDetail.location.isEmpty ? "Not Available" : interviewDetail.location, // Interview Location
                    DateFormatter.localizedString(from: interviewDetail.date.dateValue(), dateStyle: .medium, timeStyle: .none), // Date
                    DateFormatter.localizedString(from: interviewDetail.time.dateValue(), dateStyle: .none, timeStyle: .short), // Time
                    interviewDetail.notes.isEmpty ? "No Notes" : interviewDetail.notes // Notes
                ]

                DispatchQueue.main.async {
                    destinationVC.tableView.reloadData() // Reload the table view after data is set
                }
            }
        }
    }

    }
extension ScheduledInterviewsViewController: ScheduledInterviewsCellDelegate {
    func viewDetailsTapped(for interview: InterviewDetail) {
        performSegue(withIdentifier: "goToInterviewDetails", sender: interview)
    }
}
