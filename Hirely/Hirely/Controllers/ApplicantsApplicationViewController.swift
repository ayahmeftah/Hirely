//
//  ApplicantsApplicationViewController.swift
//  Hirely
//
//  Created by BP-36-201-04 on 26/12/2024.
//

import UIKit

class ApplicantsApplicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var pageSub: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // Array for the position, company, status
    let companyNames = ["Google", "Microsoft", "Bahrain National Of Bank", "Apple Inc", "Amazon"]
    let position = ["Software Engineer", "Data Analyst", "Full-Stack Developer", "Application Developer", "Accountant"]
    let applicationStatus = ["Rejected", "Hired", "New", "Scheduled Interview", "Reviewed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        // Register the custom table view cell
        let nib = UINib(nibName: "CustomCellForApplicantsApplicationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "appliedJobsCell")
        
        // Update the subtitle label with styled text
        updatePageSubLabel()
    }
    
    func updatePageSubLabel() {
        let applicationsCount = companyNames.count
        let text = "Tracking \(applicationsCount) Applications"
        let attributedString = NSMutableAttributedString(string: text)
        
        // Find the range of the number
        if let numberRange = text.range(of: "\(applicationsCount)") {
            let nsRange = NSRange(numberRange, in: text)
            
            // Add attributes to the number
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: nsRange) // Make it orange
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: nsRange) // Make it bold
        }
        
        // Assign the styled text to the subtitle label
        pageSub.attributedText = attributedString
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "appliedJobsCell", for: indexPath) as? CustomCellForApplicantsApplicationTableViewCell else {
            return UITableViewCell()
        }
        
        // Pass info to the custom cell
        cell.appliedInit(position[indexPath.row], companyNames[indexPath.row], applicationStatus[indexPath.row])
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.parentViewController = self
        return cell
    }
    
    
    // Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToJobDetail",
           let cell = sender as? CustomCellForApplicantsApplicationTableViewCell,
           let indexPath = self.tableView.indexPath(for: cell),
           let destinationVC = segue.destination as? ApplicationJobDetailsViewController {
            
            // Pass data to the destination view controller
            //Ishould get the jobposted ID
            destinationVC.jobPosition = position[indexPath.row]
            destinationVC.jobCompany = companyNames[indexPath.row]
            destinationVC.jobStatus = applicationStatus[indexPath.row]
        }
    }

}
