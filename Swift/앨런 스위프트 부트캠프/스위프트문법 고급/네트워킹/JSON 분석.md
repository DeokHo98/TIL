# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR


```swift
//받아온 데이터를 우리가 쓰기좋게 클래스나 구조체로 변환하는 과정 (분석) =============================================================
//데이터를 우리가 사용하려는 형태 (구조체/클래스) 로 변형해서 사용해야함

let structUrl = URL(string: "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=08feeb1b13d507521a8098ceb45bdbfe&targetDt=20211215")!




URLSession.shared.dataTask(with: structUrl) { data, response, error in
    
    guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= //~=는 범위를 체크하는 연산자
            response.statusCode else {
        print("Error: HTTP request ailed")
        return
    }
    //대충 받아온 리스폰스.statusCode가 200~299 범위안에있으면 그니깐 성공이면(2xx) 다음으로 넘어가고 아니면 에러 메시지를 출력해라 뭐 이런뜻
    
    let safeData = data!
     dump(parsedJSON(safeData)!) //분석하는 함수를 프린트 (옵셔널이기때문에 벗겨줘야함)
} .resume()
//dump는 프린트랑 비슷한 녀석인데 좀더 깔끔하게 해주는녀석










//https://app.quicktype.io/ 에서 변환한 코드(서버에서 주는 데이터 형테) =============================================================
//실제 맨위에 링크 "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=08feeb1b13d507521a8098ceb45bdbfe&targetDt=20211215") 이걸 변환사이트에 넣으면
//아래코드가 나온다



struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable {
    let rank: String
    let movieNm: String
    let openDt: String
}



//Decodable: 이 프로토콜을 채택해야지만 JSONDecoder에서 코드를 자동으로 분석할수있다.
// 데이터 => 구조체 클래스로 분석
//Encodable: 구조체나 클래스를 데이터로 변경시켜주는 녀석 구조체/클래스 => 데이터로 분석
//이 두개를 합친게 Codable






//받아온 데이터를 분석하는 함수 ========================================================================================
func parsedJSON(_ moviedData: Data) -> [DailyBoxOfficeList]? { //옵셔널임
    do {
        //스위프트5 버전 이후
        //자동으로 원하는 클래스/구조체 형태로 분석해줌
        //JSONDecoder
        let decoder = JSONDecoder() //JSONDecoder = 데이터를 코드형태로 분석하는 클래스
        
        let decodedData = try decoder.decode(MovieData.self, from: moviedData)
        // .decode 라는 함수가 throws 이기때문에 에러를 발생시킬수도 있어 try 키워드 그리고 Do-catch로 쓴것
        return decodedData.boxOfficeResult.dailyBoxOfficeList
        
    } catch {
        return nil
    }
}


```