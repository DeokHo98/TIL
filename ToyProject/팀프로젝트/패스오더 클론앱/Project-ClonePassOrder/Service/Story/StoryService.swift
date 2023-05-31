//
//  StoryService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/13.
//

import Foundation
import Firebase
import Kingfisher

enum StoryServiceError: Error {
    var message: String {
        switch self {
        case .uploadError:
            return "실패했습니다 다시 시도해주세요!"
        case .fetchError:
            return "스토리를 받아오는것에 실패했습니다"
        case .snapShotError:
            return "스토리 정보가 없습니다"
        }
    }
    case uploadError
    case fetchError
    case snapShotError
}

protocol StoryServiceProtocol {
    func uploadStory(model: StoryModel,imageURL: String, completion: @escaping (Result<Void,StoryServiceError>) -> Void)
    func fetchStory(name: String, completion: @escaping (Result<[StoryModel],StoryServiceError>) -> Void)
    func imageFetch(urlString: String, completion: @escaping (Data) -> Void)
}

struct StoryService: StoryServiceProtocol {
    func uploadStory(model: StoryModel,imageURL: String, completion: @escaping (Result<Void,StoryServiceError>) -> Void) {
        let data: [String: Any] = [
            "cafeName": model.cafeName,
            "uid" : Auth.auth().currentUser?.uid ?? "",
            "userImage": UserViewModel.shared.model.profileImageUrl,
            "userName": UserViewModel.shared.model.userName,
            "text": model.text,
            "storyImage": imageURL,
            "time": Timestamp(date: Date())
        ]
        Firestore.firestore().collection("cafe").document(model.cafeName).collection("story").addDocument(data: data) { error in
            if error != nil {
                completion(.failure(.uploadError))
            } else {
                Firestore.firestore().collection("cafe").document(model.cafeName).updateData(["storyCount": (model.storyCount ?? 0) + 1])
                completion(.success(()))
            }
        }
    }
    func fetchStory(name: String, completion: @escaping (Result<[StoryModel],StoryServiceError>) -> Void) {
        Firestore.firestore().collection("cafe").document(name).collection("story").order(by: "time", descending: true).getDocuments { snapShot, error in
            if error != nil {
                completion(.failure(.fetchError))
            } else {
                guard let dic = snapShot?.documents else {
                    completion(.failure(.snapShotError))
                    return
                }
                let model = dic.map {
                    StoryModel(cafeName: $0.data()["cafeName"] as? String ?? "",
                               uid: $0.data()["uid"] as? String ?? "",
                               userImage: $0.data()["userImage"] as? String ?? "",
                               userName: $0.data()["userName"] as? String ?? "",
                               time: $0.data()["time"] as? Timestamp ?? Timestamp(date: Date()),
                               text: $0.data()["text"] as? String ?? "",
                               storyImage: $0.data()["storyImage"] as? String ?? ""
                    )
                }
                completion(.success(model))
            }
        }
    }
    func imageFetch(urlString: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else {return}
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                guard let imageData = value.image.pngData() else {
                    return
                }
                completion(imageData)
            case .failure(_):
                break
            }
        }
    }
}
