//
//  Cloudinary.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 25/12/2024.
//

import Foundation
import Cloudinary

struct CloudinarySetup {
    
    static var cloudinary : CLDCloudinary!

    private static let cloudName : String = "drkt3vace" //Cloud name
    
    static let uploadPreset: String = "profilePhoto_upload_preset" //Upload preset
    
    static func cloudinarySetup() -> CLDCloudinary {
        
        let config = CLDConfiguration(cloudName: CloudinarySetup.cloudName, secure: true)
        
        cloudinary = CLDCloudinary(configuration: config)
        
        return cloudinary
    }
}
