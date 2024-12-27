//
//  FilterAlertService.swift
//  Hirely
//
//  Created by Ayah Meftah  on 26/12/2024.
//

import Foundation
import UIKit

class FilterAlertService{
    
    
    func filterAlert<T: RawRepresentable & CaseIterable>(with filterEnum: T.Type, title: String) -> FilterAlertViewController where T.RawValue == String {
        let storyboard = UIStoryboard(name: "FilterAlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "FilterAlertVC") as! FilterAlertViewController
        
        alertVC.singleFilterTitle = title // Set single category name
        alertVC.singleFilterOptions = filterEnum.allCases.map { $0.rawValue } // Set single category options
        alertVC.isMultiCategory = false // Indicate this is a single-category filter
        
        return alertVC
    }
    
    func allFiltersAlert(with allFilters: [String: [String]]) -> FilterAlertViewController {
        let storyboard = UIStoryboard(name: "FilterAlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "FilterAlertVC") as! FilterAlertViewController
        
        alertVC.allFilters = allFilters
        alertVC.isMultiCategory = true // Indicate that multiple categories are displayed
        
        return alertVC
    }
}
