//
//  CompanyDetailsViewController.swift
//  Hirely
//
//  Created by BP-needchange on 25/12/2024.
//

import UIKit
import FirebaseFirestore
import Cloudinary

class CompanyDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var companyNamelbl: UILabel!
    
    @IBOutlet weak var companyLogoimg: CLDUIImageView!
    
    @IBOutlet weak var companyEmaillbl: UILabel!
    
    @IBOutlet weak var companyDetailsTableView: UITableView!
    
    //passed data
    var companyDetails: CompanyDetails?
    var jobposting: JobPosting?
    
    var titles = ["Company Overview", "Our Specialization", "Growth & Development", "Benefit & Culture"]
    
    // Cloudinary configuration
    let cloudName: String = "drkt3vace"
    let uploadPreset: String = "unsigned_upload"
    var cloudinary: CLDCloudinary!
    
    
    var info: [String] = [] // This will hold the values fetched from Firestore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Cloudinary
        initCloudinary()
        
            //            if let companyDetails = companyDetails {
            
            //                print("Received Company Details: \(companyDetails)")
            //                // Use companyDetails as needed
            //            }
            //
            //            if let jobPosting = jobposting {
            //                print("Received Job Posting: \(jobPosting)")
            //                // Use jobPosting as needed
            //            }
            
            
            
            // Set up table view delegate and data source
            companyDetailsTableView.delegate = self
            companyDetailsTableView.dataSource = self
            
            // Set automatic dimensioning for multi-line cells
            companyDetailsTableView.estimatedRowHeight = 60
            companyDetailsTableView.rowHeight = UITableView.automaticDimension
            
            companyDetailsTableView.backgroundColor = .clear
            
            // Fetch company details from Firestore
            
            setupUI()
        }
        
        func initCloudinary() {
            let config = CLDConfiguration(cloudName: cloudName, secure: true)
            cloudinary = CLDCloudinary(configuration: config)
        }
        
        func setupUI() {
            guard let comp = companyDetails else { return }
            guard let job = jobposting else{return}
            companyNamelbl.text = comp.name
            companyEmaillbl.text = job.contactEmail
            
            // Populate the info array
            info = [
                comp.overview ,
                comp.specialization ,
                comp.growth ,
                comp.benefit
            ]
            
            // Set the company logo image
            let companyLogo = companyDetails?.companyPicture
            companyLogoimg.cldSetImage(companyLogo!, cloudinary: cloudinary)
            
            
            // Reload the table view to display updated info
            companyDetailsTableView.reloadData()
            
        }
        
        
        // MARK: - UITableViewDataSource Methods
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return titles.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Create a cell with .subtitle style
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CompanyDetailsCell")
            
            // Set the title and subtitle
            cell.textLabel?.text = titles[indexPath.row]
            cell.detailTextLabel?.text = indexPath.row < info.count ? info[indexPath.row] : "No Data"
            
            // Allow multi-line detail text
            cell.detailTextLabel?.numberOfLines = 0 // Unlimited lines
            
            // Customize appearance
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.detailTextLabel?.textColor = .black
            cell.textLabel?.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.3, alpha: 1.0) // Dark Blue
            cell.selectionStyle = .none
            
            return cell
        }
        
        // MARK: - UITableViewDelegate Methods
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Selected: \(titles[indexPath.row]) - \(indexPath.row < info.count ? info[indexPath.row] : "No Data")")
        }
        
    
}
