//
//  FlagInfoTableViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 20/12/2024.
//

import UIKit
import FirebaseFirestore

class FlagInfoTableViewController: UITableViewController {

    var flagDetails: FlaggedJob?
    var selectedJob: JobPosting? // Store fetched job data here


    @IBOutlet weak var jobTitlelLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel! // change later
    @IBOutlet weak var employerNameLbl: UILabel! // change later
    @IBOutlet weak var dateFlaggedLbl: UILabel!
    @IBOutlet weak var flagReasonLbl: UILabel!
    @IBOutlet weak var commentsLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //pre-fetch job details in advance to avoid long loading time
            guard let flagDetails = flagDetails else { return }
            fetchJobDetails(for: flagDetails.jobId) { [weak self] job in
                self?.selectedJob = job // Cache the job details
            }
    }

    private func setupUI() {
        guard let flagDetails = flagDetails else {
            print("Error: flagDetails is nil")
            return
        }
        print("Setting up UI with flagDetails: \(flagDetails)")

        jobTitlelLbl.text = ""
        companyNameLbl.text = "Google Inc" // chnage later
        employerNameLbl.text = "John Doe" // change later
        dateFlaggedLbl.text = DateFormatter.localizedString(from: flagDetails.flaggedDate, dateStyle: .medium, timeStyle: .none)
        flagReasonLbl.text = flagDetails.flagReason
        commentsLbl.text = flagDetails.comments

        //Fetch the job title from the jobPostings collection
        fetchJobTitle(for: flagDetails.jobId) { jobTitle in
            DispatchQueue.main.async {
                self.jobTitlelLbl.text = jobTitle
            }
        }
    }

    private func fetchJobTitle(for jobId: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()

        db.collection("jobPostings").document(jobId).getDocument { document, error in
            if let error = error {
                print("Error fetching job title: \(error.localizedDescription)")
                completion("Unknown Title")
                return
            }

            if let document = document, document.exists,
               let jobTitle = document.data()?["jobTitle"] as? String {
                completion(jobTitle)
            } else {
                completion("Unknown Title")
            }
        }
    }

    @IBAction func removeFlagTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Remove Flag",
                                         message: "Are you sure you want to remove the flag for this job post?",
                                         preferredStyle: .alert)
           
           //message confirmation action
           alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
               guard let flagId = self.flagDetails?.docId,
                     let jobId = self.flagDetails?.jobId else { return }
               
               let db = Firestore.firestore()
               
               //Remove the flagDetails document
               db.collection("flagDetails").document(flagId).delete { error in
                   if let error = error {
                       print("Error removing flag: \(error.localizedDescription)")
                   } else {
                       print("Flag removed.")
                       
                       //Update isFlagged in the jobPostings collection
                       db.collection("jobPostings").document(jobId).updateData(["isFlagged": false]) { updateError in
                           if let updateError = updateError {
                               print("Error updating job flag status: \(updateError.localizedDescription)")
                           } else {
                               print("Job flag status updated.")
                               //Notify the parent view to reload data
                               NotificationCenter.default.post(name: NSNotification.Name("FlagRemoved"), object: nil, userInfo: ["jobId": jobId])
                               self.navigationController?.popViewController(animated: true)
                           }
                       }
                   }
               }
           }))
           
           //Cancel action
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           present(alert, animated: true, completion: nil)
    }

    @IBAction func deletePostTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Flagged Post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self,
                      let jobId = self.flagDetails?.jobId,
                      let flagId = self.flagDetails?.docId else { return }
                
                let db = Firestore.firestore()
                
                // Delete the job posting
                db.collection("jobPostings").document(jobId).delete { error in
                    if let error = error {
                        print("Error deleting job post: \(error.localizedDescription)")
                    } else {
                        print("Job post deleted.")
                        
                        // Delete the flagged job from flagDetails collection
                        db.collection("flagDetails").document(flagId).delete { flagError in
                            if let flagError = flagError {
                                print("Error deleting flagDetails: \(flagError.localizedDescription)")
                            } else {
                                print("FlagDetails entry deleted.")
                                
                                // Notify the flagged jobs screen to refresh data
                                NotificationCenter.default.post(name: NSNotification.Name("JobDeleted"), object: nil, userInfo: ["jobId": jobId])
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    
    
    private func fetchJobDetails(for jobId: String, completion: @escaping (JobPosting?) -> Void) {
            let db = Firestore.firestore()

            db.collection("jobPostings").document(jobId).getDocument { document, error in
                if let error = error {
                    print("Error fetching job details: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                if let document = document, document.exists {
                    var data = document.data() ?? [:]
                    data["docId"] = document.documentID // Include the document ID
                    let job = JobPosting(data: data)
                    completion(job)
                } else {
                    print("Error: Job document does not exist")
                    completion(nil)
                }
            }
        }
    
    
    @IBAction func viewFlaggedPostDetailsTapped(_ sender: UIButton) {
        guard let flagDetails = flagDetails else {
                   print("Error: flagDetails is nil")
                   return
               }

               fetchJobDetails(for: flagDetails.jobId) { [weak self] job in
                   guard let self = self else { return }
                   DispatchQueue.main.async {
                       if let job = job {
                           self.selectedJob = job

                       } else {
                           print("Failed to load job details.")
                       }
                   }
               }
           }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewFlaggedPostDetailsAdmin",
                   let destinationVC = segue.destination as? JobInfoAdminViewController {
                    destinationVC.jobPosting = selectedJob // Pass the selected job
                }
            }

    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
