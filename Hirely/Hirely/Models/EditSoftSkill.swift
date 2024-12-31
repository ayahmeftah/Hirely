//
//  EditSoftSkill.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 29/12/2024.
//

import Foundation
import UIKit

class EditSoftSkill{
    func show () -> EditSoftSkillViewController{
        let storyboard = UIStoryboard(name: "RecommendationsAndDetailsStory", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "editSoftSkills") as! EditSoftSkillViewController
        return alertVC
    }
}
