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
    
    // To track the current state of the button
    private var isReported = false
    private var isSaved = false
    
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
        isSaved.toggle()
        
        // Update the button's appearance based on the new state
        updateSaveButtonStyle()
    }
    
    
    var jobPosting: JobPosting? //selected job Data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInitialReportButtonStyle()
        setupInitialSaveButtonStyle()
    }
    
    func addSkill(_ skill: String) {
        // Create horizontal stack view
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 4 // Space between tick and label
        hStack.alignment = .center // Aligns tick and label vertically
        hStack.distribution = .fillProportionally
        
        // Create tick icon
        let tickImageView = UIImageView(image: UIImage(systemName: "checkmark.square.fill"))
        tickImageView.tintColor = .systemGreen
        tickImageView.translatesAutoresizingMaskIntoConstraints = false
        tickImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true // Fixed size
        tickImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true // Fixed size
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
    
    private func updateSaveButtonStyle() {
        if isSaved {
            // Change to reported state
            SaveBtn.setTitle("Unsave", for: .normal)
            SaveBtn.setTitleColor(.white, for: .normal)
            SaveBtn.backgroundColor = .systemGreen
            SaveBtn.layer.cornerRadius = 30
        } else {
            // Revert to the default state
            SaveBtn.setTitle("Save", for: .normal)
            SaveBtn.setTitleColor(.systemGreen, for: .normal)
            SaveBtn.backgroundColor = .white
            SaveBtn.layer.cornerRadius = 30
        }
    }
    
    
    //initialize view with job data
    func setupUI() {
        guard let job = jobPosting else { return } // Ensure data is passed
        
        companyNameLabel.text = "Google Inc"
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
        companyImage.image = UIImage(named: "google")
    }

}
