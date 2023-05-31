# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 직접 요약정리하여 공부하기 위해 작성하는 글입니다.
https://inf.run/YyoR

# KeyValuePairs

살짝 딕셔너리와 어레이를 합친느낌   
키와 값으로 연결되어있는데 순서도 있음   
그래서 해쉬어블할필요없음   

```swift

let introduce: KeyValuePairs = ["first": "Hello", "second": "My Name", "third":"is"]

//KeyValuePairs의 기본 기능   
introduce.count
introduce.isEmpty


//요소에 접근
// 배열처럼, 인덱스로 접근 가능
// 요소에서는 튜플방식으로 접근

introduce[0]



//print("\(introduce[0].key)는 \(introduce[0].value) 입니다.")
//print("\(introduce[1].key)는 \(introduce[1].value) 입니다.")
//print("\(introduce[2].key)는 \(introduce[2].value) 입니다.")


//반복문과의 결합

for value in introduce {
    print("\(value.key)는 \(value.value) 입니다.")
}



//:> append / remove 같은 기능이 없음
 
// 딕셔너리이지만, 저장된 순서가 중요할 경우, 또는 데이터가 반복될 경우만 임시적/제한적으로 사용