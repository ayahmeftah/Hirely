//
//  EditJobPostViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 13/12/2024.
//

import UIKit
import FirebaseFirestore

class EditJobPostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

  

    @IBOutlet weak var minSalarySlider: UISlider!
    @IBOutlet weak var maxSalarySlider: UISlider!
    
    @IBOutlet weak var minimumLbl: UILabel!
    
    @IBOutlet weak var maximumLbl: UILabel!
    
    @IBOutlet weak var selectJobTypeBtn: UIButton!
    
    @IBOutlet weak var selectLocationBtn: UIButton!
    
    @IBOutlet weak var selectExperienceBtn: UIButton!
    
    @IBOutlet weak var selectCityButton: UIButton!
    
    @IBOutlet weak var jobTitleLbl: UITextField!
    
    @IBOutlet weak var jobDescLbl: UITextView!
    
  
    var pickerContainerView: UIView! // Container for the picker
    var cityPicker: UIPickerView! // Picker view
    
    var cities = ["Manama", "Muharraq", "Isa Town", "Riffa", "Sitra",
        "Hamad Town", "Budaiya", "Jidhafs", "A'ali", "Sanabis",
        "Zallaq", "Amwaj Islands", "Duraz", "Tubli", "Seef",
        "Hoora", "Adliya", "Juffair", "Salmaniya", "Diyar Al Muharraq"
    ]
    
    var jobPosting: JobPosting? // The selected job data passed from previous screen

    override func viewDidLoad() {
        super.viewDidLoad()
        if let job = jobPosting {
            print("Job data received: \(job)")
        } else {
            print("No job data received.")
        }
        populateFields()
        setupPickerView()
    }
  
    func setupPickerView() {
            // Create the container view
            pickerContainerView = UIView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 250))
            pickerContainerView.backgroundColor = .white
            view.addSubview(pickerContainerView)

            // Create the picker view
            cityPicker = UIPickerView()
            cityPicker.delegate = self
            cityPicker.dataSource = self
            cityPicker.frame = CGRect(x: 0, y: 50, width: pickerContainerView.frame.width, height: 200)
            pickerContainerView.addSubview(cityPicker)

            // Create a "Done" button
            let doneButton = UIButton(frame: CGRect(x:pickerContainerView.frame.width - 80, y: 0, width: 80, height: 50))
            doneButton.setTitle("Done", for: .normal)
            doneButton.setTitleColor(.systemBlue, for: .normal)
            doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
            pickerContainerView.addSubview(doneButton)
        }

        @objc func doneButtonTapped() {
            // Get the selected city from the picker view
            let selectedRow = cityPicker.selectedRow(inComponent: 0)
            let selectedCity = cities[selectedRow]

            // Update the button title
            selectCityButton.setTitle(selectedCity, for: .normal)

            // Hide the picker view
            UIView.animate(withDuration: 0.3) {
                self.pickerContainerView.frame.origin.y = self.view.frame.height
            }
        }
    @IBAction func selectCityButtonTapped(_ sender: UIButton) {
            // Show the picker view
            UIView.animate(withDuration: 0.3) {
                self.pickerContainerView.frame.origin.y = self.view.frame.height - 250
            }
        }

        // MARK: - UIPickerView DataSource & Delegate
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return cities.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return cities[row]
        }
    
    // MARK: - Slider Actions
    @IBAction func minimumSlider(_ sender: UISlider) {
        minimumLbl.text = "\(Int(sender.value)) BHD"
    }
    
    @IBAction func maximumSlider(_ sender: UISlider) {
        maximumLbl.text = "\(Int(sender.value)) BHD"
    }
    
    // MARK: - Button Actions
    @IBAction func selectJobType(_ sender: UIAction) {
        let title = sender.title
        selectJobTypeBtn.setTitle(title, for: .normal)
    }
    
    @IBAction func selectLocationType(_ sender: UIAction) {
        let title = sender.title
        selectLocationBtn.setTitle(title, for: .normal)
    }
    
    @IBAction func selectExperience(_ sender: UIAction) {
        let title = sender.title
        selectExperienceBtn.setTitle(title, for: .normal)
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard var job = jobPosting else { return }

        // Update the `JobPosting` object with current screen changes
        job.jobTitle = jobTitleLbl.text ?? job.jobTitle
        job.jobType = selectJobTypeBtn.currentTitle ?? job.jobType
        job.locationType = selectLocationBtn.currentTitle ?? job.locationType
        job.city = selectCityButton.currentTitle ?? job.city
        job.experienceLevel = selectExperienceBtn.currentTitle ?? job.experienceLevel
        job.minSalary = Int(minSalarySlider.value)
        job.maxSalary = Int(maxSalarySlider.value)
        job.jobDescription = jobDescLbl.text ?? job.jobDescription
        print("Job data before segue: \(job)")
        // Pass the updated job to the next screen
        performSegue(withIdentifier: "gotoSaveChanges", sender: job)

    }
    
    func populateFields() {
        guard let job = jobPosting else {
            print("Job data not found")
            return
        }

        jobTitleLbl.text = job.jobTitle
        selectJobTypeBtn.setTitle(job.jobType, for: .normal)
        selectLocationBtn.setTitle(job.locationType, for: .normal)
        selectCityButton.setTitle(job.city, for: .normal)
        selectExperienceBtn.setTitle(job.experienceLevel, for: .normal)
        minSalarySlider.value = Float(job.minSalary)
        maxSalarySlider.value = Float(job.maxSalary)
        minimumLbl.text = "\(job.minSalary) BHD"
        maximumLbl.text = "\(job.maxSalary) BHD"
        jobDescLbl.text = job.jobDescription
    
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoSaveChanges",
           let saveVC = segue.destination as? saveJobChangesViewController,
           let updatedJob = sender as? JobPosting {
            saveVC.jobPosting = updatedJob
            print("Job data before segue: \(updatedJob)")
        }
    }

  
}
