//
//  EditService.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/17.
//

import Firebase
import UIKit


struct EditService {
    static func uploadEditData(type: String, name: String, text: String,compliton: @escaping (Error?) -> Void) {
        let db = Firestore.firestore().collection(type)
        db.document().setData(["병원이름": name,"수정내용" : text]) { error in
            compliton(error)
        }
    }
    
    static func report(name: String, address: String, compltion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore().collection("새로운 병원 제보")
        db.document().setData(["병원이름": name,"위치" : address]) { error in
            compltion(error)
        }
    }
}
