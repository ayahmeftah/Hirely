//
//  Badges.swift
//  Hirely
//
//  Created by BP-36-201-04 on 26/12/2024.
//

import Foundation
import UIKit

//Enum for badge states
enum BadgeState {
    case reviewed
    case new
    case rejected
    case hired
    case scheduledInterview

    var backgroundColor: UIColor {
        switch self {
        case .reviewed: return UIColor(red: 212/255, green: 170/255, blue: 255/255, alpha: 1)
        case .new: return UIColor(red: 255/255, green: 196/255, blue: 98/255, alpha: 1)
        case .hired: return UIColor(red: 125/255, green: 222/255, blue: 134/255, alpha: 1)
        case .scheduledInterview: return UIColor(red: 196/255, green: 222/255, blue: 255/255, alpha: 1)
        case .rejected: return UIColor(red: 255/255, green: 152/255, blue: 152/255, alpha: 1)
        }
    }

    var text: String {
        switch self {
        case .reviewed: return "Reviewed"
        case .new: return "New"
        case .hired: return "Hired"
        case .scheduledInterview: return "Scheduled Interview"
        case .rejected: return "Rejected"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .reviewed: return UIColor.purple
        case .new: return UIColor.brown
        case .hired: return UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)
        case .scheduledInterview: return UIColor.blue
        case .rejected: return UIColor.red
        }
    }

    var icon: UIImage? {
        switch self {
        case .reviewed: return UIImage(systemName: "doc.text.magnifyingglass")
        case .new: return UIImage(systemName: "checklist")
        case .hired: return UIImage(systemName: "checkmark.circle.fill")
        case .scheduledInterview: return UIImage(systemName: "person.2.fill")
        case .rejected: return UIImage(systemName: "xmark.circle.fill")
        }
    }
}
