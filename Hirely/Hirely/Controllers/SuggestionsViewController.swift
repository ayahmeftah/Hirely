//
//  SuggestionsViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 25/12/2024.
//

import UIKit
import FirebaseFirestore


class SuggestionsViewController: UIViewController {
    
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
        configureTableView()
        
    }
    
    func configureTableView(){
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        results = [] // Clear previous results
        tableView.reloadData()
    }
    
}

extension SuggestionsViewController: UITableViewDataSource, UITableViewDelegate {
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

