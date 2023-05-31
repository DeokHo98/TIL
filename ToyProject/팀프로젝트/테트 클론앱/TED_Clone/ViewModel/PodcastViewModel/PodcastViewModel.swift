//
//  PodcastViewmodel.swift
//  TED_Clone
//
//  Created by 정덕호 on 2022/03/11.
//

import AVKit
import UIKit

class PodcastViewModel {
    
    static var podcastModel: PodcastModel?
    
    static var imageList: [UIImageView] = []
    
    static var nameList: [String] = []
    
    static var detailTextList: [String] = []
    
    static var mp3URLList: [String] = []
    
    static var mp3NameList: [String] = []
    
    static var mp3RunTimeList: [String] = []
    
    static var mp3TimeList: [String] = []
    
    static var mp3DetailText: [String] = []
    
    static func fetch(complition: @escaping (Int) -> Void) {
        PodcastAPI.fetch {  model in
            print("함수실행")
            let image = UIImageView()
            guard let url = URL(string: model.image ?? "") else {return}
            image.downloaded(from: url) { num in
                complition(num)
            }
            nameList.append(model.name ?? "")
            imageList.append(image)
            detailTextList.append(model.detailText ?? "")
        }
    }
    
    static func mp3Fetch() {
        PodcastAPI.mp3Fetch { model in
            mp3URLList.append(model.mp3URL ?? "")
            mp3NameList.append(model.name ?? "")
            mp3RunTimeList.append(model.runTime ?? "")
            mp3TimeList.append(model.time ?? "")
            mp3DetailText.append(model.detailText ?? "")
        }
    }
    
    static func timeFetch(num: String, string: String? = nil,size: CGFloat) -> NSMutableAttributedString {
        if let castingNum = Int(num) {
            let resultNum = ((castingNum % 3600) / 60, (castingNum % 3600) % 60)
            if resultNum.1 < 10 {
                let resultString = "\(resultNum.0):0\(resultNum.1)" + "  \(string ?? "")"
                let fontSize = UIFont.boldSystemFont(ofSize: size)
                let attributedStr = NSMutableAttributedString(string: resultString)
                attributedStr.addAttribute(.font, value: fontSize, range: (resultString as NSString).range(of: "\(resultNum.0):0\(resultNum.1)"))
                return attributedStr
            } else {
                let resultString = "\(resultNum.0):\(resultNum.1)" +  "  \(string ?? "")"
                let fontSize = UIFont.boldSystemFont(ofSize: size)
                let attributedStr = NSMutableAttributedString(string: resultString)
                attributedStr.addAttribute(.font, value: fontSize, range: (resultString as NSString).range(of: "\(resultNum.0):\(resultNum.1)"))
                return attributedStr
            }
        } else {
            return NSMutableAttributedString(string: "")
        }
    }
    
    
}



