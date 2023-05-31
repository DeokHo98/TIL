//
//  ImageLoader.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/21.
//

import UIKit

var imageCache = NSCache<NSString, UIImage>()

struct ImageLoader {
    static func fetchImage(url: String, compliton: @escaping (UIImage) -> Void) {
        
        DispatchQueue.global(qos: .default).async {
            let cachedKey =  NSString(string: url)
            //이미지가 캐시에 있는지 확인
            //캐시에 이미지가 있으면 이미지를 바로 전달
            if let cachedImage = imageCache.object(forKey: cachedKey) {
                compliton(cachedImage)
                return
            }
        
        //없는 경우 url통신 시작
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { data, respones, error in
            if error != nil {
                guard let image = UIImage(named: "이미지가없습니다") else {return}
                compliton(image)
                return
            }
            
            guard let imageData = data else {return}
            
            guard let photoImage = UIImage(data: imageData) else {return}
            
            //그리고 캐시에 넣어줌 그럼 다음부터는 url 통신을 안해도됨
            imageCache.setObject(photoImage, forKey: cachedKey)
            
            
            compliton(photoImage)
        }.resume()
        }
    }
}
