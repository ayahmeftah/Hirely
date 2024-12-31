//
//  SkillsSelectionViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 15/12/2024.
//

import UIKit

import UIKit

class SkillsSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var skills: [String] = [] // List of all available skills
    var selectedSkills: [String] = [] // To track selected skills
    var onSkillsSelected: (([String]) -> Void)? // Callback to return selected skills
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupDoneButton()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true // Enable multi-selection
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }

    private func setupDoneButton() {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func doneTapped() {
        
        // Pass selected skills back to MainViewController via callback
        onSkillsSelected?(selectedSkills)
        
        // Dismiss the current SkillsSelectionViewController
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SkillCell")
        let skill = skills[indexPath.row]

        cell.textLabel?.text = skill
        cell.accessoryType = selectedSkills.contains(skill) ? .checkmark : .none
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let skill = skills[indexPath.row]
        if !selectedSkills.contains(skill) {
            selectedSkills.append(skill) // Add to selected
        } else {
            selectedSkills.removeAll { $0 == skill } // Remove if already selected
        }
        tableView.reloadRows(at: [indexPath], with: .automatic) // Update checkmark
    }
}
