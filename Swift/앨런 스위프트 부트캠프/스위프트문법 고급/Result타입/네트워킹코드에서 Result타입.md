# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR


```swift
//네트워킹 코드에서 Result타입의 활용

enum NetworkError: Error {
    case someError
}

//Result타입 사용전 =====================================
// 튜플타입을 활용, 데이터 전달

func performRequest(with url: String, completion: @escaping (Data?, NetworkError?) -> Void) {
    
    guard let url = URL(string: url) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print(error!)                 // 에러가 발생했음을 출력
            completion(nil, .someError)   // 에러가 발생했으니, nil 전달
            return
        }
        
        guard let safeData = data else {
            completion(nil, .someError)   // 안전하게 옵셔널 바인딩을 하지 못했으니, 데이터는 nil 전달
            return
        }
    
        completion(safeData, nil)
        
    }.resume()
}



performRequest(with: "주소") { data, error in
    if error != nil {
        print(error!.localizedDescription)
}
    
    // 데이터 처리 관련 코드
}


//Result 타입 사용후 ===========================================

func performRequest2(with urlString: String, completion: @escaping (Result<Data,NetworkError>) -> Void) {
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print(error!)                     // 에러가 발생했음을 출력
            completion(.failure(.someError))  // 실패 케이스 전달
            return
        }
        
        guard let safeData = data else {
            completion(.failure(.someError))   // 실패 케이스 전달
            return
        }
    
        completion(.success(safeData))      // 성공 케이스 전달
       
        
    }.resume()
}






performRequest2(with: "주소") { result in
    switch result {
    case .success(let data):
        print(data)
    case .failure(let error):
        print(error.localizedDescription)
    }
}



//결론은 Result타입은 하나의 열거형으로 구현되어있다. 그내부도 제네릭으로 구현되어있어서 구체적으로 어떤타입으로도 쓸수 있다.

//Result Type을 활용하면,
//
//에러 형식이 명시적으로 선언됩니다.
//타입 캐스팅 없이 에러 처리가 가능해졌습니다.
//형식 추론을 통해 에러 처리 코드가 단순해졌습니다.
//작업의 결과를 성공과 실패로 명확히 구분 가능합니다.
//get 메소드로 에러 처리 코드를 더욱 단순하게 구현 가능합니다.
//기존 에러 처리 패턴을 완전히 대체하는 것이 아니라 에러를 처리하는 방식이 다양해진 것입니다.
```