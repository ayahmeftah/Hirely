//
//  AddJobPostingViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit

class AddJobPostingViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  

    @IBOutlet weak var btn_select_jobType: UIButton!
    
    @IBOutlet weak var btn_select_locationType: UIButton!
    
    @IBOutlet weak var btn_select_experience: UIButton!
        
    @IBOutlet weak var minimumLbl: UILabel!
    
    @IBOutlet weak var maximumLbl: UILabel!
    
    @IBOutlet weak var minSalarySlider: UISlider!
    
    @IBOutlet weak var maxSalarySlider: UISlider!
    
    @IBOutlet weak var chooseCityBtn: UIButton!
    
    var pickerContainerView: UIView! // Container for the picker
    var cityPicker: UIPickerView! // Picker view
    
    var cities = ["Manama", "Muharraq", "Isa Town", "Riffa", "Sitra",
        "Hamad Town", "Budaiya", "Jidhafs", "A'ali", "Sanabis",
        "Zallaq", "Amwaj Islands", "Duraz", "Tubli", "Seef",
        "Hoora", "Adliya", "Juffair", "Salmaniya", "Diyar Al Muharraq"
    ]
    
    
    @IBAction func minimumSlider(_ sender: UISlider) {
        // Update the minimum salary label
        let minSalary = Int(sender.value)
        minimumLbl.text = "\(minSalary) BHD"
    }
    
    @IBAction func maximumSlider(_ sender: UISlider) {
        let maxSalary = Int(sender.value)
        maximumLbl.text = "\(maxSalary) BHD"
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        // Safely set slider values and labels
        if let minSlider = minSalarySlider, let maxSlider = maxSalarySlider,
           let minLabel = minimumLbl, let maxLabel = maximumLbl {
            minSlider.value = 300
            maxSlider.value = 400
            minLabel.text = "\(Int(minSlider.value)) BHD"
            maxLabel.text = "\(Int(maxSlider.value)) BHD"
        } else {
            print("One or more sliders/labels are nil")
        }
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
            let doneButton = UIButton(frame: CGRect(x: pickerContainerView.frame.width - 80, y: 0, width: 80, height: 50))
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
            chooseCityBtn.setTitle(selectedCity, for: .normal)

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
    
   
    
    @IBAction func jobTypeSelection(_ sender: UIAction){
        self.btn_select_jobType.setTitle(sender.title, for: .normal)
    }
    
    @IBAction func locationTypeSelection(_ sender: UIAction){
        self.btn_select_locationType.setTitle(sender.title, for: .normal)
    }
    
    @IBAction func experienceLevelSelection(_ sender: UIAction){
        self.btn_select_experience.setTitle(sender.title, for: .normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
