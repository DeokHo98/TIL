
# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

```swift
//DateFormatter의 이해
//DateFormatter = 날짜를 문자열로 변형시켜주는 클래스, 문자열을 날짜로도 변형 가능
//RFC 3339 표준으로 작성(스위프트가 아닌 다른 표준을 사용)
//Date를 특정형식의 문자열로 변환하려면 => 지역설정 , 시간대설정 , 날짜형식 , 시간형식  순서대로 작성해야함

//날짜 + 시간 <====> 문자열

let formatter = DateFormatter()


//지역설정
formatter.locale = Locale(identifier: "ko_KR")
//이렇게하면 한국 달력처럼 연 월 일 주 로 나옴

//시간대 설정
formatter.timeZone = TimeZone.current //가장많이씀

//날짜 형식
formatter.dateStyle = .full           // "Tuesday, April 13, 2021"
//formatter.dateStyle = .long         // "April 13, 2021"
//formatter.dateStyle = .medium       // "Apr 13, 2021"
//formatter.dateStyle = .none         // (날짜 없어짐)
//formatter.dateStyle = .short        // "4/13/21"


//시간 형식
formatter.timeStyle = .full           // "2:53:12 PM Korean Standard Time"
//formatter.timeStyle = .long         // "2:54:52 PM GMT+9"
//formatter.timeStyle = .medium       // "2:55:12 PM"
//formatter.timeStyle = .none         // (시간 없어짐)
//formatter.timeStyle = .short        // "2:55 PM"


// 실제 변환하기 (날짜 + 시간) ===> 원하는 형식
let someString1 = formatter.string(from: Date())
print(someString1)



//커스텀 형식으로 생성하는법
//formatter.locale = Locale(identifier: "ko_KR")
//formatter.dateFormat = "yyyy/MM/dd"
formatter.dateFormat = "yyyy년 MMMM d일 (E)" //dateFormat로 커스텀가능
//y:연도 M:월 d:일 E:요일 자세한건 밑에 링크에 있음 이건 유니코드에서 지정..


let someString2 = formatter.string(from: Date())
print(someString2)


// 문자열로 만드는 메서드
//formatter.string(from: <#T##Date#>)
 



/*
 - 날짜/시간 형식: http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns (유니코드에서 지정)
 */




//반대로 문자열에서 Date로 변환도 가능

let newFormatter = DateFormatter()
newFormatter.dateFormat = "yyyy/MM/dd"

let someDate = newFormatter.date(from: "2021/07/12")!
print(someDate)




//두 날짜 범위 출력 코드 구현(인수를 구하는게아님)
let start = Date()
let end = start.addingTimeInterval(3600 * 24 * 100)

let formatter2 = DateFormatter()
formatter2.locale = Locale(identifier: "ko_KR")
formatter2.timeZone = TimeZone.current
formatter2.dateStyle = .full
formatter2.timeStyle = .short

print("기간: \(formatter2.string(from: start)) ~ \(formatter2.string(from: end))")





//실제 프로젝트 활용 예시 (인스타그램에 게시글을 올렸을때 날짜 시간이 뜨는것..)

struct InstagramPost {
    let title: String = "제목"
    let description: String = "내용설명"
    
    private let date: Date = Date()  // 게시물 생성을 현재날짜로
    
    // 날짜를 문자열 형태로 바꿔서 리턴하는 계산 속성
    var dateString: String {
        get {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            //formatter.locale = Locale(identifier: Locale.autoupdatingCurrent.identifier)
            
            // 애플이 만들어 놓은
            formatter.dateStyle = .medium
            formatter.timeStyle = .full
            
            // 개발자가 직접 설정한
            //formatter.dateFormat = "yyyy/MM/dd"
            
            return formatter.string(from: date)
        }
    }
}



let post1 = InstagramPost()
print(post1.dateString)
```