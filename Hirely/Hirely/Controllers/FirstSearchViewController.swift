//
//  FirstSearchViewController.swift
//  Hirely
//
//  Created by Ayah Meftah on 22/12/2024.
//

import UIKit
import FirebaseFirestore

class FirstSearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate{
    
    // Sample dataset for search suggestions
    //    let data = ["Software Engineer", "Data Scientist", "Product Manager", "UI/UX Designer", "Project Manager", "HR Specialist"]
    
    
    let filterAlertService = FilterAlertService()
    
    @IBAction func didTapCity(_ sender: Any) {
        presentFilterAlert(for: City.self, title: "City")
    }
    
    @IBAction func didTapJobType(_ sender: Any) {
        presentFilterAlert(for: JobType.self, title: "Job Type")
    }
    
    @IBAction func didTapLocationType(_ sender: Any) {
        presentFilterAlert(for: LocationType.self, title: "Location Type")
    }
    
    @IBAction func didTapBtntry(_ sender: Any) {
        presentFilterAlert(for: ExperienceLevel.self, title: "Experience Level")
    }
//    
//    @IBAction func didTapBtntry(_ sender: Any) {
//        // Use FilterAlertService to present the FilterAlertViewController
//        let filterService = FilterAlertService()
//        let filterAlertVC = filterService.filterAlert()
//        
//        // Present the FilterAlertViewController
//        filterAlertVC.modalPresentationStyle = .overCurrentContext
//        filterAlertVC.modalTransitionStyle = .crossDissolve
//        self.present(filterAlertVC, animated: true, completion: nil)
//    }
    
    private func presentFilterAlert<T: RawRepresentable & CaseIterable>(for filterEnum: T.Type, title: String) where T.RawValue == String {
        let filterAlertVC = filterAlertService.filterAlert(with: filterEnum, title: title)
        filterAlertVC.modalPresentationStyle = .overCurrentContext
        filterAlertVC.modalTransitionStyle = .crossDissolve
        self.present(filterAlertVC, animated: true, completion: nil)
    }
    
    // Firestore reference
    let db = Firestore.firestore()
    var allJobTitles: [String] = [] // Store all job titles locally
    
    // Search controller with ResultsVC as the results controller
    var searchController = UISearchController(searchResultsController: SuggestionsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        // Preload all job titles from Firestore
        preloadJobTitles()
    }
    
    func setupSearchController(){
        // Configure the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search job here ..."
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        
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

    
    func preloadJobTitles() {
        db.collection("jobPostings").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching job titles: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Store all job titles locally
            self.allJobTitles = documents.compactMap { $0.data()["jobTitle"] as? String }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
            if let vc = searchController.searchResultsController as? SuggestionsViewController {
                vc.results = [] // Clear results when no text is entered
            }
            return
        }
        
        let db = Firestore.firestore()
        
        // Fetch all job titles once (or limit the query if dataset is large)
        db.collection("jobPostings")
            .getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching job titles: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Extract job titles from Firestore documents
                let allJobTitles = documents.compactMap { $0.data()["jobTitle"] as? String }
                
                // Filter job titles to include substring matches
                let filteredTitles = allJobTitles.filter { $0.lowercased().contains(searchText) }
                
                // Update ResultsVC with filtered titles
                if let vc = searchController.searchResultsController as? SuggestionsViewController {
                    vc.results = filteredTitles
                    vc.didSelectSuggestion = { [weak self] selectedSuggestion in
                        self?.navigateToResultsPage(with: selectedSuggestion)
                    }
                }
            }
    }
    
    func navigateToResultsPage(with query: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultsVC = storyboard.instantiateViewController(withIdentifier: "ResultsPageViewController") as? ResultsPageViewController {
            resultsVC.searchQuery = query // Pass the search query
            navigationController?.pushViewController(resultsVC, animated: true)
        }
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            navigateToResultsPage(with: searchText) // Navigate to results page with search text
            searchBar.resignFirstResponder() // Dismiss the keyboard
        }
    }
}
