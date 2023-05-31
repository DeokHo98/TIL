//
//  StoryModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/13.
//

import Foundation
import Firebase

struct StoryModel: Equatable {
    var cafeName: String
    let uid: String
    let userImage: String
    let userName: String
    let time: Timestamp
    var text: String
    let storyImage: String
    var imageData: Data?
    var storyCount: Int?
}

extension StoryModel {
    static let EMPTY = StoryModel(cafeName: "", uid: "", userImage: "", userName: "", time: Timestamp(), text: "", storyImage: "", storyCount: 0)
}
