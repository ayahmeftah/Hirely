import UIKit
import FirebaseFirestore
import Cloudinary

class ApplicationJobDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var positionlbl: UILabel!
    @IBOutlet weak var companyNamelbl: UILabel!
    @IBOutlet weak var jobDetailsTableView: UITableView!
    @IBOutlet weak var companyLogoImage: CLDUIImageView!
    
    
    // Cloudinary configuration
    let cloudName: String = "drkt3vace"
    let uploadPreset: String = "unsigned_upload"
    var cloudinary: CLDCloudinary!
    
    
    var jobPosting: JobPosting?
    var interviewId: String = ""
    var companylogo = ""
    
    // Passed data
    var companyIdSelected: String = ""
    var jobIdSelected: String = ""
    var appliedJobIdSelected: String = ""
    var jobPositionSelected: String? = nil
    var jobCompanySelected: String? = nil
    var jobStatusSelected: String? = nil
    
    var titles = ["Job Type", "Experience Level", "Salary Range", "City", "Job Description", "Job Requirements", "Skills"]
    var information: [String] = ["Loading...", "Loading...", "Loading...", "Loading...", "Loading...", "Loading...", "Loading..."]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Cloudinary
        initCloudinary()

        jobDetailsTableView.delegate = self
        jobDetailsTableView.dataSource = self

        // Set automatic dimensioning for multi-line cells
        jobDetailsTableView.estimatedRowHeight = 60
        jobDetailsTableView.rowHeight = UITableView.automaticDimension
        jobDetailsTableView.backgroundColor = .clear

        // Set up the top labels with passed data
        positionlbl.text = jobPositionSelected
        companyNamelbl.text = jobCompanySelected

        // Fetch the interviewId, job details, and company logo
        fetchInterviewId()
        fetchJobDetails()
        fetchCompanyLogo()

        // Set the company logo image
        let companyLogoURL = companylogo
        companyLogoImage.cldSetImage(companyLogoURL, cloudinary: cloudinary)

    }

    func initCloudinary() {
        let config = CLDConfiguration(cloudName: cloudName, secure: true)
        cloudinary = CLDCloudinary(configuration: config)
    }

    // Fetch the `scheduledInterviewId` from the `appliedJobs` collection
    func fetchInterviewId() {
        let db = Firestore.firestore()
        
        db.collection("appliedJobs").document(appliedJobIdSelected).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching applied job details: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No data found for applied job ID: \(self.appliedJobIdSelected)")
                return
            }
            
            // Retrieve the `scheduledInterviewId` from the data
            self.interviewId = data["scheduledInterviewId"] as? String ?? ""
            
            // Update the navigation bar based on the interviewId
            DispatchQueue.main.async {
                self.configureNavigationBar()
            }
            
            print("Fetched Interview ID: \(self.interviewId)")
        }
    }
    
    func fetchCompanyLogo() {
        let db = Firestore.firestore()
        
        db.collection("companies").document(companyIdSelected).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching company details: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data(), let companyPicture = data["companyPicture"] as? String else {
                print("No company picture found for company ID: \(self.companyIdSelected)")
                return
            }
            
            // Store the company picture URL
            self.companylogo = companyPicture
            
            // Set the image using the Cloudinary helper method
            DispatchQueue.main.async {
                self.companyLogoImage.cldSetImage(companyPicture, cloudinary: self.cloudinary)
            }
        }
    }


    

    func configureNavigationBar() {
        // Check job status and scheduledInterviewId
        if !interviewId.isEmpty {
            // Add "Interview Details" button to the navigation bar
            let interviewButton = UIBarButtonItem(title: "Interview Details", style: .plain, target: self, action: #selector(interviewDetailsTapped))
            navigationItem.rightBarButtonItem = interviewButton
        } else {
            // Hide the navigation bar button
            navigationItem.rightBarButtonItem = nil
        }
    }

    @objc func interviewDetailsTapped() {
        // Perform segue to the interview details page and pass the `interviewId`
        performSegue(withIdentifier: "goToInterviewDetails", sender: self)
    }

    func fetchJobDetails() {
        let db = Firestore.firestore()
        db.collection("jobPostings").document(jobIdSelected).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching job details: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No job details found for job ID: \(self.jobIdSelected)")
                return
            }
            
            // Format the skills with '*' and new lines
            let skillsArray = data["skills"] as? [String] ?? []
            let formattedSkills = skillsArray.map { "* \($0)" }.joined(separator: "\n")
            
            // Update the `information` array with data from Firestore
            self.information = [
                data["jobType"] as? String ?? "Unknown",
                data["experienceLevel"] as? String ?? "Unknown",
                "\(data["minimumSalary"] as? Int ?? 0) - \(data["maximumSalary"] as? Int ?? 0)",
                data["city"] as? String ?? "Unknown",
                data["jobDescription"] as? String ?? "No Description",
                data["jobRequirements"] as? String ?? "No Requirements",
                formattedSkills.isEmpty ? "No Skills" : formattedSkills
            ]
            
            // Reload table view with new data
            DispatchQueue.main.async {
                self.jobDetailsTableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "jobDetailsAppliedTo")
        
        // Set the title
        cell.textLabel?.text = titles[indexPath.row]
        
        if indexPath.row == 0 {
            // Set the detailTextLabel with styling for the badge
            cell.detailTextLabel?.text = information[indexPath.row]
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.detailTextLabel?.textColor = .white
            cell.detailTextLabel?.backgroundColor = UIColor(red: 243/255.0, green: 95/255.0, blue: 49/255.0, alpha: 1.0)
            cell.detailTextLabel?.textAlignment = .center
            cell.detailTextLabel?.layer.cornerRadius = 10
            cell.detailTextLabel?.layer.masksToBounds = true
            cell.detailTextLabel?.clipsToBounds = true
            
            // Apply constraints to adjust padding for the badge
            let _: CGFloat = 8
            let adjustedWidth = cell.detailTextLabel!.intrinsicContentSize.width + 6 // Add 4 to the intrinsic width
            cell.detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cell.detailTextLabel!.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                cell.detailTextLabel!.topAnchor.constraint(equalTo: cell.textLabel!.bottomAnchor, constant: 8),
                cell.detailTextLabel!.widthAnchor.constraint(equalToConstant: adjustedWidth), // Set width with adjustment
                cell.detailTextLabel!.heightAnchor.constraint(equalToConstant: 25)
            ])
        } else {
            // Reset detailTextLabel for other rows
            cell.detailTextLabel?.text = indexPath.row < information.count ? information[indexPath.row] : "No Data"
            cell.detailTextLabel?.numberOfLines = 0 // Unlimited lines
            cell.detailTextLabel?.textColor = .black
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.detailTextLabel?.backgroundColor = .clear
        }
        
        // Customize appearance for the title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textColor = UIColor(red: 0.0/255.0, green: 37.0/255.0, blue: 75.0/255.0, alpha: 1.0) // Dark Blue
        cell.selectionStyle = .none
        
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInterviewDetails",
           let destinationVC = segue.destination as? InterviewDetailViewController {
            destinationVC.interviewId = interviewId
            destinationVC.jobPositionSelected = jobPositionSelected ?? ""
            destinationVC.jobCompanySelected = jobCompanySelected ?? ""
            destinationVC.companyLogo = companylogo
            
            print("Navigating to Interview Details with Interview: \(interviewId), Position: \(jobPositionSelected ?? ""), Company: \(jobCompanySelected ?? ""), Logo URL: \(companylogo)")
        }
    }
}
