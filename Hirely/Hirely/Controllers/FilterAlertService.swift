//
//  FilterAlertService.swift
//  Hirely
//
//  Created by Ayah Meftah  on 26/12/2024.
//

import Foundation
import UIKit

class FilterAlertService{
    
    func filterAlert() -> FilterAlertViewController {
        let storyboard = UIStoryboard(name: "FilterAlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "FilterAlertVC") as! FilterAlertViewController
        return alertVC
    }
}
