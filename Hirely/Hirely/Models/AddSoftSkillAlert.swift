//
//  AddSoftSkillAlert.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 13/12/2024.
//

import UIKit

class AddSoftSkillAlert{
    func alert () -> AddSoftSkillViewController{
        let storyboard = UIStoryboard(name: "ApplicantProfile", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "addSoftSkill") as! AddSoftSkillViewController
        return alertVC
    }
}
