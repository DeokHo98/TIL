//
//  StoryViewModel.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/06/13.
//

import Foundation
import Firebase

final class StoryListViewModel {
    
    init(service: StoryServiceProtocol = StoryService()) {
        self.storyService = service
    }
    
    var storyService: StoryServiceProtocol
    var items: [StoryViewModelItem] = []
    var storyServiceError: Observer<StoryServiceError> = Observer(value: .uploadError)
    
    func count() -> Int {
        self.items.count
    }
    func itemAtIndex(_ index: Int) -> StoryViewModelItem {
        let item = self.items[index]
        return item
    }
    func fetchStory(name: String) {
        storyService.fetchStory(name: name) { [weak self] result in
            switch result {
            case .success(let models):
                let items = models.map {
                    StoryViewModelItem(model: $0)
                }
                items.forEach { item in
                    self?.storyService.imageFetch(urlString: item.model.userImage, completion: { data in
                        item.userImage = data
                    })
                    self?.storyService.imageFetch(urlString: item.model.storyImage, completion: { data in
                        item.storyImage = data
                    })
                }
                self?.items = items
            case .failure(let error):
                self?.storyServiceError.value = error
            }
        }
    }
}

final class StoryViewModelItem: Equatable {
    static func == (lhs: StoryViewModelItem, rhs: StoryViewModelItem) -> Bool {
        lhs.userName == rhs.userName &&
        lhs.storyImage == rhs.storyImage &&
        lhs.storyText == rhs.storyText
    }
    
    

    init(model: StoryModel) {
        self.model = model
    }
    
    let model: StoryModel
 
    var userImage: Data?
    var storyImage: Data?
    var userName: String {
        return model.userName
    }
    var storyText: String {
        return model.text
    }
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let date = model.time.dateValue()
        return formatter.string(from: date)
    }
    
}

final class WriteStoryViewModel {
    init(service: StoryServiceProtocol = StoryService(),imageUploader: ImageUploaderServiceProtocol = ImageUploaderService()) {
        self.storyService = service
        self.imageUploader = imageUploader
    }
    
    var imageUploader: ImageUploaderServiceProtocol
    var storyService: StoryServiceProtocol
    var imageEmpty: Observer<String> = Observer(value: "")
    var storyServiceError: Observer<StoryServiceError> = Observer(value: .uploadError)
    var imageUploaderError: Observer<ImageUploaderError> = Observer(value: .URLError)
    var uploadImageSuccess: Observer<String> = Observer(value: "")
    var uploadStorySuccess: Observer<Bool> = Observer(value: false)
    
    var model = StoryModel.EMPTY
    
    func uploadImage() {
        guard let imageData = model.imageData else {
            imageEmpty.value = "사진을 등록해주세요!"
            return
        }
        imageUploader.uploadImage(fileName: "스토리", imageData: imageData) { [weak self] result in
            switch result {
            case .success(let url):
                self?.uploadImageSuccess.value = url
            case .failure(let error):
                self?.imageUploaderError.value = error
            }
        }
    }
    func uploadStory(imageURL: String) {
        storyService.uploadStory(model: model, imageURL: imageURL) { [weak self] result in
            switch result {
            case .success():
                self?.uploadStorySuccess.value = true
            case .failure(let error):
                self?.storyServiceError.value = error
            }
        }
    }
}
