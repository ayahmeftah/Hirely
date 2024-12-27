//
//  ViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 01/12/2024.
//

import UIKit
import Cloudinary


class ViewController: UIViewController {
    
//    let cloudName: String = "drkt3vace"
//    var uploadPreset: String = "unsigned_upload"
//    var publicId: String = "samples/animals/cat"
//    
//    @IBOutlet weak var ivGenerateUrl: CLDUIImageView!
//    @IBOutlet weak var ivUploadedImage: CLDUIImageView!
//
//    var cloudinary: CLDCloudinary!
//    var url: String!
//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initCloudinary()
//        generateUrl()
//        uploadImage()
        print("Hello")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        setImageView()
    }
//    
//    private func initCloudinary() {
//        let config = CLDConfiguration(cloudName: cloudName, secure: true)
//        cloudinary = CLDCloudinary(configuration: config)
//    }
//    
//    
//    private func generateUrl() {
//        url = cloudinary.createUrl().setTransformation(CLDTransformation().setEffect("sepia")).generate(publicId)
//    }
//
//    private func setImageView() {
//        ivGenerateUrl.cldSetImage(url, cloudinary: cloudinary)
//    }
//    
//    private func uploadImage() {
//        guard let data = UIImage(named: "cloudinary_logo")?.pngData() else {
//            return
//        }
//        cloudinary.createUploader().upload(data: data, uploadPreset: uploadPreset, completionHandler:  { response,error in
//            DispatchQueue.main.async {
//                guard let url = response?.secureUrl else {
//                    return
//                }
//                self.ivUploadedImage.cldSetImage(url, cloudinary: self.cloudinary)
//            }
//        })
//    }

}

