//
//  ResultsPageViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 24/12/2024.
//

import UIKit
import FirebaseFirestore

class ResultsPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var jobResultsTableView: UITableView!
    @IBOutlet weak var CityBtnLbl: UIButton!
    
    var selectedFilters: [String: String] = [:] // To store selected filters
    
    let filters = ["Job Type", "Experience Level", "Location Type", "Salary Range"]
    var searchController: UISearchController? // To hold the passed search controller
    var jobs: [JobPosting] = []
    var filteredJobs: [JobPosting] = []
    var searchQuery: String = ""
    
    @IBAction func didTapAllFilters(_ sender: Any) {
        let allFilters: [String: [String]] = [
            "City": City.allCases.map { $0.rawValue },
            "Job Type": JobType.allCases.map { $0.rawValue },
            "Experience Level": ExperienceLevel.allCases.map { $0.rawValue },
            "Location Type": LocationType.allCases.map { $0.rawValue }
        ]
        
        let filterAlertVC = FilterAlertService().allFiltersAlert(with: allFilters)
        
        filterAlertVC.modalPresentationStyle = .overCurrentContext
        filterAlertVC.modalTransitionStyle = .crossDissolve
        self.present(filterAlertVC, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapCity(_ sender: Any) {
        let filterAlertVC = FilterAlertService().filterAlert(with: City.self, title: "City")
        
        // Handle the selection callback
        filterAlertVC.didSelectOption = { [weak self] selectedOption in
            guard let self = self else { return }
            self.CityBtnLbl.setTitle(selectedOption, for: .normal) // Update the button title
            print("Selected City: \(String(describing: selectedOption))")
        }
        
        filterAlertVC.modalPresentationStyle = .overCurrentContext
        filterAlertVC.modalTransitionStyle = .crossDissolve
        self.present(filterAlertVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersCollectionSetup()
        jobsTableSetup()
        setupSearchController()
        fetchJobPostings()
        
    }
    
    func filtersCollectionSetup(){
        let nib = UINib(nibName: "FiltersCollectionViewCell", bundle: nil)
        filtersCollectionView.register(nib, forCellWithReuseIdentifier: "FilterCell")
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
    }
    
    func jobsTableSetup(){
        let nib2 = UINib.init(nibName: "JobsResultTableViewCell", bundle: nil)
        jobResultsTableView.rowHeight = UITableView.automaticDimension
        jobResultsTableView.estimatedRowHeight = 100 // Set an estimated height
        jobResultsTableView.backgroundColor = .clear
        jobResultsTableView.register(nib2, forCellReuseIdentifier: "jobResultCell")
        jobResultsTableView.delegate = self
        jobResultsTableView.dataSource = self
    }
    
    func setupSearchController() {
        guard let searchController = searchController else { return }
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func fetchJobPostings() {
        let db = Firestore.firestore()
        
        // Query Firestore for job postings
        db.collection("jobPostings")
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return } // Ensure self is not nil
                
                if let error = error {
                    print("Error fetching job postings: \(error)")
                    return
                }
                
                // Safely unwrap and map the documents to JobPosting models
                self.jobs = snapshot?.documents.compactMap { document in
                    JobPosting(data: document.data()) // Ensure JobPosting initializer is correct
                } ?? []
                
                // Filter jobs based on the search query
                self.filteredJobs = self.jobs.filter { job in
                    job.jobTitle.lowercased().contains(self.searchQuery.lowercased())
                }
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self.jobResultsTableView.reloadData()
                }
            }
    }
    
    
    // Collection view of filters
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FiltersCollectionViewCell
        cell.postInit(filters[indexPath.item]) // Set label text
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        /* cell.contentView.backgroundColor = .gray*/ // Update background color
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Dynamically calculate the label's width based on its content
        let labelWidth = filters[indexPath.item].size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width
        let cellHeight: CGFloat = 40 // Fixed height for the cell
        return CGSize(width: labelWidth + 40, height: cellHeight) // Add padding to the width
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilter = filters[indexPath.item]
        print("Selected Filter: \(selectedFilter)")
        
        switch selectedFilter {
        case "Job Type":
            presentFilterAlert(for: JobType.self, title: selectedFilter)
        case "Experience Level":
            presentFilterAlert(for: ExperienceLevel.self, title: selectedFilter)
        case "Location Type":
            presentFilterAlert(for: LocationType.self, title: selectedFilter)
        case "Salary Range":
            // Handle Salary Range or add a specific alert view logic for custom filtering
            print("Salary Range filter selected.")
        default:
            break
        }
    }
    
    // TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "jobResultCell", for: indexPath) as? JobsResultTableViewCell else {
            return UITableViewCell()
        }
        
        let job = filteredJobs[indexPath.row]
        /*cell.resultiInit(job.companyName, job.jobTitle, "placeholder_image", job.jobType)*/ // Replace "placeholder_image" with real image loading logic
        // Use commonInit to configure the cell
        cell.resultiInit(
            "microsoft",
            job.jobTitle,
            "Microsoft company",
            job.jobType
        )
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = filteredJobs[indexPath.row]
        print("Selected Job: \(job.jobTitle)")
        // Navigate to a detailed job posting view if needed
    }
    
    private func presentFilterAlert<T: RawRepresentable & CaseIterable>(for filterEnum: T.Type, title: String) where T.RawValue == String {
        let filterAlertVC = FilterAlertService().filterAlert(with: filterEnum, title: title)
        filterAlertVC.modalPresentationStyle = .overCurrentContext
        filterAlertVC.modalTransitionStyle = .crossDissolve
        self.present(filterAlertVC, animated: true, completion: nil)
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
            resultsVC.searchQuery = query
            resultsVC.searchController = searchController // Pass the search controller
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
