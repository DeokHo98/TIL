# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

# get메서드
(예) 인스타그램 - 내가 팔로잉하는 사람들의 게시글 보기
```swift

func getMethod() {
    
    // URL구조체 만들기
    guard let url = URL(string: "http://dummy.restapiexample.com/api/v1/employees") else {
        print("Error: cannot create URL")
        return
    }
    
    // URL요청 생성
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    
    // 요청을 가지고 작업세션시작
    URLSession.shared.dataTask(with: request) { data, response, error in
        // 에러가 없어야 넘어감
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            return
        }
        // 옵셔널 바인딩
        guard let safeData = data else {
            print("Error: Did not receive data")
            return
        }
        // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
            
        // 원하는 모델이 있다면, JSONDecoder로 decode코드로 구현 ⭐️
        print(String(decoding: safeData, as: UTF8.self))


    }.resume()     // 시작
}


getMethod()


```

# POST메서드
(예) 인스타그램 - 나의 포스트 올리기 / 다른 사람의 게시물에 댓글 달기 / 서비스 가입하기
```swift
func postMethod() {
    
    guard let url = URL(string: "http://dummy.restapiexample.com/api/v1/create") else {
        print("Error: cannot create URL")
        return
    }
    
    // 업로드할 모델(형태)
    struct UploadData: Codable {
        let name: String
        let salary: String
        let age: String
    }
    
    // 실제 업로드할 (데이터)인스턴스 생성
    let uploadDataModel = UploadData(name: "Jack", salary: "3540", age: "23")
    
    // 모델을 JSON data 형태로 변환
    guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
        print("Error: Trying to convert model to JSON data")
        return
    }
    
    // URL요청 생성
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type") // 요청타입 JSON
    request.setValue("application/json", forHTTPHeaderField: "Accept") // 응답타입 JSON
    request.httpBody = jsonData
    
    
    // 요청을 가지고 세션 작업시작
    URLSession.shared.dataTask(with: request) { data, response, error in
        // 에러가 없어야 넘어감
        guard error == nil else {
            print("Error: error calling POST")
            print(error!)
            return
        }
        // 옵셔널 바인딩
        guard let safeData = data else {
            print("Error: Did not receive data")
            return
        }
        // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        
        // 원하는 모델이 있다면, JSONDecoder로 decode코드로 구현 ⭐️
        print(String(decoding: safeData, as: UTF8.self))
        
    }.resume()   // 시작
}

postMethod()
```

# PUT 메서드
(예) 인스타그램 - 나의 포스트 수정하기 / 다른 사람 게시물의 좋아요 누르기 / 나의 정보 수정
```swift
func putMethod() {
    guard let url = URL(string: "https://reqres.in/api/users/2") else {
        print("Error: cannot create URL")
        return
    }
    
    // 업로드할 모델(형태)
    struct UploadData: Codable {
        let name: String
        let job: String
    }
    
    // 실제 업로드할 (데이터)인스턴스 생성
    let uploadDataModel = UploadData(name: "Nicole", job: "iOS Developer")
    
    // 모델을 JSON data 형태로 변환
    guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
        print("Error: Trying to convert model to JSON data")
        return
    }
    
    // URL요청 생성
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    // 요청을 가지고 작업세션시작
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling PUT")
            print(error!)
            return
        }
        guard let safeData = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        
        // 원하는 모델이 있다면, JSONDecoder로 decode코드로 구현 ⭐️
        print(String(decoding: safeData, as: UTF8.self))
        
    }.resume()
}

putMethod()
```

# Delete메서드(데이터삭제)
(예) 인스타그램 - 나의 포스트 삭제하기
```swift
func deleteMethod() {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
        print("Error: cannot create URL")
        return
    }
    
    // URL요청 생성
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    
    // 요청을 가지고 작업세션시작
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling DELETE")
            print(error!)
            return
        }
        guard let safeData = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        
        // 원하는 모델이 있다면, JSONDecoder로 decode코드로 구현 ⭐️
        print(String(decoding: safeData, as: UTF8.self))
        
    }.resume()
}

deleteMethod()
```