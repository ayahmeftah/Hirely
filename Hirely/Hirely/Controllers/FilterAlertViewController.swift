//
//  FilterAlertViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 26/12/2024.
//

import UIKit
import FirebaseFirestore

protocol FilterAlertDelegate: AnyObject {
    func didApplyFilters(_ filters: [String: String])
    func didResetFilters()
}


class FilterAlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: FilterAlertDelegate?
    
    
    @IBOutlet weak var optionsTableView: UITableView!
    
    @IBAction func didTapReset(_ sender: UIButton) {
        print("Reset button tapped")
        selectedFilters.removeAll() // Clear local filters
        delegate?.didResetFilters() // Notify parent to reset filters
        dismiss(animated: true, completion: nil)
    }


    
    @IBAction func didTapShowResults(_ sender: UIButton) {
        print("Show results button tapped")
        delegate?.didApplyFilters(selectedFilters) // Pass filters back to parent
        dismiss(animated: true, completion: nil)
    }



    
    var allFilters: [String: [String]] = [:] // All filters (categories and their options)
    var isMultiCategory: Bool = false // Flag to determine if multiple categories are displayed
    var selectedFilters: [String: String] = [:] // Track selected options per category
    var didSelectOption: ((String) -> Void)? // Callback for selected option
    
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
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterOptionCell", for: indexPath) as? FilterOptionTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let option: String
//        if isMultiCategory {
//            let category = Array(allFilters.keys)[indexPath.section]
//            option = allFilters[category]?[indexPath.row] ?? ""
//            let isSelected = selectedFilters[category] == option
//            cell.checkBoxBtn.isSelected = isSelected
//            cell.updateCheckBoxImage(for: isSelected)
//        } else {
//            option = singleFilterOptions[indexPath.row]
//            let isSelected = selectedFilters[singleFilterTitle ?? ""] == option
//            cell.checkBoxBtn.isSelected = isSelected
//            cell.updateCheckBoxImage(for: isSelected)
//        }
//        
//        cell.filterInit(option)
//        return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterOptionCell", for: indexPath) as? FilterOptionTableViewCell else {
            return UITableViewCell()
        }
        
        let option: String
        if isMultiCategory {
            let category = Array(allFilters.keys)[indexPath.section]
            option = allFilters[category]?[indexPath.row] ?? ""
        } else {
            option = singleFilterOptions[indexPath.row]
        }
        
        cell.filterInit(option)
        cell.didSelectOption = { [weak self] selectedOption, isSelected in
            guard let self = self else { return }
            
            if isMultiCategory {
                let category = Array(self.allFilters.keys)[indexPath.section]
                if isSelected {
                    self.selectedFilters[category] = selectedOption // Add to selectedFilters
                } else {
                    self.selectedFilters.removeValue(forKey: category) // Remove from selectedFilters
                }
            } else {
                if isSelected {
                    self.selectedFilters[self.singleFilterTitle ?? ""] = selectedOption // Add to selectedFilters
                } else {
                    self.selectedFilters.removeValue(forKey: self.singleFilterTitle ?? "") // Remove from selectedFilters
                }
            }
        }
        
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard isMultiCategory else { return }
//        
//        let category = Array(allFilters.keys)[indexPath.section]
//        let selectedOption = allFilters[category]?[indexPath.row] ?? ""
//        selectedFilters[category] = selectedOption
//        print("Selected \(selectedOption) in \(category)")
//        
//        // Optionally dismiss the alert or allow multiple selections
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption: String
        if isMultiCategory {
            let category = Array(allFilters.keys)[indexPath.section]
            selectedOption = allFilters[category]?[indexPath.row] ?? ""
            selectedFilters[category] = selectedOption
            print("Selected \(selectedOption) for category \(category)")
        } else {
            selectedOption = singleFilterOptions[indexPath.row]
            selectedFilters[singleFilterTitle ?? ""] = selectedOption
            print("Selected \(selectedOption) for category \(singleFilterTitle ?? "")")
        }
        
        tableView.reloadData() // Update the UI to reflect selection
    }


    
}
