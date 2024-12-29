//
//  InterviewDetailViewController.swift
//  Hirely
//
//  Created by BP-36-201-04 on 26/12/2024.
//

import UIKit
import FirebaseFirestore
import Cloudinary

class InterviewDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // TableView
    @IBOutlet weak var interviewTableView: UITableView!
    @IBOutlet weak var companyLogoImage: CLDUIImageView!
    @IBOutlet weak var companyNamelbl: UILabel!
    @IBOutlet weak var positionlbl: UILabel!
    
    // Passed data
    var interviewId = ""
    var jobCompanySelected = ""
    var jobPositionSelected = ""
    var companyLogo = ""
    
    // Cloudinary configuration
    let cloudName: String = "drkt3vace"
    let uploadPreset: String = "unsigned_upload"
    var cloudinary: CLDCloudinary!
    
    // Initialize the data
    var icontitles = ["Date", "Time", "Location", "Notes"]
    var interviewInfo: [String] = ["Loading...", "Loading...", "Loading...", "Loading..."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interviewTableView.backgroundColor = .clear
        
        // Initialize Cloudinary
        initCloudinary()
        
        // Update labels with passed data
        companyNamelbl.text = jobCompanySelected
        positionlbl.text = jobPositionSelected
        
        interviewTableView.delegate = self
        interviewTableView.dataSource = self
        
        // Set the company logo image
        if !companyLogo.isEmpty {
            let companyLogoURL = companyLogo
            companyLogoImage.cldSetImage(companyLogoURL, cloudinary: cloudinary)
        }
        
        // Fetch interview information
        fetchInterviewInfo()
                
    }
    
    func initCloudinary() {
        let config = CLDConfiguration(cloudName: cloudName, secure: true)
        cloudinary = CLDCloudinary(configuration: config)
    }
    
    func fetchInterviewInfo() {
        let db = Firestore.firestore()

        // Fetch the interview details based on the `interviewId`
        db.collection("scheduledInterviews").document(interviewId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching interview data: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found for interview ID: \(self.interviewId)")
                return
            }

            // Parse the data
            let date = (data["date"] as? Timestamp)?.dateValue().formatted(date: .numeric, time: .omitted) ?? "No Date"
            let time = (data["time"] as? Timestamp)?.dateValue().formatted(date: .omitted, time: .shortened) ?? "No Time"
            let location = data["location"] as? String ?? "No Location"
            let notes = data["notes"] as? String ?? "No Notes"
            
            // Update the `interviewInfo` array
            self.interviewInfo = [date, time, location, notes]
            
            // Reload the table view on the main thread
            DispatchQueue.main.async {
                self.interviewTableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icontitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "interviewInfoTableViewCell", for: indexPath) as? InterviewInfoTableViewCell else {
            return UITableViewCell()
        }

        // Set the title and info
        cell.titleLabel.text = icontitles[indexPath.row]
        cell.infoLabel.text = indexPath.row < interviewInfo.count ? interviewInfo[indexPath.row] : "No Data"

        // Set the icon
        switch icontitles[indexPath.row] {
        case "Date":
            cell.iconImageView.image = UIImage(systemName: "calendar")
        case "Time":
            cell.iconImageView.image = UIImage(systemName: "clock")
        case "Location":
            cell.iconImageView.image = UIImage(systemName: "location")
        case "Notes":
            cell.iconImageView.image = UIImage(systemName: "note.text")
        default:
            cell.iconImageView.image = nil
        }

        return cell
    }
}
