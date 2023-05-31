//
//  imageUploader.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/03/30.
//

import FirebaseStorage

struct ImageUploader {
    //프로필 이미지 픽커에서 선택한 이미지를 데이터로 바꾸고.
    //파이어베이스 스토리지에 데이터 형태로 저장합니다.
    static func uploadImage(image: UIImage, complition:@escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        ref.putData(imageData, metadata: nil) { metadata, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageURL = url?.absoluteString else { return }
                print("Debug: image Url \(imageURL)")
                complition(imageURL)
            }
        }
    }
}
