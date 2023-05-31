//
//  StoryUnitTest.swift
//  UnitTest
//
//  Created by 정덕호 on 2022/06/13.
//

import XCTest
import Firebase

class StoryUnitTest: XCTestCase {

    override func setUpWithError() throws {
       try super.setUpWithError()
    }

    override func tearDownWithError() throws {
       try super.tearDownWithError()
    }

    func test_model의_데이터가_원하는형태로_viewModelItem의_변수에_담기는지() {
        //given
        let date = Date(timeIntervalSince1970: 0)
        let model = StoryModel(cafeName: "cafe", uid: "uid", userImage: "userimage", userName: "username", time: Timestamp(date: date), text: "text", storyImage: "storyimage", imageData: nil, storyCount: nil)
        let viewModel = StoryViewModelItem(model: model)
        //then
        XCTAssertEqual(viewModel.userName, model.userName)
        XCTAssertEqual(viewModel.storyText, model.text)
        XCTAssertEqual(viewModel.time, "1970년 01월 01일")
    }
    func test_WriteStoryViewModel의_uploadImage_호출시_model의_imageData가_없는경우_imageEmpty에_사진을등록해주세요_라는_문자열이_전달되는지() {
        //given
        let sut = WriteStoryViewModel()
        sut.model.imageData = nil
        
        //when
        sut.uploadImage()
        
        //then
        XCTAssertEqual(sut.imageEmpty.value, "사진을 등록해주세요!")
    }
    func test_WriteStoryViewModel의_uploadImage_호출시_이미지업로드에_성공하는경우_uploadImageSuccess에_imageURL이_전달되는지() {
        //given
        let sut = WriteStoryViewModel()
        sut.model.imageData = Data()
        var mockService = MockImageUploaderService()
        mockService.result = .success("imageurl")
        sut.imageUploader = mockService
        
        //when
        sut.uploadImage()
        
        //then
        XCTAssertEqual(sut.uploadImageSuccess.value, "imageurl")
    }
    func test_WriteStoryViewModel의_uploadImage_호출시_이미지업로드에_실패하는경우_에러가_imageUpLoaderError에_전달되는지() {
        //given
        let sut = WriteStoryViewModel()
        sut.model.imageData = Data()
        var mockService = MockImageUploaderService()
        mockService.result = .failure(.downLoadImageFaildError)
        sut.imageUploader = mockService
        
        //when
        sut.uploadImage()
        
        //then
        XCTAssertEqual(sut.imageUploaderError.value, .downLoadImageFaildError)
    }
    func test_WriteStoryViewModel의_uploadStory_호출시_성공하는경우_uploadStorySuccess에_true가_전달되는지() {
        //given
        let sut = WriteStoryViewModel()
        var mockService = MockStoryService()
        mockService.uploadResult = .success(())
        sut.storyService = mockService
        
        //when
        sut.uploadStory(imageURL: "imageurl")
        
        //then
        XCTAssertTrue(sut.uploadStorySuccess.value)
    }
    func test_WriteStoryViewModel의_uploadStory_호출시_실패하는경우_에러가_storyServiceError에_전달되는지() {
        //given
        let sut = WriteStoryViewModel()
        var mockService = MockStoryService()
        mockService.uploadResult = .failure(.fetchError)
        sut.storyService = mockService
        
        //when
        sut.uploadStory(imageURL: "imageurl")
        
        //then
        XCTAssertEqual(sut.storyServiceError.value, .fetchError)
    }
    func test_StoryListViewModel의_count_실행시_items의_갯수가_반환되는지() {
        //given
        let model = StoryModel(cafeName: "", uid: "", userImage: "", userName: "", time: Timestamp(date: Date()), text: "", storyImage: "", imageData: Data(), storyCount: 0)
        let sut = StoryListViewModel()
        sut.items = [StoryViewModelItem(model: model), StoryViewModelItem(model: model)]
        
        //when
        let valid = sut.count()
        
        //then
        XCTAssertEqual(valid, 2)
    }
    func test_StoryListViewModel의_itemAtIndex_호출시_원하는_index의_item이_반환되는지() {
        //given
        let model = StoryModel(cafeName: "", uid: "", userImage: "", userName: "", time: Timestamp(date: Date()), text: "", storyImage: "", imageData: Data(), storyCount: 0)
        let model2 = StoryModel(cafeName: "cafe", uid: "uid", userImage: "image", userName: "name", time: Timestamp(date: Date()), text: "text", storyImage: "image", imageData: Data(), storyCount: 0)
        let sut = StoryListViewModel()
        sut.items = [StoryViewModelItem(model: model), StoryViewModelItem(model: model2)]
        
        //when
        let valid = sut.itemAtIndex(1)
        
        //then
        XCTAssertEqual(valid, sut.items[1])
    }
    func test_StoryListViewModel의_fetchStory_호출시_성공하는경우_model값이전달되어_맵핑된뒤_items에_담기는지() {
        //given
        let sut = StoryListViewModel()
        let models = [StoryModel(cafeName: "", uid: "", userImage: "", userName: "", time: Timestamp(date: Date()), text: "", storyImage: "", imageData: Data(), storyCount: 0)]
        var mockService = MockStoryService()
        mockService.fetchResult = .success(models)
        sut.storyService = mockService
        //when
        sut.fetchStory(name: "name")
        
        //then
        XCTAssertEqual(sut.items[0].model, models[0])
    }
    func test_StoryListViewModel의_fetchStory_호출시_실패하는경우_에러가_storyServiceError에_담기는지() {
        //given
        let sut = StoryListViewModel()
        var mockService = MockStoryService()
        mockService.fetchResult = .failure(.fetchError)
        sut.storyService = mockService
        
        //when
        sut.fetchStory(name: "name")
        
        //then
        XCTAssertEqual(sut.storyServiceError.value, .fetchError)
    }

}
