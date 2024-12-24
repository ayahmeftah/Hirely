//
//  FirstSearchViewController.swift
//  Hirely
//
//  Created by Ayah Meftah on 22/12/2024.
//

import UIKit
import FirebaseFirestore

// ResultsVC: Displays search suggestions in a table view
class ResultsVC: UIViewController {
    
    var results: [String] = [] { // Results to display
        didSet {
            tableView.reloadData()
        }
    }
    
    var didSelectSuggestion: ((String) -> Void)? // Callback for selection
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Set up the table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ResultsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = results[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = results[indexPath.row]
        didSelectSuggestion?(selectedSuggestion) // Trigger the callback
    }
}


// FirstSearchViewController: Main screen with search functionality
class FirstSearchViewController: UIViewController, UISearchResultsUpdating {
    
    // Sample dataset for search suggestions
    let data = ["Software Engineer", "Data Scientist", "Product Manager", "UI/UX Designer", "Project Manager", "HR Specialist"]
    
    // Search controller with ResultsVC as the results controller
    let searchController = UISearchController(searchResultsController: ResultsVC())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search job here ..."
        searchController.searchBar.searchBarStyle = .minimal
        
        // Customize the search bar appearance
        let searchBar = searchController.searchBar
        let textField = searchBar.searchTextField
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        
        // Assign the search controller to the navigation item
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Add the searchBar to the view hierarchy
        view.addSubview(searchBar)
        
        // Disable autoresizing mask constraints
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints to searchBar
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            if let vc = searchController.searchResultsController as? ResultsVC {
                vc.results = [] // Clear results when no text is entered
            }
            return
        }
        
        // Filter the data based on the search text
        let filteredData = data.filter { $0.lowercased().contains(text.lowercased()) }
        
        // Update the ResultsVC with the filtered data
        if let vc = searchController.searchResultsController as? ResultsVC {
            vc.results = filteredData
        }
    }
}
