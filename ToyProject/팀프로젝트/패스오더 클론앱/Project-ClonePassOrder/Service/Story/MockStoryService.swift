//
//  MockStoryService.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/13.
//

import Foundation

struct MockStoryService: StoryServiceProtocol {
    
    var uploadResult: Result<Void,StoryServiceError>!
    var fetchResult: Result<[StoryModel],StoryServiceError>!
    
    func uploadStory(model: StoryModel, imageURL: String, completion: @escaping (Result<Void, StoryServiceError>) -> Void) {
        completion(uploadResult!)
    }
    
    func fetchStory(name: String, completion: @escaping (Result<[StoryModel], StoryServiceError>) -> Void) {
        completion(fetchResult!)
    }
    
    func imageFetch(urlString: String, completion: @escaping (Data) -> Void) {
        completion(Data())
    }
    
    
}
