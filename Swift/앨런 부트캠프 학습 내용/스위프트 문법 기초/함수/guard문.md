# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 직접 요약정리하여 공부하기 위해 작성하는 글입니다.
https://inf.run/YyoR

# guard문
불만족하는 조건을 먼저 걸러내는 조건문   
    
조건문에는 if문이 있는데 if문의 단점은 여러개의 조건이 있을경우 코드의 가독설이 문제가 된다.   
이러한 단점을 극복한것이 스위프트에만 있는 guard문이다.   

guard문은 쉽게   
1. else문을 먼저 배치 - 먼저 조건을 판별하여 조기 종료
2. 조건을 만족하는 경우 코드가 다음 줄로 넘어가서 계속 실행   
3. 가드문에서 선언된 변수를 아래 문장에서 사용 가능  (guard let 바인딩에서 관련)

```swift
//if문
func checkNumbersOf1(password: String) -> Bool {
    if password.count >= 6 {
        return true
    } else {
        return false
    }
}

//guard문

func checkNumbersOf2(password: String) -> Bool {
    guard password.count >= 6 else { // else가 먼저 나온다는건 조건을 만족하면 밑으로 내려가! 아니면 그냥 여기서 끝내 라는 뜻이다.
        return false        //함수에서 가드문은 꼭 얼리에셋이 들어가야함 return이나 throw
    }
    return true
}

//가드문의 예제

func check(words: String) -> Bool {
    guard words.count > 5 else {
        print("5글자 이하입니다.")
        return false    // 함수에서 가드문은 꼭 얼리에셋이 들어가야함 return이나 throw
    }
    print("\(words.count)글자입니다.")
    return true
}


check(words: "안녕하세요오")
check(words: "안녕하세요")
```