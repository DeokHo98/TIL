//
//  Daily.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/01/29.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted dynamic var title: String = ""
    @Persisted dynamic var memo: String = ""
    @Persisted dynamic var date: Date?
    
    var parentWorkoutCategory = LinkingObjects(fromType: WorkoutCategory.self, property: "items")
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    convenience init(memo: String) {
        self.init()
        self.memo = memo
    }
    
    convenience init(title: String, memo: String) {
        self.init()
        self.title = title
        self.memo = memo
        self.date = Date()
    }
}
