//
//  FlagStatus.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import Foundation
import UIKit

enum FlagState: String {
    case flagged = "Flagged"
   
    var backgroundColor: UIColor {
        switch self {
        case .flagged:
            return UIColor(red: 255/255, green: 196/255, blue: 98/255, alpha: 1) // Light Yellow
       
        }
    }

    var textColor: UIColor {
        switch self {
        case .flagged:
            return UIColor(red: 154/255, green: 102/255, blue: 32/255, alpha: 1) // Dark Yellow-Brown
        
        }
    }

    var text: String {
        switch self {
        case .flagged: return "Flagged"
     
        }
    }
}
