//
//  AddTechnicalSkillAlert.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 29/12/2024.
//

import UIKit

class AddTechnicalSkillAlert{
    func alert () -> AddTechnicalSkillViewController{
        let storyboard = UIStoryboard(name: "ApplicantProfile", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "addTechnicalSkill") as! AddTechnicalSkillViewController
        return alertVC
    }
}
