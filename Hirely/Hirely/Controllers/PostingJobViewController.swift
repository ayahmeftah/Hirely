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
        saveJobPostingToFirestore()
    }
    
    func openSkillsSelection() {
           let skillsVC = SkillsSelectionViewController()
           skillsVC.skills = ["Active Listening",
                                                "Adaptability",
                                                "Analytical Skills",
                                                "Attention to Detail",
                                                "Basic Computer Skills",
                                                "Budget Management",
                                                "Client Relations",
                                                "Cloud Computing",
                                                "Collaboration",
                                                "Communication",
                                                "Conflict Resolution",
                                                "Critical Thinking",
                                                "Customer Service",
                                                "Cybersecurity",
                                                "Data Analysis",
                                                "Data Entry",
                                                "Decision Making",
                                                "Emotional Intelligence",
                                                "File Management",
                                                "HTML/CSS",
                                                "Interpersonal Skills",
                                                "IT Project Management",
                                                "JavaScript",
                                                "Leadership",
                                                "Mathematical Skills",
                                                "Microsoft Office",
                                                "Multitasking",
                                                "Negotiation",
                                                "Networking",
                                                "Organizational Skills",
                                                "Patient Care",
                                                "Planning",
                                                "Presentation Skills",
                                                "Problem-solving",
                                                "Project Management",
                                                "Public Speaking",
                                                "Python",
                                                "Record Keeping",
                                                "Reporting",
                                                "Research Skills",
                                                "Risk Assessment",
                                                "Scheduling",
                                                "Software Installation",
                                                "Strategic Thinking",
                                                "System Administration",
                                                "Teamwork",
                                                "Technical Support",
                                                "Technical Writing",
                                                "Time Management",
                                                "Troubleshooting",
                                                "Typing Skills",
                                                "UI/UX Design",
                                                "Version Control (Git)",
                                                "Work Ethics",
                                                "Workflow Optimization",
                                                "Written Communication"]

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
        let datePosted = Timestamp(date: Date()) //get current date
        
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
            "postedDate" : datePosted
        ]
        
        //saving the document
        newDocRef.setData(jobData) { error in
            if let error = error {
                print("Error saving job posting: \(error.localizedDescription)")
            } else {
                print("Job posting saved successfully with docId: \(newDocRef.documentID)")
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
