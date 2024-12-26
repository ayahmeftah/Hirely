//
//  FilterAlertViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 26/12/2024.
//

import UIKit

class FilterAlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
//    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var filterTitleLbl: UILabel!
    
    @IBOutlet weak var optionsTableView: UITableView!
    
    @IBAction func didTapReset(_ sender: UIButton) {
        print("Reset button tapped")
    }
    
    @IBAction func didTapShowResults(_ sender: UIButton) {
        print("Show results button tapped")
    }

    
    
    // Properties
    var filterTitle: String = "" // Passed dynamically
    private let filterOptions = ExperienceLevel.allCases // Enum cases

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title label to the name of the enum
        //filterTitleLbl.text = "Experience Level"
        
        // Set the filter title
        
        
        // Set up the table view
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.register(UINib(nibName: "FilterOptionTableViewCell", bundle: nil), forCellReuseIdentifier: "filterOptionCell")
        
//        // Adjust the table view's height
//        adjustTableViewHeight()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        // Ensure the table view height is adjusted after layout changes
//        adjustTableViewHeight()
//    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterOptionCell", for: indexPath) as? FilterOptionTableViewCell else {
            return UITableViewCell()
        }
        
        let filterOption = filterOptions[indexPath.row].rawValue
        cell.filterInit(filterOption)
        return cell
    }
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilter = filterOptions[indexPath.row]
        print("Selected filter: \(selectedFilter.rawValue)")
    }
    
    // MARK: - Dynamic Table View Height
//    private func adjustTableViewHeight() {
//        // Calculate the total height based on the number of rows and row height
//        let rowCount = tableView(optionsTableView, numberOfRowsInSection: 0)
//        let rowHeight = optionsTableView.rowHeight > 0 ? optionsTableView.rowHeight : 44.0
//        let totalHeight = CGFloat(rowCount) * rowHeight
//        
//        // Update the height constraint
//        tableViewHeightConstraint.constant = totalHeight
//        
//        // Layout the view again
//        view.layoutIfNeeded()
//    }
}

