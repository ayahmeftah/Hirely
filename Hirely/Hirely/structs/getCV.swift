//
//  getCV.swift
//  Hirely
//
//  Created by BP-36-201-01 on 24/12/2024.
//

import Foundation
import FirebaseCore

struct CVs{
    var cvUrl: String
    var uploadedAt: Timestamp
    
    init(data : [String: Any]){
        self.cvUrl = data["cvUrl"] as? String ?? ""
        self.uploadedAt = (data["uploadedAt"] as? Timestamp)!

    }
    
    
}


