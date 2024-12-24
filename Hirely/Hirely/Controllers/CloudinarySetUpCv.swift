//
//  CloudinarySetUpCv.swift
//  Hirely
//
//  Created by BP-36-201-02 on 24/12/2024.
//

import Foundation
import Cloudinary
struct CloudinarySetupCv {
    
    static var cloudinary : CLDCloudinary!
    
    private static let cloudName : String = "drkt3vace" //Cloud name
    
    static let uploadPreset: String = "cv_uplaod_preset" //Upload preset
    
    static func cloudinarySetup() -> CLDCloudinary {
        
        let config = CLDConfiguration(cloudName: CloudinarySetupCv.cloudName, secure: true)
        
        cloudinary = CLDCloudinary(configuration: config)
        
        return cloudinary
    }
}
