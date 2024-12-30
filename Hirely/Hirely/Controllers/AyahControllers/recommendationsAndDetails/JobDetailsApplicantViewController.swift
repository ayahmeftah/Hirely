//
//  JobDetailsApplicantViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 28/12/2024.
//

import UIKit

class JobDetailsApplicantViewController: UIViewController {
    @IBOutlet weak var companyImage: UIImageView!
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var contactEmailLabel: UILabel!
    
    @IBOutlet weak var postedDateLabel: UILabel!
    
    @IBOutlet weak var deadlineDateLabel: UILabel!
    
    @IBOutlet weak var jobTypeLabel: UILabel!
    
    @IBOutlet weak var locationTypeLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    
    @IBOutlet weak var jobRequirementsLabel: UILabel!
    @IBOutlet weak var experienceLevelLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var reportBtn: UIButton!
    
    @IBOutlet weak var SaveBtn: UIButton!
    
    // Mock user skills for matching
    var userSoftSkills: [String] = ["Teamwork", "Communication"]
    var userTechnicalSkills: [String] = ["Swift", "Xcode", "SQL"]
    
    // To track the current state of the button
    private var isReported = false
//    private var isSaved = false
    var jobPosting: JobPosting? // Selected job data
    
    @IBAction func didTapApply(_ sender: Any) {
    }
    
    @IBAction func didTapReport(_ sender: Any) {
        // Toggle the reported state
        isReported.toggle()
        
        // Update the button's appearance based on the new state
        updateReportButtonStyle()
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        // Toggle the reported state
//        isSaved.toggle()
        
        // Update the button's appearance based on the new state
//        updateSaveButtonStyle()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInitialReportButtonStyle()
        setupInitialSaveButtonStyle()
    }
    
    private func displaySkills(_ skills: [String]) {
        var matchingSkillsCount = 0
        
        // Remove existing views in the stack view
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Create and add the match label at the top
        let matchLabel = UILabel()
        matchLabel.textAlignment = .center
        matchLabel.font = UIFont.systemFont(ofSize: 14) // Smaller font
        matchLabel.textColor = .white
        matchLabel.layer.cornerRadius = 8
        matchLabel.layer.masksToBounds = true
        matchLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true // Adjusted height
        
        // Check each skill
        for skill in skills {
            if userSoftSkills.contains(skill) || userTechnicalSkills.contains(skill) {
                matchingSkillsCount += 1
                addSkill(skill, isMatched: true) // Matched skill
            } else {
                addSkill(skill, isMatched: false) // Unmatched skill
            }
        }
        
        // Update match label text and background color
        let totalSkills = skills.count
        matchLabel.text = "\(matchingSkillsCount) of \(totalSkills) skills match"
        
        // Determine label background color
        if matchingSkillsCount == totalSkills {
            matchLabel.backgroundColor = .systemGreen // All skills match
        } else if matchingSkillsCount == 0 {
            matchLabel.backgroundColor = .systemGray // No skills match
        } else if Double(matchingSkillsCount) / Double(totalSkills) >= 0.5 {
            matchLabel.backgroundColor = .systemOrange // Close match (>= 50%)
        } else {
            matchLabel.backgroundColor = .systemYellow // Partial match (< 50% but > 0)
        }
        
        // Add the match label to the stack view at the top
        mainStackView.insertArrangedSubview(matchLabel, at: 0)
    }


    
    private func addSkill(_ skill: String, isMatched: Bool) {
        // Create horizontal stack view
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 8 // Space between tick and label
        hStack.alignment = .center // Aligns tick and label vertically
        hStack.distribution = .fillProportionally
        
        // Create tick icon
        let tickImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        tickImageView.tintColor = isMatched ? .systemGreen : .systemGray
        tickImageView.translatesAutoresizingMaskIntoConstraints = false
        tickImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true // Fixed size
        tickImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true // Fixed size
        tickImageView.contentMode = .scaleAspectFit // Proper image scaling
        
        // Create skill label
        let skillLabel = UILabel()
        skillLabel.text = skill
        skillLabel.font = UIFont.systemFont(ofSize: 16) // Adjust font size
        skillLabel.numberOfLines = 1 // Single line
        skillLabel.lineBreakMode = .byTruncatingTail // Handles long text
        skillLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to horizontal stack
        hStack.addArrangedSubview(tickImageView)
        hStack.addArrangedSubview(skillLabel)
        
        // Add horizontal stack to main vertical stack
        mainStackView.addArrangedSubview(hStack)
    }
    
