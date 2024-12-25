//
//  SuggestionsDelegate.swift
//  Hirely
//
//  Created by Ayah Meftah  on 25/12/2024.
//

import Foundation

protocol SuggestionsDelegate: AnyObject {
    func didSelectSuggestion(_ suggestion: String)
}
