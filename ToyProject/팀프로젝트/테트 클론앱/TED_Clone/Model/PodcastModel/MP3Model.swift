//
//  MP3Model.swift
//  TED_Clone
//
//  Created by 정덕호 on 2022/03/13.
//

import UIKit

class Mp3Model {
    var name: String?
    var mp3URL: String?
    var runTime: String?
    var time: String?
    var detailText: String?
    
    init(dic: [String : Any]) {
        self.name = dic["name"] as? String ?? ""
        self.mp3URL = dic["url"] as? String ?? ""
        self.runTime = dic["runtime"] as? String ?? ""
        self.time = dic["time"] as? String ?? ""
        self.detailText = dic["text"] as? String ?? ""
    }
}
