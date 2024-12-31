//
//  AddEmployerViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 29/12/2024.
//

import UIKit
import FirebaseFirestore
import Cloudinary
import FirebaseAuth

class AddEmployerViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    let db = Firestore.firestore()
    //let userId = currentUser().getCurrentUserId()
    let cloudinary = CloudinarySetup.cloudinarySetup()
    
    @IBOutlet weak var profilePhoto: CLDUIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var selectGenderBtn: UIButton!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyImage: CLDUIImageView!
    let datePicker = UIDatePicker()
    let cityPickerView = UIPickerView()
    let companyPickerView = UIPickerView()
    
    var companiesPickerData: [String] = []
    var companiesImagesLinks: [String] = []
    var companiesIds: [String] = []
    var companyID: String = ""
    
    var profilePhotoLink: String = "https://res.cloudinary.com/drkt3vace/image/upload/v1735392629/twpxlpisathxefjmexoy.jpg"
    
    var cityPickerData =  ["Manama", "Muharraq", "Isa Town", "Riffa", "Sitra",
                           "Hamad Town", "Budaiya", "Jidhafs", "A'ali", "Sanabis",
                           "Zallaq", "Amwaj Islands", "Duraz", "Tubli", "Seef",
                           "Hoora", "Adliya", "Juffair", "Salmaniya", "Diyar Al Muharraq"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCompanies()
        
        // Enable user interaction on the image view
        profilePhoto.isUserInteractionEnabled = true
        
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        // Add the gesture recognizer to the image view
        profilePhoto.addGestureRecognizer(tapGesture)
        
        profilePhoto.layer.cornerRadius = profilePhoto.layer.frame.size.width / 2
        profilePhoto.clipsToBounds = true
        
        companyImage.layer.cornerRadius = companyImage.layer.frame.size.width / 2
        companyImage.clipsToBounds = true
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        dateOfBirthTextField.inputView = datePicker
        //dateOfBirthTextField.text = formatDate(date: Date())
        
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        cityTextField.inputView = cityPickerView
        
        companyPickerView.delegate = self
        companyPickerView.dataSource = self
        companyNameTextField.inputView = companyPickerView
    }
    
    @IBAction func optionSelction(_ sender: UIAction){
        print(sender.title)
        self.selectGenderBtn.setTitle(sender.title, for: .normal)
    }
    
    func fetchCompanies(){
        db.collection("companies").getDocuments { snapshot, error in
            if let error = error{
                print("Something went wrong: \(error.localizedDescription)")
            }
            else{
                self.companiesPickerData.removeAll()
                for doc in snapshot?.documents ?? []{
                    if let companyName = doc["name"] as? String{
                        DispatchQueue.main.async{
                            self.companiesPickerData.append(companyName)
                        }
                        
                    }
                    
                    if let companyPicture = doc["companyPicture"] as? String{
                        DispatchQueue.main.async{
                            self.companiesImagesLinks.append(companyPicture)
                        }
                    }
                    
                    if let companyId = doc["companyId"] as? String{
                        DispatchQueue.main.async {
                            self.companiesIds.append(companyId)
                        }
                    }
                }
            }
        }
    }
    
    func validateFields() -> String?{
        
        //check if fields are empty
        if (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (dateOfBirthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (companyNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return "All fields are required, Please make sure to fill all the fields"
        }
        
        //Check if email format is correct
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (isValidEmail(cleanedEmail) == false){
            return "Please make sure you entered your email in an appropriate format."
        }
        
        //Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(isPasswordValid(cleanedPassword) == false){
            return "Please make sure your password is at least 10 characters, contains a special character and a number"
        }
        
        if (selectGenderBtn.title(for: .normal) == "  Select Gender"){
            return "Please select an option for Gender"
        }
        
        let ageValid = validateAge()
        
        if (ageValid == false){
            return "Employer must be at least 18 years old to register"
        }
        
        return nil
    }
    
    func validateAge() -> Bool {
        // Get the selected date from the date picker
        let selectedDate = self.datePicker.date
        
        // Calculate the difference between the current date and the selected date
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Ensure the age is calculated based on years
        let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: currentDate)
        if let age = ageComponents.year, age >= 18 {
            // The person is 18 or older
            return true
        } else {
            return false
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        dateOfBirthTextField.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    //Validate the entered email format using a regular expression
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    //Validate the entered password format using a regular expression
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    //Function for preseting error alert
    func showErrorAlert(_ errorMessage: String){
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Function for presenting success alert
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Success",
                                      message: "Employer is created Successfully!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Trigger the segue
            //self.performSegue(withIdentifier: "goToRegisterDetails", sender: self)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func uploadImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            print("Error converting image to data")
            return
        }
        
        let uniqueID = UUID().uuidString //Generate a unique ID for the image
        let publicID = "usersProfileImage/\(uniqueID)" //Specify the folder reference
        
        let uploadParams = CLDUploadRequestParams()
        uploadParams.setPublicId(publicID) //Set the public ID
        
        cloudinary.createUploader().upload(data: data, uploadPreset: CloudinarySetup.uploadPreset, params: uploadParams, completionHandler: { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                
                if let secureUrl = response?.secureUrl {
                    print("Image uploaded successfully: \(secureUrl)") //Get the image URL
                    print("Public ID: \(response?.publicId ?? "N/A")") //Log the public ID
                    self.profilePhoto.cldSetImage(secureUrl, cloudinary: self.cloudinary)
                    self.profilePhotoLink = secureUrl
                }
            }
        })
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            print("Error: No image selected")
            dismiss(animated: true, completion: nil)
            return
        }
        
        //Update the UIImageView
        profilePhoto.image = selectedImage
        
        //Upload the selected image
        uploadImage(image: selectedImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    @objc func imageTapped() {
        print("Image was tapped!")
        presentImagePicker()
    }
    
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createUserClicked(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let gender = selectGenderBtn.title(for: .normal)
        let dateNotConverted = datePicker.date
        let dateOfBirth = Timestamp(date: dateNotConverted)
        let phoneNumber = phoneNumberTextField.text!
        let city = cityTextField.text!
        let companyName = companyNameTextField.text!
        let profilePhoto = profilePhotoLink
        let compantId = self.companyID
        
        //Check if value returned by validateFields
        let error = validateFields()
        
        if error != nil{ //if the value of error is not nil, it means there was an error, display alert
            showErrorAlert(error!)
        }
        else{ //In case everything is valid, create user, show success alet then navigate to Register Details
            Auth.auth().createUser(withEmail: email, password: password) { (results, err) in
                
                if err != nil{
                    self.showErrorAlert("Something went wrong, try again.")
                    print(err!.localizedDescription)
                }
                else{
                    let usersCollection = self.db.collection("Users")
                    
                    let newDocRef = usersCollection.document()
                    
                    let docId = newDocRef.documentID
                    let userId = results?.user.uid
                    
                    let data: [String: Any] = [
                        "docId": docId,
                        "userId": userId!,
                        "email" : email,
                        "password" : password,
                        "firstName" : firstName,
                        "lastName" : lastName,
                        "gender" : gender!,
                        "dateOfBirth" : dateOfBirth,
                        "phoneNumber" : phoneNumber,
                        "city" : city,
                        "profilePhoto" : profilePhoto,
                        "companyName" : companyName,
                        "companyId" : compantId,
                        "isApplicant" : false,
                        "isAdmin" : false,
                        "isEmployer" : true
                    ]
                    
                    newDocRef.setData(data){ error in
                        if let error = error{
                            print(error)
                        }
                        else{
                            print("success")
                        }
                    }
                    
                    self.showSuccessAlert()
                }
            }
        }
    }
    
    @IBAction func addCompanyClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddCompany", sender: sender)
    }
    
}

extension AddEmployerViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == cityPickerView{
            return cityPickerData.count
        }
        else if pickerView == companyPickerView{
            return companiesPickerData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView{
            return cityPickerData[row]
        }
        else if pickerView == companyPickerView{
            return companiesPickerData[row]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == cityPickerView{
            cityTextField.text = cityPickerData[row]
            cityTextField.resignFirstResponder()
        }
        else if pickerView == companyPickerView{
            companyNameTextField.text = companiesPickerData[row]
            companyNameTextField.resignFirstResponder()
            companyID = companiesIds[row]
            companyImage.cldSetImage(companiesImagesLinks[row], cloudinary: cloudinary)
        }
    }
}
