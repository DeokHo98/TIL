# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

```swift
/*
# IOS의 네트워킹 =============================================================
어쨌든 서버와의 통신은 요청이있어야 응답이 일어난다
앱에서는 항상 제이슨 형태로 응답이 온다. JSON
ios에서의 과정은
 1. URL = url주소를 만들고.
 2. URLsession = urlsession객체를 생성하고.
 3. dataTsk = 거기다 url을 입력하고 일을 준다.
 4. 시작(resume) = 시작버튼을 누른다.
시작하면 이제 서버에 요청이가고 서버에서는 내부에있는 JSON데이터를 응답해줌
이 과정이 HTTP 편지지를 알아서 써서 요청메세지를 날려주는것이다. 그럼 서버에서 편지지를 다시 보내주겠지?
 
간단하게  요청을날리고 ==> JSON데이터를 응답받고 ==> class/struct 형태로 바꿔서 사용하면 됨
 
 
 

실제 네트워킹 통신 ======================================================
 
 참고 url
 
영화 진흥위원회 오픈 API = 영화데이터를 받는것
 https://www.kobis.or.kr/kobisopenapi/homepg/main/main.do


 요청주소
 요청paramether : REST 방식 / 요청방식은 3번항의 요청인터페이스 정보를 참조하여 GET방식으로 호출
 http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json


 키: 발급받은 개인의 키 값
 벨류: 조회하고자하는 날짜
 
 


 요청 예시
 
 http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json ?key=08feeb1b13d507521a8098ceb45bdbfe   &targetDt=20210201   &multiMovieYn=N


 JSON데이터를 스위프트 코드로 변환
 https://app.quicktype.io/
 
 
*/

//실제 통신 예시 =================================================

// 1. 변수에 url주소를 문자열로 저장
let movieUrl = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=08feeb1b13d507521a8098ceb45bdbfe&targetDt=20120101"



// 2. 애플이미리 만든 URL 구조체로 바꾸기
let structUrl = URL(string: movieUrl)! //애플이 만들어든 URL 구조체에 생성자중 string이 있음
//에러가날수있기때문에 옵셔널타입임



// 3. URL 세션을 생성

let sesseion = URLSession(configuration: .default)
let sesseion2 = URLSession.shared  //싱글톤(메모리에 객체를 딱 하나만 생성하는 녀석) 자주사용



// 4. URL 세션중 .dataTask를 사용 = 편지지를 쓰는것..
//밑에껄 조금 설명해보자면
//영화뭐시기 사이트 서버에 HTTP메시지 요청을보내고 JSON데이터로 응답이오면 그결과를 data, responese, error로 주는것.
sesseion2.dataTask(with: structUrl) { data, response, error in //관습적으로 에러를 먼저 확인
    if error != nil { //에러가있으면 그냥 바로 꺼버리는게 좋기때문에 가장 먼저 확인함 에러가 nil이 아니면
        print(error!) //에러를 프린트하고
        return //그냥 함수를 종료
    }
    
    if let safedata = data {
       print(String(decoding: safedata, as: UTF8.self)) //이건 데이터를 문자열로 바꿔주는 녀석인데 그냥 구글에 치면 나옴
    }
} .resume()


//아예 세션을 따로 담지 않고 사용하는것도 가능하다. (3단계 생략 가능)

URLSession.shared.dataTask(with: structUrl) { data, response, error in
    if error != nil {
        print(error!)
        return
    }
    
    if let safedata = data {
       print(String(decoding: safedata, as: UTF8.self))
    }
} .resume()





//사실 절대 외울 필요가없다 어떻게 사용하는지만 알면 필요할때마다 그냥 복붙해서 주소만 바꿔서 사용하면 된다!


//Session의 의미 ==================================
//일정시간동안 브라우저로부터 들어오는 연결상태를 유지하는 기술이나 연결상태를 의미
//쉽게말해 크롬에서의 탭 하나를 세션이라고 생각하면 됨
//세션 = 연결상태를 유지시키는 기술



```