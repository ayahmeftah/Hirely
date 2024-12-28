//
//  JobDetailsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit

class JobDetailsViewController: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var companyImage: UIImageView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var postedDateLabel: UILabel!
    
    @IBOutlet weak var deadlineDateLabel: UILabel!
    
    @IBOutlet weak var contactEmailLabel: UILabel!
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var jobTypeLabel: UILabel!
    
    @IBOutlet weak var locationTypeLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var experienceLevelLabel: UILabel!
    
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    
    @IBOutlet weak var jobRequirementsLabel: UILabel!
    
    var jobPosting: JobPosting? //selected job Data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func addSkill(_ skill: String) {
        //Create horizontal stack view
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 4 //Space between tick and label
        hStack.alignment = .fill //Aligns tick and label vertically
        hStack.distribution = .fill

        // Create tick icon
        let tickImageView = UIImageView(image: UIImage(systemName: "checkmark.square.fill"))
        tickImageView.tintColor = .systemGreen
        tickImageView.translatesAutoresizingMaskIntoConstraints = false
        tickImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        tickImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        tickImageView.contentMode = .scaleAspectFit // Proper image scaling

        // Create skill label
        let skillLabel = UILabel()
        skillLabel.text = skill.isEmpty ? "No skill provided" : skill //Fallback text for empty skills
        skillLabel.font = UIFont.systemFont(ofSize: 16)
        skillLabel.numberOfLines = 0
        skillLabel.lineBreakMode = .byTruncatingTail
        skillLabel.translatesAutoresizingMaskIntoConstraints = false
        skillLabel.setContentHuggingPriority(.defaultLow, for: .horizontal) //Prevent expansion
        skillLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    

        //Add views to horizontal stack
        hStack.addArrangedSubview(tickImageView)
        hStack.addArrangedSubview(skillLabel)

        //Add horizontal stack to main vertical stack
        mainStackView.addArrangedSubview(hStack)
    
        mainStackView.isLayoutMarginsRelativeArrangement = false // Disable layout margins
        mainStackView.spacing = 4 //Set spacing between stack views
    }

    
    //initialize view with job data
        func setupUI() {
            guard let job = jobPosting else { return } // Ensure data is passed

            companyNameLabel.text = "Microsoft Corporation" //change later
            jobTitleLabel.text = job.jobTitle
            jobTypeLabel.text = job.jobType
            locationTypeLabel.text = job.locationType
            cityLabel.text = job.city
            experienceLevelLabel.text = job.experienceLevel
            jobDescriptionLabel.text = job.jobDescription
            jobRequirementsLabel.text = job.jobRequirements
            contactEmailLabel.text = job.contactEmail
            postedDateLabel.text = job.postedDate
            deadlineDateLabel.text = ("Deadline \(job.deadline)")
            postedDateLabel.text = ("Posted \(job.postedDate)")
            for skill in job.skills {
                addSkill(skill)
            }
            companyImage.image = UIImage(named: "microsoft") //change later
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToReviewApplications",
           let destinationVC = segue.destination as? ReviewApplicationsViewController {
            destinationVC.jobId = jobPosting?.docId // Pass the jobId to the destination VC
        }
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
