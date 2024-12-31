//
//  AddCompanyViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 29/12/2024.
//

import UIKit
import FirebaseFirestore
import Cloudinary

class AddCompanyViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var companyImage: CLDUIImageView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var specializationTextView: UITextView!
    @IBOutlet weak var growthTextView: UITextView!
    @IBOutlet weak var benefitTextView: UITextView!
    
    
    let db = Firestore.firestore()
    let user = currentUser().getCurrentUserId()
    let cloudinary = CloudinarySetup.cloudinarySetup()
    
    var companyImageLink: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable user interaction on the image view
        companyImage.isUserInteractionEnabled = true
        
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        // Add the gesture recognizer to the image view
        companyImage.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let error = validateFields()
        
        if error != nil{ //if the value of error is not nil, it means there was an error, display alert
            showErrorAlert(error!)
        }else{
            
            let companyName = companyNameTextField.text!
            let specialization = specializationTextView.text!
            let overview = overviewTextView.text!
            let benefit = benefitTextView.text!
            let growth = growthTextView.text!
            
            let collection = db.collection("companies")
            
            let newDocRef = collection.document()
            
            let docId = newDocRef.documentID
            
            let data: [String: Any] = [
                "docId": docId,
                "name": companyName,
                "specialization": specialization,
                "overview": overview,
                "growth": growth,
                "benefit": benefit,
                "companyPicture": companyImageLink
            ]
            
            newDocRef.setData(data){ error in
                if let error = error{
                    print(error)
                }
                else{
                    print("success")
                    self.showSuccessAlert()
                }
            }
        }
    }
    
    func validateFields() -> String?{
        if((companyNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")  || (overviewTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
           (specializationTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
           (growthTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
           (benefitTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")){
            return "All fields are required, Please make sure to fill all the fields"
        }
        return nil
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
                                      message: "Company is added Successfully!",
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
        let publicID = "companyImage/\(uniqueID)" //Specify the folder reference
        
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
                    self.companyImage.cldSetImage(secureUrl, cloudinary: self.cloudinary)
                    self.companyImageLink = secureUrl
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
        companyImage.image = selectedImage
        
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
    
    
}
