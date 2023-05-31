//
//  Favorite.swift
//  UnitTest
//
//  Created by 정덕호 on 2022/06/14.
//

import XCTest

class Favorite: XCTestCase {
    
    var sut: FavoriteListViewModel!
    var model: CafeListModel!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = FavoriteListViewModel()
        model = CafeListModel.EMPTY
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        model = nil
    }
    func test_count_호출시_items의_갯수를_반환하는지() {
        //given
        sut.items = [CafeListViewModelItem(model: model),CafeListViewModelItem(model: model),CafeListViewModelItem(model: model)]
        
        //when
        let valid = sut.count()
        
        //then
        XCTAssertEqual(valid, sut.items.count)
    }
    func test_itemAtIndex_호출시_items의_원하는_인덱스의_item이_반환되는지() {
        //given
        let model2 = CafeListModel(name: "", storyCount: 2, favoriteCount: 2, imageURL: "", lat: 2, lon: 2, orderTime: "", newTime: "", info: "", benefit: "", openTime: "", offDay: "", phoneNumber: "", address: "")
        sut.items = [CafeListViewModelItem(model: model),CafeListViewModelItem(model: model2),CafeListViewModelItem(model: model)]
        
        //when
        let valid = sut.itemAtIndex(1)
        
        //then
        XCTAssertEqual(valid, sut.items[1])
    }
    func test_addFavorite_호출시_favoriteBool에_true가_전달되는지() {
        //given
        let mockService = MockFavoriteService()
        sut.service = mockService
        
        //when
        sut.addFavorite(model: model)
        
        //then
        XCTAssertTrue(sut.favoriteBool.value)
    }
    func test_deleteFavorite_호출시_favoriteBool에_false가_전달되는지() {
        //given
        let mockService = MockFavoriteService()
        sut.service = mockService
        
        //when
        sut.deleteFavorite(model: model)
        
        //then
        XCTAssertFalse(sut.favoriteBool.value)
    }
    func test_fetchFavoriteID_호출시_성공하는경우_items배열에_빈배열이전달되고_ID배열이_fetchFavoriteIDSuccess에_전달되는지() {
        //given
        var mockService = MockFavoriteService()
        mockService.fetchIDResult = .success(["ID"])
        sut.service = mockService
        
        //then
        sut.fetchFavoriteID()
        
        //then
        XCTAssertEqual(sut.items, [])
        XCTAssertEqual(sut.fetchFavoriteIDSuccess.value, ["ID"])
    }
    func test_fetchFavoriteID_호출시_실패하는경우_favoriteError에_에러가_전달되는지() {
        //given
        var mockService = MockFavoriteService()
        mockService.fetchIDResult = .failure(.fetchError)
        sut.service = mockService
        
        //when
        sut.fetchFavoriteID()
        
        //then
        XCTAssertEqual(sut.favoriteError.value, .fetchError)
    }
    func test_fetchCafeList_호출시_성공하는경우_전달되는_model로_ViewModel이_생성되어_items에_추가되고_fetchFavoriteSuccess에_ture가_전달되는지() {
        //given
        let model = CafeListModel.EMPTY
        var mockService = MockFavoriteService()
        mockService.fetchCafeListResult = .success(model)
        sut.service = mockService
        
        //when
        sut.fetchCafeList(ID: ["ID"])
        
        //then
        XCTAssertEqual(sut.items[0].model, model)
        XCTAssertTrue(sut.fetchFavoriteSuccess.value)
    }
    func fetchCafeList_호출시_실패하는경우_favoriteError에_에러가_전달되는지() {
        //given
        var mockService = MockFavoriteService()
        mockService.fetchCafeListResult = .failure(.fetchError)
        sut.service = mockService
        
        //when
        sut.fetchCafeList(ID: ["ID"])
        
        //then
        XCTAssertEqual(sut.favoriteError.value, .fetchError)
    }
    func test_existsFavorite_호출시_성공하는경우_전달된_bool값이_favoriteBool에_전달되는지() {
        //given
        var mockService = MockFavoriteService()
        mockService.existsResult = .success(true)
        sut.service = mockService
        
        //when
        sut.existsFavorite(model: model)
        
        //then
        XCTAssertTrue(sut.favoriteBool.value)
    }
    func test_existsFavorite_호출시_실패하는경우_전달된_에러가_favoriteError에_전달되는지() {
        //given
        var mockService = MockFavoriteService()
        mockService.existsResult = .failure(.existsError)
        sut.service = mockService
        
        //when
        sut.existsFavorite(model: model)
        
        //then
        XCTAssertEqual(sut.favoriteError.value, .existsError)
    }

}
