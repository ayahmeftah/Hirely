//
//  AccountStatus.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 08/12/2024.
//

import Foundation
import UIKit

enum AccountStatus {
    case active
    

    var backgroundColor: UIColor {
        switch self {
        case .active:
            return UIColor(red: 125/255, green: 222/255, blue: 134/255, alpha: 1) // Light Green with transparency
       
        }
    }

    var textColor: UIColor {
        switch self {
        case .active:
            return UIColor(red: 47/255, green: 117/255, blue: 50/255, alpha: 1) // Darker Green
        
        }
    }

    var text: String {
        switch self {
        case .active: return "Active"
    
        }
    }
}
