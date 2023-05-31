# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

``` swift
//캘린더 구조체의 이해 - 스위프트에서 기본으로 제공해주는 달력 구조체타입 =========================

//"절대시점(Date)"를 연대/연도/날짜/요일과 같은 "달력의요소"로 변환을 돕는 객체

//그레고리력 - 양력 - 전세계표준 달력
var calendar = Calendar.current //current는 양력으로 반환


//지역 설정 => 나라(지역) 마다 날짜와 시간을 표시하는 형식과 언어가 다름

calendar.locale //달력의 지역(영어/한국어) (달력 표기방법과 관련된 개념) (한국은 연도 월 일 순서대로 쓰는것같은거)
calendar.timeZone //타임존 ===> Asia/Seoul (UTC 시간관련된 개념)


//이런건 그냥 나중에 찾아서 쓰면됨
calendar.locale = Locale(identifier: "ko_KR")
calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!



let now = Date()



//Date의 년월일시분초를 확인하는방법

//1. 날짜 ~ 년월일
let year: Int = calendar.component(.year, from: now)
let month: Int = calendar.component(.month, from: now)
let day: Int = calendar.component(.day, from: now)
print(year,month,day)

//2. 시분초
let hour: Int = calendar.component(.hour, from: now)
let minute: Int = calendar.component(.minute, from: now)
let second: Int = calendar.component(.second, from: now)

//실제 앱에서 표시할땐 위와 같은 식으로 분리해서, 레이블에 표시가 가능


//3. 요일

let weekday: Int = calendar.component(.weekday, from: Date())

switch weekday {
case 1:
    print("일요일입니다")
case 2:
    print("월요일입니다")
case 3:
    print("화요일입니다")
case 4:
    print("수요일입니다")
case 5:
    print("목요일입니다")
case 6:
    print("금요일입니다")
case 7:
    print("토요일입니다")
default:
    print("에러")
}



//하나의 요소가 아닌 여러개의 데이터를 한번에 얻는 방법 (DateComponents)

let myCal = Calendar.current

var myDateCom = myCal.dateComponents([.year, .month, .day], from: now)
myDateCom.year
myDateCom.month
myDateCom.day

print(myDateCom.year!,myDateCom.month!,myDateCom.day!)



//실제 프로젝트에서 활용 방식
//달력 기준으로, 나이 계산하기

class Dog {
    var name: String
    var yearOfBirth : Int
    
    init(name: String, year: Int) {
        self.name = name
        self.yearOfBirth = year
    }

    var age: Int {
        get {
            let year = Calendar.current.component(.year, from: Date())
            return year - yearOfBirth
        }
    }
}

let choco = Dog(name: "초코", year: 2010)
print("강아지의 나이는 \(choco.age)살 입니다")


//열거형으로 요이을 만들고 오늘의 요일을 계산하기

enum Weekday: Int {
    case 일 = 1 , 월,화,수,목,금,토
    
    //타입 계산속성
    static var today: Weekday {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return Weekday(rawValue: weekday)!
    }
}

let today = Weekday.today
print("오늘은 \(today)요일입니다")


//두 날짜 사이의 일수 계산하기

let startDate = Date()
let endDate = startDate.addingTimeInterval(3600 * 24 * 60)


let somedays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!

print("\(somedays)일 후")



//마지막으로 한번도 얘기하지만 외울필요가 없다!
//그냥 필요할때마다 골라서 살짝살짝 쓰면 된다.
```