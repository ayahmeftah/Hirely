//
//  JobPostingViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


protocol JobPostingsRefreshDelegate: AnyObject {
    func refreshJobPostings()
}

class JobPostingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,JobPostingsRefreshDelegate{
    
    @IBOutlet weak var tableView: UITableView!

    var jobPostings: [JobPosting] = [] //array to store job postings
    
    @IBAction func unwindToJobPostings(segue: UIStoryboardSegue) {
        // This method is intentionally left empty.
        // It will serve as the target for the unwind segue.
    }
 
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        showLogoutAlert()
    }
    
    
    func showErrorAlert(_ errorMessage: String){
            let alert = UIAlertController(title: "Error",
                                          message: errorMessage,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        // Call this function when you want to show the logout confirmation alert
        func showLogoutAlert() {
            // Create an alert controller
            let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
            
            // Create the "Yes" action
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                // Handle the log out action
                self.logOut()
            }
            
            // Create the "No" action
            let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                // Handle the cancel action (do nothing)
                print("User canceled log out.")
            }
            
            // Add actions to the alert controller
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            // Present the alert controller
            self.present(alertController, animated: true, completion: nil)
        }
        
        func logOut(){
            let auth = Auth.auth()
            do{
                try auth.signOut()
                UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                self.dismiss(animated: true)
            }catch let signOutError{
                showErrorAlert("\(signOutError)")
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        let nib = UINib.init(nibName: "CustomJobPostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "jobCustomCell")
        fetchJobPostings() //get data
    
        // Add observer for job posted notification
        NotificationCenter.default.addObserver(self, selector: #selector(refreshJobs), name: NSNotification.Name("JobPosted"), object: nil)

    }
    
    func refreshJobPostings() {
        // Fetch the updated job postings after editing and reload the table view
        fetchJobPostings()
        tableView.reloadData() // or collectionView.reloadData()
    }
    
    @objc private func refreshJobs() {
        fetchJobPostings()
        tableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("JobPosted"), object: nil)
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

        //update database with the new visibility state
        db.collection("jobPostings").document(jobPosting.docId).updateData(["isHidden": newIsHidden]) { error in
            if let error = error {
                print("Error updating job visibility: \(error.localizedDescription)")
            } else {
                print("Job visibility updated successfully.")

                //update the local jobPosting object
                if let index = self.jobPostings.firstIndex(where: { $0.docId == jobPosting.docId }) {
                    self.jobPostings[index].isHidden = newIsHidden

                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }
                    //show confirmation message
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
                    
                    //remove the job posting from the array and update the table view
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
        
        cell.commonInit(
            "Microsoft Corporation",
            "microsoft",
            job.jobTitle,
            job.jobType,
            "Posted: \(job.postedDate)",
            "Deadline: \(job.deadline)",
            job
        )
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        // Set the icon based on visibility status
        let buttonIcon = job.isHidden ? "eye.slash.fill" : "eye.fill"
        cell.hideButton.setImage(UIImage(systemName: buttonIcon), for: .normal)
        
        cell.jobPosting = job
        cell.parentViewController = self 
        cell.parentController = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails",
           let detailsVC = segue.destination as? JobDetailsViewController,
           let cell = sender as? CustomJobPostTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            // Handle navigating to job details
            let selectedJob = jobPostings[indexPath.row]
            print("Navigating to Job Details with job: \(selectedJob.jobTitle)")
            detailsVC.jobPosting = selectedJob
        } else if segue.identifier == "goToApplicants",
                  let applicantsVC = segue.destination as? ReviewApplicationsViewController,
                  let cell = sender as? CustomJobPostTableViewCell,
                  let indexPath = tableView.indexPath(for: cell) {
            // Handle navigating to applicants
            let selectedJob = jobPostings[indexPath.row]
            print("Navigating to Applicants for job: \(selectedJob.jobTitle)")
            applicantsVC.jobId = selectedJob.docId
        } else if segue.identifier == "editJobDetails",
                  let editVC = segue.destination as? EditJobPostViewController,
                  let selectedJob = sender as? JobPosting {
            // Handle editing job post
            print("Navigating to Edit Job Post with job: \(selectedJob.jobTitle)")
            editVC.jobPosting = selectedJob
        } else {
            print("Unknown segue identifier or sender type")
        }
    }
    }

