import UIKit
import UniformTypeIdentifiers
import FirebaseFirestore
import FirebaseAuth

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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add actions to buttons
        uploadCVbtn.addTarget(self, action: #selector(uploadCVTapped), for: .touchUpInside)
        applybtn.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)

        // Fetch job posting and company details
        fetchJobPostingData()
        fetchCompanyDetails(companyId: "RYINaYeqoq6WXBkdCOoK")

        // Set up UI with fetched data
        setUpUI()
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
        let jobId = "6zdg3JhufgPeqIoQgiPH" // Replace with the actual job document ID

        db.collection("jobPostings").document(jobId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching job posting: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.jobPosting = JobPosting(data: data)
                print("Fetched Job Posting: \(self.jobPosting!)") // Debug log
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
                print("Fetched Company Details: \(self.companyDetails!)") // Debug log
                DispatchQueue.main.async {
                    self.setUpUI()
                }
            } else {
                print("No company data found for ID: \(companyId)")
            }
        }
    }

    @objc func uploadCVTapped() {
        // Show options for CV
        let alert = UIAlertController(title: "Upload CV", message: "Choose an option to upload your CV.", preferredStyle: .actionSheet)

        // Option 1: Upload from Device
        alert.addAction(UIAlertAction(title: "Upload from Device", style: .default, handler: { _ in
            self.presentDocumentPicker(for: self.uploadCVbtn)
        }))

        // Option 2: Fetch from Hirely
        alert.addAction(UIAlertAction(title: "Fetch from Hirely", style: .default, handler: { _ in
            self.fetchFirstCVAndDisplay()
        }))

        // Cancel Option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // Present the action sheet
        present(alert, animated: true, completion: nil)
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
            "jobId": "6zdg3JhufgPeqIoQgiPH",
            "scheduledInterviewId": "",
            //adjust
            "userId": "61knRZkFlpe6SRmSo3Fr"
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
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            print("No user is signed in.")
            return nil
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
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

    func presentDocumentPicker(for button: UIButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.accessibilityHint = "CV"
        present(documentPicker, animated: true, completion: nil)
    }

    func fetchFirstCVAndDisplay() {
        let db = Firestore.firestore()
        db.collection("CVs").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching CVs: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.uploadCVbtn.setTitle("Upload Failed", for: .normal)
                }
                return
            }

            self.fetchedCVURL = nil // Clear any existing CV URL

            if let document = snapshot?.documents.first {
                let data = document.data()
                if let cvURL = data["cvUrl"] as? String {
                    self.fetchedCVURL = cvURL
                    DispatchQueue.main.async {
                        self.uploadCVbtn.setTitle("File Uploaded", for: .normal)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.uploadCVbtn.setTitle("No CV Found", for: .normal)
                }
            }
        }
    }
}
