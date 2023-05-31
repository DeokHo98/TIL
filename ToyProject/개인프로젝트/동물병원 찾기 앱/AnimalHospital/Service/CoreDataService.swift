//
//  CoreDataService.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/19.
//

import UIKit
import CoreData

struct CoreDataService {
    
  static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func uploadCoreData(name: String, address: String) {
        let model = Favorite(context: context)
        model.name = name
        model.address = address
        do {
            try context.save()
        } catch {
        }
    }
    
    static func loadCoreData(compltion: @escaping ([Favorite]) -> Void) {
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let model = try context.fetch(request)
            compltion(model)
        } catch {
        }
    }
    
    static func deleteCoreData(model: Favorite) {
        context.delete(model)
        do {
           try context.save()
        } catch {
        }
    }
}
