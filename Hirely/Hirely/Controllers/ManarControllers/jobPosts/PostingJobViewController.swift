//
//  PostingJobViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 16/12/2024.
//

import UIKit
import FirebaseFirestore


class PostingJobViewController: UIViewController, UITextViewDelegate {
    
    var jobTitle: String?
    var jobType: String?
    var minSalary: Int?
    var maxSalary: Int?
    var jobLocationType: String?
    var jobCity:String?
    var experienceLevel:String?
    var jobDescription: String?
    
    @IBOutlet weak var jobReqTxt: UITextView!
    
    @IBOutlet weak var selectSkillsButton: UIButton!
    
    @IBOutlet weak var daedlineDatePicker: UIDatePicker!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    var selectedSkills: [String] = [] //save selected skills

    override func viewDidLoad() {
        super.viewDidLoad()
        jobReqTxt.delegate = self
        jobReqTxt.text = "1- "
    }
    
    
    @IBAction func selectSkillsTapped(_ sender: Any) {
        openSkillsSelection()
    }
    
    @IBAction func postJobButtonTapped(_ sender: Any) {
        if validateFields() {
            saveJobPostingToFirestore()

        }
    }
    
    // Function to validate all input fields
    func validateFields() -> Bool {
        // Check for empty required fields
        if jobTitle?.isEmpty ?? true {
            showValidationAlert(message: "Please provide a job title.")
            return false
        }
        
        if jobType?.isEmpty ?? true {
            showValidationAlert(message: "Please select a job type.")
            return false
        }
        
        if jobLocationType?.isEmpty ?? true {
            showValidationAlert(message: "Please select a job location type.")
            return false
        }
        
        if jobCity?.isEmpty ?? true {
            showValidationAlert(message: "Please provide a job city.")
            return false
        }
        
        if experienceLevel?.isEmpty ?? true {
            showValidationAlert(message: "Please select an experience level.")
            return false
        }
        
        if jobDescription?.isEmpty ?? true {
            showValidationAlert(message: "Please provide a job description.")
            return false
        }
        
        if jobReqTxt.text.isEmpty || jobReqTxt.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showValidationAlert(message: "Please provide job requirements.")
            return false
        }
        
        if selectedSkills.isEmpty {
            showValidationAlert(message: "Please select at least one skill.")
            return false
        }
        
        if minSalary == nil || maxSalary == nil || (minSalary ?? 0) <= 0 || (maxSalary ?? 0) <= 0 {
            showValidationAlert(message: "Please provide valid salary values.")
            return false
        }
        
        if minSalary ?? 0 > maxSalary ?? 0 {
            showValidationAlert(message: "Minimum salary cannot be greater than maximum salary.")
            return false
        }
        
