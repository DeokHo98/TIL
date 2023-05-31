# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다. 
https://inf.run/YyoR



```swift

/*
 - 기존 배열 등의 각 아이템을 클로저가 제공하는 방식으로 결합해서
   마지막 결과값을 리턴(초기값 제공할 필요)
 - (각 아이템을 결합해서 단 하나의 값으로 리턴)
*/


var numArray = [1,2,3,4,5,6,7,8,9,10]

var resultSum = numArray.reduce(0) { res, num in
    return res + num
}

print(resultSum)


resultSum = numArray.reduce(100, {
    return $0 - $1
})

print(resultSum)

var aaa = numArray.reduce("0") { res, num in
    return res + String(num)
}

print(aaa) // "0" "1" 이 합쳐져서 "01" 이되는것 이게 계쏙 반복....




var numbersArray1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 위의 배열 중에, 홀수만 제곱해서, 그 숫자를 다 더한 값은?


var bbbbb = numbersArray1.filter { //필터를 사용해서 홀수만 일단 뽑아내고
    return $0 % 2 == 1
} .map { //맵을 이용해서 제곱하고
    return $0 * $0
} .reduce(0) { //리듀스로 그 값을 모두 더하는
    return $0 + $1
}

print(bbbbb)



```
