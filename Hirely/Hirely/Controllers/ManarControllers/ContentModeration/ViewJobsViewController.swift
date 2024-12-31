//
//  ViewJobsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit
import FirebaseFirestore

class ViewJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var selectedFilters: [String: String] = [:]
    
    @IBAction func filterJobsTap(_ sender: Any) {
        // Define the filter categories and their respective options
        let allFilters: [String: [String]] = [
            "City": CityOptions.allCases.map { $0.rawValue },
            "Job Type": JobTypeOptions.allCases.map { $0.rawValue },
            "Experience Level": ExperienceLevelOptions.allCases.map { $0.rawValue },
            "Location Type": LocationTypeOptions.allCases.map { $0.rawValue }
        ]
        
        // Create the filter alert using FilterAlertService
        let filterAlertVC = FilterAlertService().allFiltersAlert(with: allFilters)
        
        // Pass the currently selected filters (if any) to the alert
        filterAlertVC.selectedFilters = selectedFilters
        
        // Set the delegate to handle filter actions
        filterAlertVC.delegate = self
        
        // Configure the modal presentation style
        filterAlertVC.modalPresentationStyle = .overCurrentContext
        filterAlertVC.modalTransitionStyle = .crossDissolve
        
        // Present the alert
        self.present(filterAlertVC, animated: true, completion: nil)
    }

    
    @IBOutlet weak var jobPosts: UITableView!
    
    var jobPostings: [JobPosting] = [] //array to store job postings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobPosts.backgroundColor = .clear
        let nib = UINib.init(nibName: "ViewJobsAdminTableViewCell", bundle: nil)
        jobPosts.register(nib, forCellReuseIdentifier: "customJob")
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
                    self.jobPosts.reloadData()
                }
            }
        }
    }
    
    
    func addFlagDetails(for jobId: String, reason: String, comments: String) {
        let db = Firestore.firestore()

        // Create a new document reference in the flagDetails collection
        let documentRef = db.collection("flagDetails").document()

        // Create flag details including the document ID
        let flagDetails: [String: Any] = [
            "docId": documentRef.documentID, // Use the generated document ID
            "jobId": jobId,
            "flagReason": reason,
            "comment": comments,
            "flagDate": Timestamp(date: Date()),
            "status": "Flagged"
        ]

        // Add the flag details t o the document
        documentRef.setData(flagDetails) { error in
            if let error = error {
                print("Error adding flag details: \(error.localizedDescription)")
            } else {
                print("Flag details added successfully.")

                // Update isFlagged in jobPostings
                db.collection("jobPostings").document(jobId).updateData(["isFlagged": true]) { error in
                    if let error = error {
                        print("Error updating job flag state: \(error.localizedDescription)")
                    } else {
                        print("Job flagged successfully.")
                        DispatchQueue.main.async {
                            self.fetchJobPostings() // Reload the table view to update the flag icon
                        }
                    }
                }
            }
        }
    }

}
extension ViewJobsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobPostings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customJob", for: indexPath) as? ViewJobsAdminTableViewCell else {
            return UITableViewCell()
        }
        
        let job = jobPostings[indexPath.row]
        
        // Use postInit to configure the cell
        
        cell.postInit("Google Inc", job.jobType, job.jobTitle, "google", job.postedDate, job.deadline, job.docId, job.isFlagged)
        
        cell.backgroundColor = .clear
        cell.parentViewController = self //pass view controller to cell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ViewJobsAdminTableViewCell,
           let indexPath = jobPosts.indexPath(for: cell) {
            let selectedJob = jobPostings[indexPath.row] //get the selected job posting
            //pass to Job Details Screen
            if segue.identifier == "goToJobDetails" {
                if let detailsVC = segue.destination as? JobInfoAdminViewController {
                    detailsVC.jobPosting = selectedJob
                }
                
            }else if segue.identifier == "goToFlagJob" {
                if let flagVC = segue.destination as? FlagPostViewController,
                   let cell = sender as? ViewJobsAdminTableViewCell {
                    flagVC.jobId = cell.jobId // Pass the job ID
                    flagVC.onSave = { [weak self] reason, comments in
                        guard let self = self, let jobId = cell.jobId else { return }
                        self.addFlagDetails(for: jobId, reason: reason, comments: comments)
                    }
                }
            }
        }
        
    }}
extension ViewJobsViewController: FilterAlertDelegate {
    func didApplyFilters(_ filters: [String: String]) {
        // Save the selected filters
        selectedFilters = filters
        
        // Filter the job postings based on the selected filters
        let searchFilteredJobs = jobPostings.filter { job in
            let matchesJobType = filters["Job Type"] == nil || job.jobType.lowercased() == filters["Job Type"]!.lowercased()
            let matchesExperienceLevel = filters["Experience Level"] == nil || job.experienceLevel.lowercased() == filters["Experience Level"]!.lowercased()
            let matchesLocationType = filters["Location Type"] == nil || job.locationType.lowercased() == filters["Location Type"]!.lowercased()
            let matchesCity = filters["City"] == nil || job.city.lowercased() == filters["City"]!.lowercased()
            
            return matchesJobType && matchesExperienceLevel && matchesLocationType && matchesCity
        }
        
        // Update the job postings displayed in the table view
        self.jobPostings = searchFilteredJobs
        self.jobPosts.reloadData()
    }
    
    func didResetFilters() {
        // Reset all filters
        selectedFilters.removeAll()
        
        // Reload the original job postings (no filters applied)
        fetchJobPostings()
    }
}

