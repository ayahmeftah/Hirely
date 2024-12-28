//
//  ApplicantInfoTableViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 18/12/2024.
//

import UIKit
import FirebaseFirestore

class ApplicantInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var applicantName: UILabel!
    
    @IBOutlet weak var applicantAge: UILabel!
    
    @IBOutlet weak var applicantPhone: UILabel!
    
    @IBOutlet weak var applicantEmail: UILabel!
    
    @IBOutlet weak var viewCvBtn: UIButton!
        
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var actionsMenuBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var isChecked = false
    var application: JobApplication? {
        didSet {
            // Ensure UI is updated if the view is loaded
            if isViewLoaded {
                setupUI()
            }
        }
    }



    @IBAction func checkboxTapped(_ sender: UIButton) {
        isChecked.toggle()
            updateCheckbox()
            if isChecked {
                updateApplicationStatus(to: "Reviewed") { [weak self] success in
                    if success {
                        self?.application?.applicationStatus = "Reviewed" // Update local application state
                        NotificationCenter.default.post(name: NSNotification.Name("ApplicationStatusUpdated"), object: nil, userInfo: ["docId": self?.application?.docId ?? "", "status": "Reviewed"])
                        print("Status updated to Reviewed.")
                    }
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // Setup the UI if the application is already set
        
        // Reload static table view to reflect changes
        tableView.reloadData()

    }
    
    private func setupUI() {
        guard let application = application else {
            print("Error: application is nil.")
            return
        }
        print("Setting up UI with application: \(application)") // Debug log
        
        applicantName.text = application.fullName
        applicantAge.text = application.age
        applicantPhone.text = application.phoneNumber
        applicantEmail.text = application.email
        
        // Set the checkbox state based on the application status
            isChecked = application.applicationStatus.lowercased() == "reviewed"
            updateCheckbox() // Ensure the checkbox reflects the current state
    }

        func updateCheckbox() {
            let imageName = isChecked ? "checkmark.square.fill" : "square"
            checkBoxBtn.setImage(UIImage(systemName: imageName), for: .normal)
            checkBoxBtn.tintColor = isChecked ? .systemGreen : .systemBlue // Green if checked, blue if unchecked

        }
    
    @IBAction func actionSelection(_ sender: UIAction){
        self.actionsMenuBtn.setTitle(sender.title, for: .normal)
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        guard let application = application else { return }
            let newStatus: String = {
                if actionsMenuBtn.currentTitle?.lowercased() == "hire" {
                    return "Hired"
                } else if actionsMenuBtn.currentTitle?.lowercased() == "reject" {
                    return "Rejected"
                }
                return application.applicationStatus
            }()
            
            // Only update if a new action is selected
            if newStatus != application.applicationStatus {
                updateApplicationStatus(to: newStatus) { [weak self] success in
                    if success {
                        self?.application?.applicationStatus = newStatus
                        self?.showAlert(title: "Success", message: "Application status updated to \(newStatus).")
                        NotificationCenter.default.post(name: NSNotification.Name("ApplicationStatusUpdated"), object: nil, userInfo: ["docId": application.docId, "status": newStatus])
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        self?.showAlert(title: "Error", message: "Failed to update application status.")
                    }
                }
            }
        }

        private func updateApplicationStatus(to status: String, completion: @escaping (Bool) -> Void) {
            guard let application = application else { return }
            let db = Firestore.firestore()
            db.collection("appliedJobs").document(application.docId).updateData(["applicationStatus": status]) { error in
                if let error = error {
                    print("Error updating application status: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Application status updated to \(status).")
                    completion(true)
                }
            }
        }
        
        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToViewApplicantCV",
           let destinationVC = segue.destination as? ViewApplicantCVViewController {
            destinationVC.cvLink = application?.cv 
        }
        else if segue.identifier == "goToScheduleInterview",
                let destinationVC = segue.destination as? ScheduleInterviewViewController {
                 destinationVC.applicationDocId = application?.docId // Pass the document ID of the applied job
            destinationVC.applicantId = application?.userId // Pass the applicantId
            destinationVC.jobId = application?.jobId // Pass the jobId
             }
    }

    
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem


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
