//
//  Realm.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/02/27.
//

import Foundation
import RealmSwift

class RealmSingleton {
    static let shared = RealmSingleton()
    let realm = try! Realm()
}



