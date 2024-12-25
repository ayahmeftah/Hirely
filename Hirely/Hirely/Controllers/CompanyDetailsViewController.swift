//
//  CompanyDetailsViewController.swift
//  Hirely
//
//  Created by BP-needchange on 25/12/2024.
//

import UIKit
import FirebaseFirestore

class CompanyDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var companyNamelbl: UILabel!
    
    @IBOutlet weak var companyLogoImg: UIImageView!
    
    @IBOutlet weak var companyEmaillbl: UILabel!
    
    @IBOutlet weak var companyDetailsTableView: UITableView!
    var companyDetails: CompanyDetails?
    var jobposting: JobPosting?
    
    var titles = ["Company Overview", "Our Specialization", "Growth & Development", "Benefit & Culture"]

    // Replace static info with dynamic data
    var info: [String] = [] // This will hold the values fetched from Firestore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view delegate and data source
        companyDetailsTableView.delegate = self
        companyDetailsTableView.dataSource = self

        // Set automatic dimensioning for multi-line cells
        companyDetailsTableView.estimatedRowHeight = 60
        companyDetailsTableView.rowHeight = UITableView.automaticDimension
        
        companyDetailsTableView.backgroundColor = .clear
        
        // Fetch company details from Firestore
        setupUI()
        fetchCompanyDetails()
    }
    
    func setupUI() {
        guard let comp = companyDetails else { return }
        guard let job = jobposting else{return}// Ensure data is passed
        companyNamelbl.text = comp.name
        companyEmaillbl.text = job.contactEmail
    }

    // Fetch data from Firestore's "companies" collection
    func fetchCompanyDetails() {
        let db = Firestore.firestore()
        
        db.collection("companies").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching companies: \(error.localizedDescription)")
                return
            }
            
            // Parse fetched data into CompanyDetails struct
            if let documents = snapshot?.documents {
                if let firstCompany = documents.first { // Assuming you want to display the first company
                    let data = firstCompany.data()
                    let company = CompanyDetails(data: data)
                    
                    // Populate info array with values from the fetched company
                    self.info = [
                        company.overview,
                        company.specialization,
                        company.growth,
                        company.benefit
                    ]
                    
                    // Reload the table view on the main thread
                    DispatchQueue.main.async {
                        self.companyDetailsTableView.reloadData()
                    }
                }
            }
        }
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
