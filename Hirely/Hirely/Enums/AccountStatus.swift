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
    case deleted

    var backgroundColor: UIColor {
        switch self {
        case .active:
            return UIColor(red: 125/255, green: 222/255, blue: 134/255, alpha: 1) // Light Green with transparency
        case .deleted:
            return UIColor(red: 255/255, green: 152/255, blue: 152/255, alpha: 1) // Light Red
        }
    }

    var textColor: UIColor {
        switch self {
        case .active:
            return UIColor(red: 47/255, green: 117/255, blue: 50/255, alpha: 1) // Darker Green
        case .deleted:
            return UIColor(red: 154/255, green: 32/255, blue: 32/255, alpha: 1) // Dark Red
        }
    }

    var text: String {
        switch self {
        case .active: return "Active"
        case .deleted: return "Deleted"
        }
    }
}
