//
//  EditTechnicalSkill.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 29/12/2024.
//

import Foundation
import UIKit

class EditTechnicalSkill{
    func show () -> EditTechnicalSkillsViewController{
        let storyboard = UIStoryboard(name: "RecommendationsAndDetailsStory", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "editTechnicalSkills") as! EditTechnicalSkillsViewController
        return alertVC
    }
}
