//
//  ADUnitTest.swift
//  UnitTest
//
//  Created by 정덕호 on 2022/06/02.
//

import XCTest
@testable import Project_ClonePassOrder

class ADUnitTest: XCTestCase {
    
    var sut: ADListViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ADListViewModel()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_ADModel이_ADViewModelItem에_원하는값으로_담기는지() {
        //given
        let model = ADModel(ADImageUrl: "imageUrl")
        let item: ADViewModelItem = ADViewModelItem(model: model)
        
        //then
        XCTAssertEqual(item.ADImageURL, URL(string: model.ADImageUrl))
    }
    func test_count호출시_items의_count를_리턴하는지() {
        //given
        let model = ADModel(ADImageUrl: "imageurl1")
        let items = [ADViewModelItem(model: model),ADViewModelItem(model: model)]
        sut.items = items
        
        //when
        let valid = sut.count()
        
        //then
        XCTAssertEqual(valid, items.count)
    }
    func test_itemAtIndex호출시_index에맞는_item을_리턴하는지() {
        //given
        let model1 = ADModel(ADImageUrl: "imageurl1")
        let model2 = ADModel(ADImageUrl: "imageurl2")
        let items = [ADViewModelItem(model: model1),ADViewModelItem(model: model2)]
        sut.items = items
        
        //when
        let valid = sut.itemAtIndex(0)
        
        //then
        XCTAssertEqual(valid, items[0])
    }
    func test_fetchAD호출시_성공하는경우_items에_ViewModelItem배열이_담기는지() {
        //given
        let models = [ADModel(ADImageUrl: "imageUrl"),ADModel(ADImageUrl: "imageUrl2")]
        let items = [ADViewModelItem(model: models[0]),ADViewModelItem(model: models[1])]
        var mockADService = MockADService()
        mockADService.result = .success(models)
        sut.adService = mockADService
        
        //when
        sut.fetchAD(collectionName: "firstAD")
        
        //then
        XCTAssertEqual(sut.items, items)
    }
    
    func test_fetchAD호출시_실패하는경우_ADFetchError인경우_ADServiceError에담기는지() {
        //given
        var mockADService = MockADService()
        mockADService.result = .failure(.ADFetchError)
        sut.adService = mockADService
        
        //when
        sut.fetchAD(collectionName: "firstAD")
        
        //then
        XCTAssertEqual(sut.ADServiceError.value , .ADFetchError)
    }
    func test_fetchAD호출시_실패하는경우_snapShotError인경우_ADServiceError에담기는지() {
        //given
        var mockADService = MockADService()
        mockADService.result = .failure(.snapShotError)
        sut.adService = mockADService
        
        //when
        sut.fetchAD(collectionName: "firstAD")
        
        //then
        XCTAssertEqual(sut.ADServiceError.value , .snapShotError)
    }
    func test_ADserviceError의_값이변경되었을때_바인딩_되었는지() {
        //given
        
        sut.ADServiceError.bind { error in
            //then
            
            XCTAssertEqual(error, .ADFetchError)
        }
        
        //when
        sut.ADServiceError.value = .ADFetchError
        
    }
}
