//
//  Skill.swift
//  Hirely
//
//  Created by student on 05/12/2024.
//

import Foundation

struct skill{
    let id = UUID()
    var Skilltitle: String
    var isComplete: Bool
   
   
    
    static func loadskillsList() -> [skill]?  {
        return nil
    }
    static func loadSampleskillList() -> [skill] {
        let skill1 = skill(Skilltitle: "solving problems", isComplete: true)
        let skill2 = skill(Skilltitle: "Communication", isComplete: false)
        let skill3 = skill(Skilltitle: "solving problems", isComplete: true)
        let skill4 = skill(Skilltitle: "solving problems", isComplete: true)
        let skill5 = skill(Skilltitle: "solving problems", isComplete: true)
        let skill6 = skill(Skilltitle: "solving problems", isComplete: true)
        return [skill1,skill2,skill3,skill4,skill5,skill6]
    }
  
    static func ==(lhs: skill, rhs: skill) -> Bool {
        return lhs.id == rhs.id
    }
    
}
