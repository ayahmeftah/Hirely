//
//  AddJobPostingViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit

class AddJobPostingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var btn_select_jobType: UIButton!
    
    @IBOutlet weak var btn_select_locationType: UIButton!
    
    @IBOutlet weak var btn_select_experience: UIButton!
    
    @IBOutlet weak var selectCityTxt: UITextField!
    
    @IBOutlet weak var minimumLbl: UILabel!
    
    @IBOutlet weak var maximumLbl: UILabel!
    
    @IBOutlet weak var minSalarySlider: UISlider!
    
    @IBOutlet weak var maxSalarySlider: UISlider!
    
    
    
    @IBAction func minimumSlider(_ sender: UISlider) {
        // Update the minimum salary label
        let minSalary = Int(sender.value)
        minimumLbl.text = "\(minSalary) BHD"
    }
    
    @IBAction func maximumSlider(_ sender: UISlider) {
        let maxSalary = Int(sender.value)
        maximumLbl.text = "\(maxSalary) BHD"
    }
    
    
    let cityPicker = UIPickerView()
    
    var currentIndex = 0
    
    var cities = ["Manama",
    "Muharraq",
    "Isa Town",
    "Riffa",
    "Sitra",
    "Hamad Town",
    "Budaiya",
    "Jidhafs",
    "A'ali",
    "Sanabis",
    "Zallaq",
    "Amwaj Islands",
    "Duraz",
    "Tubli",
    "Seef",
    "Hoora",
    "Adliya",
    "Juffair",
    "Salmaniya",
    "Diyar Al Muharraq"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityPicker.delegate = self
        cityPicker.dataSource = self
         
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([btnDone], animated: true)
        
        selectCityTxt.inputView = cityPicker
        selectCityTxt.inputAccessoryView = toolBar
        
        
        // Set initial slider values
        minSalarySlider.value = 300
        maxSalarySlider.value = 400
        
        // Set initial label values
        minimumLbl.text = "\(Int(minSalarySlider.value)) BHD"
        maximumLbl.text = "\(Int(maxSalarySlider.value)) BHD"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
        selectCityTxt.text = cities[row]
    }
    
    @objc func closePicker(){
        selectCityTxt.text = cities[currentIndex]
        view.endEditing(true)
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
