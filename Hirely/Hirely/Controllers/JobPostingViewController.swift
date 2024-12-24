//
//  JobPostingViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit
import FirebaseFirestore

class JobPostingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!

    var jobPostings: [JobPosting] = [] //array to store job postings
    
    @IBAction func unwindToJobPostings(segue: UIStoryboardSegue) {
        // This method is intentionally left empty.
        // It will serve as the target for the unwind segue.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        let nib = UINib.init(nibName: "CustomJobPostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "jobCustomCell")
        fetchJobPostings() //get data

    }
    //get data from firestore
    func fetchJobPostings() {
        let db = Firestore.firestore()
        db.collection("jobPostings").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching job postings: \(error.localizedDescription)")
            } else {
                self.jobPostings.removeAll() //clear existing data
                
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    let jobPosting = JobPosting(data: data) //convert document to JobPosting
                    self.jobPostings.append(jobPosting)
                }
                //reload the table view with new data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func toggleJobVisibility(jobPosting: JobPosting, newIsHidden: Bool) {
        let db = Firestore.firestore()

        // Update Firestore with the new visibility state
        db.collection("jobPostings").document(jobPosting.docId).updateData(["isHidden": newIsHidden]) { error in
            if let error = error {
                print("Error updating job visibility: \(error.localizedDescription)")
            } else {
                print("Job visibility updated successfully.")

                // Update the local jobPosting object
                if let index = self.jobPostings.firstIndex(where: { $0.docId == jobPosting.docId }) {
                    self.jobPostings[index].isHidden = newIsHidden

                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }
                    // Show confirmation message
                    let message = newIsHidden
                        ? "This post is now hidden from applicants."
                        : "This post is now visible to applicants."
                    self.showAlert(message: message) // Show the alert
                }
            }
        }
    }

    //display an alert message
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func deleteJobPosting(jobPosting: JobPosting) {
        let db = Firestore.firestore()
        
        //display confirmation alert before deleting post
        let alert = UIAlertController(
            title: "Delete Job Post",
            message: "Are you sure you want to delete this job posting?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            
            //delete the document from Firestore
            db.collection("jobPostings").document(jobPosting.docId).delete { error in
                if let error = error {
                    print("Error deleting job posting: \(error.localizedDescription)")
                } else {
                    print("Job posting deleted successfully.")
                    
                    // Remove the job posting from the local array and update the table view
                    if let index = self.jobPostings.firstIndex(where: { $0.docId == jobPosting.docId }) {
                        self.jobPostings.remove(at: index)
                        DispatchQueue.main.async {
                            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        }
                    }
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }

    
    }

extension JobPostingViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobPostings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "jobCustomCell", for: indexPath) as? CustomJobPostTableViewCell else {
            return UITableViewCell()
        }
        
        let job = jobPostings[indexPath.row]
        
        // Use commonInit to configure the cell
        cell.commonInit(
            "Microsoft Corporation",
            "microsoft",
            job.jobTitle,
            job.jobType,
            "Posted: \(job.postedDate)",
            "Deadline: \(job.deadline)",
            "Applicants: 0"
        )
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        // Set the icon based on visibility status
            let buttonIcon = job.isHidden ? "eye.slash.fill" : "eye.fill"
            cell.hideButton.setImage(UIImage(systemName: buttonIcon), for: .normal)
        
        cell.jobPosting = job
        cell.parentViewController = self //pass view controller to the cell
        cell.parentController = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CustomJobPostTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let selectedJob = jobPostings[indexPath.row] //get the selected job posting
            
            //pass to Job Details Screen
            if segue.identifier == "goToDetails" {
                if let detailsVC = segue.destination as? JobDetailsViewController {
                    detailsVC.jobPosting = selectedJob
                }
            }
            //pass to applicant review screen
            else if segue.identifier == "goToApplicants" {
                if let applicantsVC = segue.destination as? ReviewApplicationsViewController {
    //                applicantsVC.jobPosting = selectedJob
                }
            }
            // Pass to Edit Job Post Screen
            else if segue.identifier == "editJobDetails" {
                if let editVC = segue.destination as? EditJobPostViewController {
                    editVC.jobPosting = selectedJob // Pass the selected job data
                }
            
            }
        }
    }


}
