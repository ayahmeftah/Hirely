//
//  ReportedPostDetailTableViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 20/12/2024.
//

import UIKit
import FirebaseFirestore

class ReportedPostDetailTableViewController: UITableViewController {

    @IBOutlet weak var jobTitleLbl: UILabel!
    
    @IBOutlet weak var companyNameLbl: UILabel!
    
    @IBOutlet weak var employerNameLbl: UILabel!
        
    var job: JobPosting?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let job = job else { return }
        jobTitleLbl.text = job.jobTitle
        companyNameLbl.text = "Google LLC" //change later
        employerNameLbl.text = "John Doe" //change later
        }
   
    
    @IBAction func viewReportedPostTapped(_ sender: UIButton) {
    }
    
    @IBAction func flagPostTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "flagReportedPost",
               let destinationVC = segue.destination as? FlagPostViewController {
                destinationVC.jobId = job?.docId // Pass the job id
                destinationVC.onSave = { [weak self] reason, comments in
                    self?.flagJob(reason: reason, comments: comments)
                }
            }
        else if segue.identifier == "viewReportedJobDetails",
                let destinationVC = segue.destination as? JobInfoAdminViewController {
                        //Pass the job details to the JobInfoAdminViewController
                        destinationVC.jobPosting = job
                    }
        }
    
    //code to addd flag job details for the reported post if it is flagged
    private func flagJob(reason: String, comments: String) {
        guard let jobId = job?.docId else { return }
        
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

        // Add the flag details to the document
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

                        }
                    }
                }
            }
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
