//
//  UserService.swift
//  TED_Clone
//
//  Created by 정덕호 on 2022/03/11.
//

import Firebase
import FirebaseFirestore

struct PodcastAPI {
    
   
    
    
    static func fetch(completion: @escaping(PodcastModel) -> Void) {
        let db = Firestore.firestore()
        db.collection("podcast").getDocuments { snapshot, error in
            if error != nil {
                print("팟캐스트 API 오류입니다.")
            } else {
                guard let documents = snapshot?.documents else {return}
                for doc in documents {
                    let model = PodcastModel(dic: doc.data())
                    completion(model)
                }
            }
        }
    }
    
    
    
    
    static func mp3Fetch(completion: @escaping(Mp3Model) -> Void) {
        let db = Firestore.firestore()
        db.collection("podcast").document("ESPANOL").collection("mp3").getDocuments { snpashot, error in
            if error != nil {
                print("팟캐스트 mp3 오류입니다")
            } else {
                guard let documents = snpashot?.documents else {return}
                for doc in documents {
                    let model = Mp3Model(dic: doc.data())
                    completion(model)
                }
            }
        }
    }
    
    
    
    
    
}


