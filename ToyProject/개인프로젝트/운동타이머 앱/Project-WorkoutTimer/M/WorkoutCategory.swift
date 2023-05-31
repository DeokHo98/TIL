//
//  WorkoutCategory.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/01/28.
//

import Foundation
import RealmSwift
class WorkoutCategory: Object {
    @Persisted var name: String = ""
    @Persisted var items = List<Item>()
    
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
}
