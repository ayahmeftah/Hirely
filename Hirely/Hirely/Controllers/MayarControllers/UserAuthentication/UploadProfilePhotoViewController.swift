//
//  UploadProfilePhotoViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 08/12/2024.
//

import UIKit
import Cloudinary
import FirebaseFirestore

class UploadProfilePhotoViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let db = Firestore.firestore()
    let user = currentUser()
    
    @IBOutlet weak var profileImageToUse: UIImageView!
    
    let cloudinary = CloudinarySetup.cloudinarySetup()
    
    var profilePhotoLink = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageToUse.layer.cornerRadius = profileImageToUse.layer.frame.size.width / 2
        profileImageToUse.clipsToBounds = true
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
                    self.profileImageToUse.cldSetImage(secureUrl, cloudinary: self.cloudinary)
                    self.profilePhotoLink = secureUrl
                }
            }
        })
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            print("Error: No image selected")
            dismiss(animated: true, completion: nil)
            return
        }
        
        //Update the UIImageView
        profileImageToUse.image = selectedImage
        
        //Upload the selected image
        uploadImage(image: selectedImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    //Choose photo action will be here
    @IBAction func choosePhotoClicked(_ sender: UIButton) {
        presentImagePicker()
    }
    
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        updateDatabase()
        performSegue(withIdentifier: "goToRegisterInterests", sender: sender)
    }
    
    @IBAction func skipForNowBtnClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegisterInterests", sender: sender)
    }
    
    func updateDatabase(){
        let collection = db.collection("Users")
        let userIdToFind = user.getCurrentUserId()
        
        // Query for documents where the userId field matches the specified value
        collection.whereField("userId", isEqualTo: userIdToFind!).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            // Loop through the documents in the snapshot
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    // You have the document, so you can access its data
                    let data = document.data()
                    print("Document data: \(data)")
                    
                    // If the userId matches, update the firstName field
                    if let userId = data["userId"] as? String, userId == userIdToFind {
                        // Document reference for updating
                        let documentRef = self.db.collection("Users").document(document.documentID)
                        
                        // Update the firstName field
                        documentRef.updateData([
                            "profilePhoto" : self.profilePhotoLink
                        ]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated!")
                            }
                        }
                    }
                }
            }
        }
    }
}