    private func setupInitialReportButtonStyle() {
        reportBtn.setTitle("Report", for: .normal)
        reportBtn.setTitleColor(.red, for: .normal)
        reportBtn.backgroundColor = .white
        reportBtn.layer.borderColor = UIColor.red.cgColor
        reportBtn.layer.borderWidth = 2.0
        reportBtn.layer.cornerRadius = 30
    }
    
    private func updateReportButtonStyle() {
        if isReported {
            // Change to reported state
            reportBtn.setTitle("Unreport", for: .normal)
            reportBtn.setTitleColor(.white, for: .normal)
            reportBtn.backgroundColor = .red
            reportBtn.layer.cornerRadius = 30
        } else {
            // Revert to the default state
            reportBtn.setTitle("Report", for: .normal)
            reportBtn.setTitleColor(.red, for: .normal)
            reportBtn.backgroundColor = .white
            reportBtn.layer.cornerRadius = 30
        }
    }
    
    private func setupInitialSaveButtonStyle() {
        SaveBtn.setTitle("Save", for: .normal)
        SaveBtn.setTitleColor(.systemGreen, for: .normal)
        SaveBtn.backgroundColor = .white
        SaveBtn.layer.borderColor = UIColor.systemGreen.cgColor
        SaveBtn.layer.borderWidth = 2.0
        SaveBtn.layer.cornerRadius = 30
    }
    
//    private func updateSaveButtonStyle() {
//        if isSaved {
//            // Change to reported state
//            SaveBtn.setTitle("Unsave", for: .normal)
//            SaveBtn.setTitleColor(.white, for: .normal)
//            SaveBtn.backgroundColor = .systemGreen
//            SaveBtn.layer.cornerRadius = 30
//        } else {
//            // Revert to the default state
//            SaveBtn.setTitle("Save", for: .normal)
//            SaveBtn.setTitleColor(.systemGreen, for: .normal)
//            SaveBtn.backgroundColor = .white
//            SaveBtn.layer.cornerRadius = 30
//        }
//    }
//    
    
    //initialize view with job data
    func setupUI() {
        
//        companyNameLabel.text = "microsoft"
//        jobTitleLabel.text = job.jobTitle
//        jobTypeLabel.text = job.jobType
//        locationTypeLabel.text = job.locationType
//        cityLabel.text = job.city
//        experienceLevelLabel.text = job.experienceLevel
//        jobDescriptionLabel.text = job.jobDescription
//        jobRequirementsLabel.text = job.jobRequirements
//        contactEmailLabel.text = job.contactEmail
//        postedDateLabel.text = job.postedDate
//        deadlineDateLabel.text = ("Deadline \(job.deadline)")
//        postedDateLabel.text = ("Posted \(job.postedDate)")
//        for skill in job.skills {
//            addSkill(skill)
//        }
//        companyImage.image = UIImage(named: "microsoft")
        guard let job = jobPosting else { return } // Ensure job data is passed
        
        // Populate job details
        companyNameLabel.text = "Microsoft"
        jobTitleLabel.text = job.jobTitle
        jobTypeLabel.text = job.jobType
        locationTypeLabel.text = job.locationType
        cityLabel.text = job.city
        experienceLevelLabel.text = job.experienceLevel
        jobDescriptionLabel.text = job.jobDescription
        jobRequirementsLabel.text = job.jobRequirements
        contactEmailLabel.text = job.contactEmail
        postedDateLabel.text = job.postedDate
        deadlineDateLabel.text = "Deadline \(job.deadline)"
        companyImage.image = UIImage(named: "microsoft")
        
        // Add skills with matching logic
        displaySkills(job.skills)
    }

}
