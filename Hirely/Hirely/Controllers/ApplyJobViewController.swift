import UIKit
import UniformTypeIdentifiers
import FirebaseFirestore
import FirebaseAuth
import Cloudinary

class ApplyJobViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var companyLogoimg: UIImageView!
    @IBOutlet weak var positionlbl: UILabel!
    @IBOutlet weak var companyNamelbl: UILabel!

    @IBOutlet weak var fullNametxt: UITextField!
    @IBOutlet weak var agetxt: UITextField!
    @IBOutlet weak var phoneNumbertxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var uploadCVbtn: UIButton!
    @IBOutlet weak var applybtn: UIButton!

    var fetchedCVURL: String? // Stores the fetched CV URL from Hirely
    var selectedCVURL: String? // Stores the selected CV file URL
    
    var jobPosting: JobPosting? // Holds the fetched job posting data
    var companyDetails: CompanyDetails? // Holds the fetched company details
    
    
    var jobId = "7J4ZFgnWengAKzKSM6dM" // Replace with the actual job document ID
    var userId = "ppRloi8VPTvhItiWAYTT"
    var companyId = "RYINaYeqoq6WXBkdCOoK"
    
    // Cloudinary configuration
    let cloudName: String = "drkt3vace"
    let uploadPreset: String = "unsigned_upload"
    var cloudinary: CLDCloudinary!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Cloudinary
        initCloudinary()

        // Add actions to buttons
        uploadCVbtn.addTarget(self, action: #selector(uploadCVTapped), for: .touchUpInside)
        applybtn.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)

        // Fetch job posting and company details
        fetchJobPostingData()
        fetchCompanyDetails(companyId: companyId)
        fetchUserData()

        // Set up UI with fetched data
        setUpUI()
    }

    private func initCloudinary() {
        let config = CLDConfiguration(cloudName: cloudName, secure: true)
        cloudinary = CLDCloudinary(configuration: config)
    }

    func fetchUserData() {
        let db = Firestore.firestore()
        let userDocRef = db.collection("Users").document(userId) // Use the current user ID

        userDocRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found for user ID: \(self.userId)")
                return
            }

            // Populate the text fields with user information
            DispatchQueue.main.async {
                self.fullNametxt.text = "\(data["firstName"] as? String ?? "") \(data["lastName"] as? String ?? "")"
                self.agetxt.text = "\(self.calculateAge(from: data["dateOfBirth"] as? Timestamp))"
                self.phoneNumbertxt.text = data["phoneNumber"] as? String ?? ""
                self.emailtxt.text = data["email"] as? String ?? ""
            }
        }
    }

    func calculateAge(from timestamp: Timestamp?) -> Int {
        guard let dateOfBirth = timestamp?.dateValue() else { return 0 }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return ageComponents.year ?? 0
    }
    
    func setUpUI() {
        guard let jobPosting = jobPosting, let companyDetails = companyDetails else {
            print("Job posting or company details are missing.")
            return
        }

        positionlbl.text = jobPosting.jobTitle
        companyNamelbl.text = companyDetails.name
        //        if let logoURL = URL(string: companyDetails.companyPicture) {
        //            // Load the company logo asynchronously
        //            DispatchQueue.global().async {
        //                if let data = try? Data(contentsOf: logoURL), let image = UIImage(data: data) {
        //                    DispatchQueue.main.async {
        //                        self.companyLogoimg.image = image
        //                    }
        //                }
        //            }
        //        }
    }

    func fetchJobPostingData() {
        let db = Firestore.firestore()
        

        db.collection("jobPostings").document(jobId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching job posting: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.jobPosting = JobPosting(data: data)
                DispatchQueue.main.async {
                    self.setUpUI()
                }
            }
        }
    }

    func fetchCompanyDetails(companyId: String) {
        let db = Firestore.firestore()
        db.collection("companies").document(companyId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching company details: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.companyDetails = CompanyDetails(data: data)
                DispatchQueue.main.async {
                    self.setUpUI()
                }
            } else {
                print("No company data found for ID: \(companyId)")
            }
        }
    }

    @objc func uploadCVTapped() {
        let alert = UIAlertController(title: "Upload CV", message: "Choose an option to upload your CV.", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Upload from Device", style: .default, handler: { _ in
            self.presentDocumentPicker(for: self.uploadCVbtn)
        }))

        alert.addAction(UIAlertAction(title: "Fetch from Hirely", style: .default, handler: { _ in
            self.fetchAndDisplayCVOptions()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.uploadCVbtn
            popoverController.sourceRect = self.uploadCVbtn.bounds
        }

        present(alert, animated: true, completion: nil)
    }



    func presentDocumentPicker(for button: UIButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        uploadCVToCloudinary(fileURL: selectedFileURL)
    }

    private func uploadCVToCloudinary(fileURL: URL) {
        guard let data = try? Data(contentsOf: fileURL) else {
            print("Failed to read file data.")
            return
        }

        cloudinary.createUploader().upload(data: data, uploadPreset: uploadPreset, completionHandler:  { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error uploading CV to Cloudinary: \(error.localizedDescription)")
                    self.uploadCVbtn.setTitle("Upload Failed", for: .normal)
                    return
                }
                
                if let secureUrl = response?.secureUrl {
                    print("CV uploaded successfully: \(secureUrl)")
                    self.selectedCVURL = secureUrl
                    self.uploadCVbtn.setTitle("File Uploaded", for: .normal)
                }
            }
        })
    }

    @objc func applyButtonTapped() {
        // Validate input fields
        guard let fullName = fullNametxt.text, !fullName.isEmpty else {
            showAlert(title: "Error", message: "Please enter your full name.")
            return
        }

        guard let age = agetxt.text, !age.isEmpty else {
            showAlert(title: "Error", message: "Please enter your age.")
            return
        }

        guard let phoneNumber = phoneNumbertxt.text, !phoneNumber.isEmpty else {
            showAlert(title: "Error", message: "Please enter your phone number.")
            return
        }

        guard let email = emailtxt.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email.")
            return
        }

        let cvLink = fetchedCVURL ?? selectedCVURL
        guard let validCVLink = cvLink, !validCVLink.isEmpty else {
            showAlert(title: "Error", message: "Please upload your CV. It is mandatory.")
            return
        }

        // Prepare data to save in Firestore
        let applicationData: [String: Any] = [
            "fullName": fullName,
            "age": age,
            "phoneNumber": phoneNumber,
            "email": email,
            "cv": validCVLink,
            "dateApplied": Timestamp(date: Date()),
            "applicationStatus": "New",
            "jobId": jobId,
            "scheduledInterviewId": "",
            //adjust
            "userId": userId
            //"userId": getCurrentUserId() ?? "Unknown"
        ]

        saveApplicationData(data: applicationData)
    }

    func saveApplicationData(data: [String: Any]) {
        let db = Firestore.firestore()
        db.collection("appliedJobs").addDocument(data: data) { error in
            if let error = error {
                print("Error saving application: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to submit your application. Please try again.")
            } else {
                print("Application submitted successfully!")
                self.showAlert(title: "Success", message: "Your application has been submitted.")
                self.clearForm()
            }
        }
    }

    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func clearForm() {
        fullNametxt.text = ""
        agetxt.text = ""
        phoneNumbertxt.text = ""
        emailtxt.text = ""
        uploadCVbtn.setTitle("Upload CV", for: .normal)
        fetchedCVURL = nil
        selectedCVURL = nil
    }

    func fetchAndDisplayCVOptions() {
        getCVs { cvUrls in
            DispatchQueue.main.async {
                guard !cvUrls.isEmpty else {
                    self.showAlert(title: "No CVs Found", message: "There are no CVs available for selection.")
                    return
                }
                
                // Create and display an alert with CV options
                let cvAlert = UIAlertController(title: "Select a CV", message: "Choose a CV to upload.", preferredStyle: .actionSheet)
                
                var count = 1 //counter
                
                for (cvId, cvUrl) in cvUrls {
                    cvAlert.addAction(UIAlertAction(title: "CV \(count) ID: \(cvId)", style: .default, handler: { _ in
                        // Set the selected CV URL and update the button title
                        self.fetchedCVURL = cvUrl
                        self.uploadCVbtn.setTitle("CV Uploaded", for: .normal)
                        print("Selected CV URL: \(cvUrl)")
                    }))
                    count += 1 //increment
                }
                
                cvAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                // Handle iPad popover presentation
                if let popoverController = cvAlert.popoverPresentationController {
                    popoverController.sourceView = self.uploadCVbtn
                    popoverController.sourceRect = self.uploadCVbtn.bounds
                }
                
                self.present(cvAlert, animated: true, completion: nil)
            }
        }
    }

    // Fetch CVs for the current user
    func getCVs(completion: @escaping ([String: String]) -> Void) {
        let db = Firestore.firestore()
        let userDocRef = db.collection("Users").document(userId)
        var cvUrls: [String: String] = [:] // Dictionary to hold CV ID and URL pairs

        userDocRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(cvUrls) // Return an empty dictionary
                return
            }

            guard let data = snapshot?.data(),
                  let cvIds = data["cvs"] as? [String], !cvIds.isEmpty else {
                print("No CVs found for the user.")
                completion(cvUrls) // Return an empty dictionary
                return
            }

            print("Fetched CV IDs: \(cvIds)") // Debug log

            let group = DispatchGroup() // To manage multiple asynchronous calls
            
            for cvId in cvIds {
                group.enter()
                db.collection("CVs").document(cvId).getDocument { snapshot, error in
                    if let error = error {
                        print("Error fetching CV details for ID \(cvId): \(error.localizedDescription)")
                    } else if let data = snapshot?.data(), let cvUrl = data["cvUrl"] as? String {
                        cvUrls[cvId] = cvUrl
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                print("Fetched CV URLs: \(cvUrls)") // Debug log
                completion(cvUrls) // Return the fetched CVs
            }
        }
    }


    private func fetchCVDetails(cvIds: [String], completion: @escaping ([String: String]) -> Void) {
        let db = Firestore.firestore()
        var cvUrls: [String: String] = [:] // [cvId: cvUrl]
        let group = DispatchGroup()

        for cvId in cvIds {
            group.enter()
            db.collection("CVs").document(cvId).getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching CV details for ID \(cvId): \(error.localizedDescription)")
                } else if let data = snapshot?.data(), let cvUrl = data["cvUrl"] as? String {
                    cvUrls[cvId] = cvUrl
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(cvUrls)
        }
    }

    private func displayCVSelectionOptions(cvUrls: [String: String]) {
        let alert = UIAlertController(title: "Select CV", message: "Choose a CV to upload.", preferredStyle: .alert)

        for (cvId, cvUrl) in cvUrls {
            alert.addAction(UIAlertAction(title: "CV ID: \(cvId)", style: .default, handler: { _ in
                self.fetchedCVURL = cvUrl
                self.uploadCVbtn.setTitle("CV Selected", for: .normal)
                print("Selected CV URL: \(cvUrl)")
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToCompanyDetails",
               let destinationVC = segue.destination as? CompanyDetailsViewController {
                destinationVC.companyDetails = companyDetails
                destinationVC.jobposting = jobPosting
            }
        }
}
