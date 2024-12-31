//
//  saveJobChangesViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 16/12/2024.
//

import UIKit
import FirebaseFirestore

class saveJobChangesViewController: UIViewController, UITextViewDelegate{
    var jobTitle: String?
    var jobType: String?
    var minSalary: Int?
    var maxSalary: Int?
    var jobLocationType: String?
    var jobCity:String?
    var experienceLevel:String?
    var jobDescription: String?

    
    @IBOutlet weak var jobRequirementsTextView: UITextView!
    
    @IBOutlet weak var skillsButton: UIButton!
    
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    
    @IBOutlet weak var contactEmailTextField: UITextField!
    
    var jobPosting: JobPosting? // job data passed from previous screen
    var selectedSkills: [String] = []



    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()
        jobRequirementsTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func openSkillsSelection() {
           let skillsVC = SkillsSelectionViewController()
           skillsVC.skills =  [
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
    
    @IBAction func selectSkillsTapped(_ sender: Any) {
        openSkillsSelection()
    }
 
    func populateFields() {
        guard let job = jobPosting else { return }

        jobRequirementsTextView.text = job.jobRequirements
        contactEmailTextField.text = job.contactEmail
        selectedSkills = job.skills

        if let deadline = dateFromString(job.deadline) {
            deadlineDatePicker.date = deadline
        }
        }
    
    func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter.date(from: dateString)
    }
    
    @IBAction func saveChangesTapped(_ sender: Any) {
        guard let job = jobPosting else { return }
            
        //convert deadline date to a firestore timestamp
        let deadlineTimestamp = Timestamp(date: deadlineDatePicker.date)
        
            //get updated data from the fields
            let updatedJobData: [String: Any] = [
                "jobTitle": jobTitle ?? job.jobTitle, //use the passed jobTitle or existing
                "jobType": jobType ?? job.jobType,
                "locationType": jobLocationType ?? job.locationType,
                "city": jobCity ?? job.city,
                "experienceLevel": experienceLevel ?? job.experienceLevel,
                "minimumSalary": minSalary ?? job.minSalary,
                "maximumSalary": maxSalary ?? job.maxSalary,
                "jobDescription": jobDescription ?? job.jobDescription,
                "jobRequirements": jobRequirementsTextView.text ?? job.jobRequirements,
                "skills": selectedSkills,
                "contactEmail": contactEmailTextField.text ?? job.contactEmail,
                "deadline": deadlineTimestamp
            ]

            
            let db = Firestore.firestore()
            db.collection("jobPostings").document(job.docId).updateData(updatedJobData) { error in
                if let error = error {
                    print("Error updating job post: \(error.localizedDescription)")
                } else {
                    print("Job post updated successfully!")
                    self.showSuccessAlert()
                }
            }
        }



        // Show Success Alert
        func showSuccessAlert() {
            let alert = UIAlertController(title: "Success", message: "Job posting updated successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true) // Go back to main screen
            })
            present(alert, animated: true, completion: nil)
        }
    
    // UITextViewDelegate method to handle text changes
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Check if the user pressed "Return"
        if text == "\n" {
            // Get the current text
            let currentText = textView.text ?? ""
            
            // Split the text into lines
            let lines = currentText.split(separator: "\n")
            
            // Check if the last line already contains a number
            if let lastLine = lines.last, let lastNumber = extractLastNumber(from: String(lastLine)) {
                // Append the next number with a dash
                textView.text += "\n\(lastNumber + 1)- "
            } else {
                // If no valid numbering exists, start fresh with 1
                textView.text += "\n1- "
            }

            // Prevent the default newline from being added
            return false
        }

        // Allow other text changes
        return true
    }

    // Helper function to extract the last number from a string line
    func extractLastNumber(from line: String) -> Int? {
        let components = line.split(separator: "-").map { $0.trimmingCharacters(in: .whitespaces) }
        if let firstComponent = components.first, let number = Int(firstComponent) {
            return number
        }
        return nil
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
