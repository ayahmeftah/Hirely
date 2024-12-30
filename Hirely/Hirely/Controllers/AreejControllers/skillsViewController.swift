//
//  skillsViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit

class skillsViewController: UIViewController, UITextViewDelegate {

    // MARK: - Properties
    var cvData: CVData? // Property to hold the data passed from PersonalInfoViewController

    // MARK: - Outlets
    @IBOutlet weak var skillsTextView: UITextView!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up placeholder for Skills TextView
        setupSkillsTextView()
    }

    // MARK: - Setup Methods
    private func setupSkillsTextView() {
        skillsTextView.text = "Enter your skills separated by commas or line breaks..."
        skillsTextView.textColor = .lightGray
        skillsTextView.delegate = self
    }

    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Validate if the user has entered skills
        guard validateSkillsInput() else {
            return
        }

        // Initialize cvData if nil
        if cvData == nil {
            cvData = CVData()
        }

        // Parse the entered skills into an array of Skill objects
        updateSkillsData()

        // Debug: Print updated skills
        print("Skills added: \(cvData?.skills.map { $0.name } ?? [])")

        // Perform segue to the next screen
        performSegue(withIdentifier: "toExperienceScreen", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExperienceScreen",
           let destinationVC = segue.destination as? expViewController {
            destinationVC.cvData = cvData
            print("Passing CV Data to ExpViewController: \(String(describing: cvData))")
        }
    }

    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your skills separated by commas or line breaks..." {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your skills separated by commas or line breaks..."
            textView.textColor = .lightGray
        }
    }

    // MARK: - Helper Methods
    private func validateSkillsInput() -> Bool {
        if skillsTextView.text == "Enter your skills separated by commas or line breaks..." || skillsTextView.text.isEmpty {
            showAlert(title: "Missing Skills", message: "Please enter at least one skill before proceeding.")
            return false
        }
        return true
    }

    private func updateSkillsData() {
        let enteredSkills = skillsTextView.text
            .split { $0 == "," || $0.isNewline }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { CVData.Skill(name: $0) }
        cvData?.skills = enteredSkills
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

