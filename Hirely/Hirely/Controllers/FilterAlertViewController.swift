//
//  FilterAlertViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 26/12/2024.
//

import UIKit

class FilterAlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet weak var optionsTableView: UITableView!
    
    @IBAction func didTapReset(_ sender: UIButton) {
        print("Reset button tapped")
        
        // Clear all selected filters
        selectedFilters.removeAll()
        
        // Reload the table view to reset the UI
        optionsTableView.reloadData()
    }
    
    
    @IBAction func didTapShowResults(_ sender: UIButton) {
        print("Show results button tapped")
        dismiss(animated: true)
    }
    
    var allFilters: [String: [String]] = [:] // All filters (categories and their options)
    var isMultiCategory: Bool = false // Flag to determine if multiple categories are displayed
    var selectedFilters: [String: String] = [:] // Track selected options per category
    var didSelectOption: ((String?) -> Void)? // Allow optional string

    var singleFilterTitle: String? // Header title for a single category
    var singleFilterOptions: [String] = [] // Options for a single category

    // Properties
    var filterTitle: String = "" // Header title
    var filterOptions: [String] = [] // Options for the filter
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the table view
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.register(UINib(nibName: "FilterOptionTableViewCell", bundle: nil), forCellReuseIdentifier: "filterOptionCell")
   
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isMultiCategory ? allFilters.keys.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMultiCategory {
            let category = Array(allFilters.keys)[section]
            return allFilters[category]?.count ?? 0
        } else {
            return singleFilterOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterOptionCell", for: indexPath) as? FilterOptionTableViewCell else {
            return UITableViewCell()
        }
        
        let option: String
        if isMultiCategory {
            let category = Array(allFilters.keys)[indexPath.section]
            option = allFilters[category]?[indexPath.row] ?? ""
            let isSelected = selectedFilters[category] == option
            cell.checkBoxBtn.isSelected = isSelected
            cell.updateCheckBoxImage(for: isSelected)
        } else {
            option = singleFilterOptions[indexPath.row]
            let isSelected = selectedFilters[singleFilterTitle ?? ""] == option
            cell.checkBoxBtn.isSelected = isSelected
            cell.updateCheckBoxImage(for: isSelected)
        }
        
        cell.filterInit(option)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.textColor = .black
        
        if isMultiCategory {
            headerLabel.text = Array(allFilters.keys)[section]
        } else {
            headerLabel.text = singleFilterTitle // Use the single category name
        }
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isMultiCategory else { return }
        
        let category = Array(allFilters.keys)[indexPath.section]
        let selectedOption = allFilters[category]?[indexPath.row] ?? ""
        selectedFilters[category] = selectedOption
        print("Selected \(selectedOption) in \(category)")
        
        // Optionally dismiss the alert or allow multiple selections
    }

    
}
