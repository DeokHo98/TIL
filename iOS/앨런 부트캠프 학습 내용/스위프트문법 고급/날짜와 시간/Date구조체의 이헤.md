# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR



```swift

//문법강의보다는 프레임워크 사용법에 가까움


//UTC - 국제표준시간 - 협정세계시
//우리나라 = UTC + 9시간
//영국 오전 3시 ===> 우리나라 오후 12시


//애플이 미리 만들어둔 Date 구조체의 대한 이해 ================
//Date 구조체 타입
//특정한 시점의 시간
//특정 달력 (양력,음력) 이나 타임존에 영향을 받지않는 독립적인 시간

//날짜와 시간을 다루는 Date 구조체의 인스턴스
let date1 = Date() //인스턴스 생성시점의 날짜와 시간을생성, 기준시간으로부터 초단위 기준값을 가지고 있음 (기억)
print(date1) //그냥 출력하면 항상 UTC기준의 시간으로 출력




//내부적으로 시간을 어떻게 저장할까?

date1.timeIntervalSinceReferenceDate
//기준시간이 있고, 그시간을 기준, 초단위를 기준으로 저장
// 2001.1.1 0시 UTC시간을 기준으로

date1.timeIntervalSince1970
//1970.1.1 0시 기준

let oneSecond = TimeInterval(5.0) //5초간격


//암기하면 좋은 시간개념
//1시간 = 3600초
//24시간 = 86,400초

let 어제 = date1 - 86400
print(어제)


date1.timeIntervalSince(어제) //해당시점으로부터 차이를 초로 알려줌
date1.distance(to: 어제) //지금시점을 기준으로 그 시간까지의 거리를 초로 알려줌
어제.distance(to: date1)

date1.advanced(by: 86400)   //내일 시간
date1.addingTimeInterval(3600 * 24)
date1 + 86400


let 내일 = Date(timeIntervalSinceNow: 86400)




/*
 실제앱을 만들때 날짜를 제대로 다루려면
 
 달력을 다루는 Calendear 구조체의 도움도 필요 (양력인지 음력인지 등)
 문자열로 변형해주는 DateFormatter 클래스의 도움도 필요
 
 기본적으로 지역/타임존의 영향이 있음 그래서 때때로 바꿔줘야하는경우도 있음
 */



//스위프트 내부에 미리 정의 된 타임존 확인 해보기
for localeName in TimeZone.knownTimeZoneIdentifiers {
    print(localeName)
}
```