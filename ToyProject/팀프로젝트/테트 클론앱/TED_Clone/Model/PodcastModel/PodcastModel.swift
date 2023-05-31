//
//  podcastModel.swift
//  TED_Clone
//
//  Created by 정덕호 on 2022/03/11.
//

import Foundation

class PodcastModel {
    var name: String?
    var image: String?
    var detailText: String?
    
    init(dic: [String : Any]) {
        self.name = dic["name"] as? String ?? ""
        self.image = dic["image"] as? String ?? ""
        self.detailText = dic["detailText"] as? String ?? ""
    }
}
