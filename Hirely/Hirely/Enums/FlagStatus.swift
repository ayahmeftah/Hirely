//
//  FlagStatus.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import Foundation
import UIKit

enum FlagState {
    case flagged
    case edited
    case deleted

    var backgroundColor: UIColor {
        switch self {
        case .flagged:
            return UIColor(red: 255/255, green: 196/255, blue: 98/255, alpha: 1) // Light Yellow
        case .edited:
            return UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1) // Light Gray
        case .deleted:
            return UIColor(red: 255/255, green: 152/255, blue: 152/255, alpha: 1) // Light Red
        }
    }

    var textColor: UIColor {
        switch self {
        case .flagged:
            return UIColor(red: 154/255, green: 102/255, blue: 32/255, alpha: 1) // Dark Yellow-Brown
        case .edited:
            return UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1) // Dark Gray
        case .deleted:
            return UIColor(red: 154/255, green: 32/255, blue: 32/255, alpha: 1) // Dark Red
        }
    }

    var text: String {
        switch self {
        case .flagged: return "Flagged"
        case .edited: return "Edited"
        case .deleted: return "Deleted"
        }
    }
}
