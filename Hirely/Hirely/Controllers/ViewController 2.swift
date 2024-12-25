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
    //    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var dashboardTopCons: NSLayoutConstraint!
    
    //    var cloudinary: CLDCloudinary!
    //    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        initCloudinary()
        //        generateUrl()
        //        uploadImage()
        
        //        // Adjust the position of buttons for iPad
        //        if UIDevice.current.userInterfaceIdiom == .pad {
        //            topConstraint.constant = 250 // Push buttons lower on iPad
        //            dashboardTopCons.constant = 80
        //        } else {
        //            topConstraint.constant = 150 // Default position for iPhone
        //        }
        //
        //        // Apply the changes
        //        view.layoutIfNeeded()
        //    }
        
        //    override func viewDidAppear(_ animated: Bool) {
        //        setImageView()
        //    }
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
}
