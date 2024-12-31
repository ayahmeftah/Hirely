import UIKit
import FirebaseFirestore
import FirebaseAuth

class ApplicantsApplicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var pageSub: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // needs to be chnaged
    let userId = "HiG1taJhkrOsryNM7PtG"
    //var userId: String = "ppRloi8VPTvhItiWAYTT" // Current user ID
    var companyIdSelected: String = ""
    var jobIdSelected: String = ""
    var jobPositionSelected: String? = nil
    var jobCompanySelected: String? = nil
    var jobStatusSelected: String? = nil
    var appliedJobIdSelected: String = "" //store the selected applied job ID
    
    // Arrays for table view data
    var companyIds: [String] = [] // Store actual company IDs
    var jobIds: [String] = [] // Store actual job IDs
    var appliedJobIds: [String] = [] // Store applied job IDs (docIds)
    var companyNames: [String] = [] //
    var position: [String] = [] //
    var applicationStatus: [String] = [] //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        
        // Register the custom table view cell
        let nib = UINib(nibName: "CustomCellForApplicantsApplicationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "appliedJobsCell")
        
        // Fetch applied jobs data
        fetchAppliedJobs()
    }
    
    func fetchAppliedJobs() {
        let db = Firestore.firestore()
        let userDocRef = db.collection("Users").document(userId)
        
        userDocRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data(),
                  let appliedJobs = data["appliedJobs"] as? [String], !appliedJobs.isEmpty else {
                print("No applied jobs found for the user.")
                return
            }
            
            // Fetch data for each applied job
            self.fetchDetailsForAppliedJobs(appliedJobs: appliedJobs)
        }
    }
    
    func fetchDetailsForAppliedJobs(appliedJobs: [String]) {
        let db = Firestore.firestore()
        let group = DispatchGroup()
        
        for appliedJobId in appliedJobs {
            group.enter()
            db.collection("appliedJobs").document(appliedJobId).getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching applied job data for appliedJobId \(appliedJobId): \(error.localizedDescription)")
                    group.leave()
                    return
                }
                
                guard let data = snapshot?.data() else {
                    print("No data found for applied job \(appliedJobId)")
                    group.leave()
                    return
                }
                
                // Add the appliedJobId to the array
                self.appliedJobIds.append(appliedJobId)
                
                // Fetch application status
                let status = data["applicationStatus"] as? String ?? "Unknown"
                self.applicationStatus.append(status)
                
                // Fetch job posting to get company ID and job title
                let jobPostingId = data["jobId"] as? String ?? ""
                self.jobIds.append(jobPostingId) // Add the jobId of the job posting
                
                self.fetchJobPostingData(jobPostingId: jobPostingId) {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            print("All applied job details fetched")
            self.updatePageSubLabel()
            self.tableView.reloadData()
        }
    }
    
    func fetchJobPostingData(jobPostingId: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("jobPostings").document(jobPostingId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching job posting data for job ID \(jobPostingId): \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No data found for job posting ID: \(jobPostingId)")
                completion()
                return
            }
            
            // Append job title to the positions array
            let jobTitle = data["jobTitle"] as? String ?? "Unknown"
            self.position.append(jobTitle)
            
            // Fetch company details to get company name
            let companyId = data["companyId"] as? String ?? ""
            self.companyIds.append(companyId) // Add the actual company ID
            
            self.fetchCompanyDetails(companyId: companyId) {
                completion()
            }
        }
    }
    
    func fetchCompanyDetails(companyId: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("companies").document(companyId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching company details for company ID \(companyId): \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No data found for company ID: \(companyId)")
                completion()
                return
            }
            
            // Append company name to the companyNames array
            let companyName = data["name"] as? String ?? "Unknown"
            self.companyNames.append(companyName)
            
            completion()
        }
    }
    
    
    
    
    
    func updatePageSubLabel() {
        
        let applicationsCount = companyNames.count
        let text = "Tracking \(applicationsCount) Applications"
        let attributedString = NSMutableAttributedString(string: text)
        if let numberRange = text.range(of: "\(applicationsCount)") {
            let nsRange = NSRange(numberRange, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: nsRange)
        }
        
        pageSub.attributedText = attributedString
        
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "appliedJobsCell", for: indexPath) as? CustomCellForApplicantsApplicationTableViewCell else {
            return UITableViewCell()
        }

        cell.appliedInit(position[indexPath.row], companyNames[indexPath.row], applicationStatus[indexPath.row])
        cell.companyId = companyIds[indexPath.row] // Pass the correct company ID
        cell.jobId = jobIds[indexPath.row] // Pass the correct job ID
        cell.delegate = self
        cell.backgroundColor = .clear

        return cell
    }

    func didTapButton(companyId: String, jobId: String) {
        companyIdSelected = companyId
        jobIdSelected = jobId
        
        // Also pass position, company name, status, and appliedJobId
        if let index = companyIds.firstIndex(of: companyId) {
            jobPositionSelected = position[index]
            jobCompanySelected = companyNames[index]
            jobStatusSelected = applicationStatus[index]
            appliedJobIdSelected = appliedJobIds[index] // Get the appliedJobId
        }
        
        performSegue(withIdentifier: "goToJobDetail", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToJobDetail",
           let destinationVC = segue.destination as? ApplicationJobDetailsViewController {
            
            destinationVC.companyIdSelected = companyIdSelected
            destinationVC.jobIdSelected = jobIdSelected
            destinationVC.jobPositionSelected = jobPositionSelected
            destinationVC.jobCompanySelected = jobCompanySelected
            destinationVC.jobStatusSelected = jobStatusSelected
            destinationVC.appliedJobIdSelected = appliedJobIdSelected // Pass the appliedJobId
            
            print("Navigating to Job Details with appliedJobId: \(appliedJobIdSelected)")
        }
    }
}
