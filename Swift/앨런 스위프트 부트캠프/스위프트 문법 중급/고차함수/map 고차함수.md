# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다. 
https://inf.run/YyoR


```swift

/*
- 고차원의 함수
- 함수를 파라미터로 사용하거나, 함수실행의 결과를 함수로 리턴하는 함수


- 일반적으로 함수형 언어를 지향하는 언어들에 기본적으로 구현되어 있음
- 아래의 3가지 함수를 다룸

- 1) map 함수
- 2) filter 함수
- 3) reduce 함수

- (추가적으로: forEach, compactMap, flatMap)


- Sequence, Collection 프로토콜을 따르는 컬렉션(배열, 딕셔너리, 세트 등)
  에 기본적으로 구현되어 있는 함수
- (Optional타입에도 구현되어 있음)
*/



// map 함수 ===============================



/**
 - 기존 배열 등의 각 아이템을 새롭게 매핑해서(매핑방식은 클로저가 제공)
   새로운 배열을 리턴하는 함수
 - (각 아이템을 매핑해서, 변형해서 새로운 배열을 만들때 사용)
 */


let number = [1,2,3,4,5]

var newNumber = number.map { n in
    return "숫자는 \(n)"
}

newNumber = number.map({ "숫자는 \($0)"
})


print(newNumber)


var newNumber2 = number.map { n in
    return n * 1000
}

print(newNumber2)



let alphabet = ["A","B","C","D","F"]


var newAlphabet = alphabet.map { name -> String in
    return name + "!!!!!!!!!!"
}

print(newAlphabet)


```