        return true
    }

    // Function to display validation alert
    func showValidationAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    func openSkillsSelection() {
           let skillsVC = SkillsSelectionViewController()
           skillsVC.skills = [
            "AR/VR Development",
            "Academic Writing",
            "Accounting",
            "Adaptability",
            "Attention to Detail",
            "Basic Computer Skills",
            "Big Data Technologies",
            "Biology",
            "Blockchain Development",
            "Budgeting",
            "CI/CD Tools",
            "CSS",
            "Chemistry",
            "Cloud Computing",
            "Cloud Platforms",
            "Communication",
            "Community Organizing",
            "Community Outreach",
            "Competitive Analysis",
            "Computer Literacy",
            "Conflict Resolution",
            "Conservation Biology",
            "Cooking Methods",
            "Critical Thinking",
            "Cryptography",
            "Cultural Awareness",
            "Cultural Sensitivity",
            "Cultural Understanding",
            "Customer Service",
            "Cybersecurity",
            "Data Analysis",
            "Data Visualization",
            "Database Management",
            "Digital Humanities",
            "Emergency Response",
            "Environmental Policy",
            "Experimental Design",
            "Figurative Language",
            "Financial Management",
            "Fitness Assessment",
            "Flexibility",
            "Food Safety",
            "Game Development",
            "Git (Version Control)",
            "Grammar and Mechanics",
            "Health Education and Promotion",
            "Historical Research",
            "Historical Writing",
            "HTML/CSS",
            "Information Gathering",
            "Information Synthesis",
            "Intercultural Communication",
            "Internet of Things (IoT)",
            "Interpersonal Skills",
            "Interpretation and Explanation",
            "IT Project Management",
            "JavaScript",
            "Journalism",
            "Knife Skills",
            "Laboratory Techniques",
            "Language Teaching Skills",
            "Leadership",
            "Lifestyle Coaching",
            "Listening Comprehension",
            "Literary Analysis",
            "Literature Review",
            "Logistics and Planning",
            "Marketing and Sales",
            "Meeting Deadlines",
            "Menu Planning",
            "Microsoft Office",
            "Mindfulness",
            "Mobile Development",
            "Mountaineering Skills",
            "Multitasking",
            "Natural Language Processing",
            "Navigation and Orientation",
            "Negotiation",
            "Networking",
            "Networking & Security",
            "Networking Protocols",
            "Operations Management",
            "Opportunity Recognition",
            "Oral Communication",
            "Oral Presentation",
            "Organization and Structure",
            "Outdoor Skills",
            "Perspective-Taking",
            "Photography",
            "Physical Fitness",
            "Physics",
            "Planning",
            "Planning and Organization",
            "Presentation",
            "Problem-solving",
            "Program Development",
            "Program Planning",
            "Project Closure",
            "Project Management",
            "Prototyping",
            "Python",
            "Quality Management",
            "Reading Comprehension",
            "Relationship Building",
            "Reporting",
            "Research Skills",
            "Risk Assessment",
            "Robotics",
            "SQL",
            "Scientific Method",
            "Scientific Writing",
            "Security Tools",
            "Self-motivation",
            "Sentence Flow",
            "Sentence Structure",
            "Serverless Computing",
            "Software Development",
            "Software Installation",
            "Strategic Planning",
            "System Administration",
            "Technical Support",
            "Technical Writing",
            "Time Management",
            "Troubleshooting",
            "UI/UX Design",
            "Version Control (Git)"
        ]

           skillsVC.selectedSkills = selectedSkills
           
           // Callback to handle selected skills
           skillsVC.onSkillsSelected = { [weak self] selected in
               self?.selectedSkills = selected
               print("Selected Skills: \(selected)")
           }
           // Set presentation style to full screen
           skillsVC.modalPresentationStyle = .fullScreen
           
           present(skillsVC, animated: true, completion: nil)
       }
    
    
    //saving job post details in firestore
    func saveJobPostingToFirestore() {
        //saving all input fields data
        let jobTitle = jobTitle ?? ""
        let jobType = jobType ?? "Not Selected"
        let locationType = jobLocationType ?? "Not Selected"
        let experienceLevel = experienceLevel ?? "Not Selected"
        let city = jobCity ?? "Not Selected"
        let minSalary = minSalary
        let maxSalary = maxSalary
        let jobDescription = jobDescription ?? ""
        let jobRequirements = jobReqTxt.text ?? ""
        let deadline = daedlineDatePicker.date
        let contactEmail = emailTxt.text ?? ""
        let datePosted = Timestamp(date: Date()) //current data stamp
        
        //convert deadline date to firestore format
        let deadlineTimestamp = Timestamp(date: deadline)
        
        //database reference
        let db = Firestore.firestore()
        
        let jobCollection = db.collection("jobPostings")
        //generate a document reference with auto generated id
        let newDocRef = jobCollection.document()
        
        // Data to save
        let jobData: [String: Any] = [
            "docId": newDocRef.documentID,
            "jobTitle": jobTitle,
            "jobType": jobType,
            "locationType": locationType,
            "city": city,
            "experienceLevel": experienceLevel,
            "minimumSalary": minSalary ?? 0,
            "maximumSalary": maxSalary ?? 0,
            "jobDescription": jobDescription,
            "jobRequirements": jobRequirements,
            "skills": selectedSkills,
            "deadline": deadlineTimestamp,
            "contactEmail": contactEmail,
            "postedDate" : datePosted,
            "isFlagged": false,
            "isReported": false,
            "isHidden":false
        ]
        
        //saving the document
        newDocRef.setData(jobData) { error in
            if let error = error {
                print("Error saving job posting: \(error.localizedDescription)")
            } else {
                print("Job posting saved successfully with docId: \(newDocRef.documentID)")
                // Notify previous screen to refresh
            NotificationCenter.default.post(name: NSNotification.Name("JobPosted"), object: nil)
                self.showSuccessAlert()
            }
        }
    }
        
    //display message alert
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "The job posting has been added successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // UITextViewDelegate method to handle text changes
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // Check if the user pressed "Return"
            if text == "\n" {
                // Get the current text
                let currentText = textView.text ?? ""
                
                // Count the number of lines (job requirements) by splitting at newline
                let requirementsCount = currentText.split(separator: "\n").count

                // Append the next number with a dash
                textView.text += "\n\(requirementsCount + 1)- "

                // Prevent the default newline from being added
                return false
            }

            // Allow other text changes
            return true
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
