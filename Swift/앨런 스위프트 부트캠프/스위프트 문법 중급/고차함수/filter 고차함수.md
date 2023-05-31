# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다. 
https://inf.run/YyoR






```swift

/*
 - 기존 배열 등의 각 아이템을 조건(조건은 클로저가 제공)을
   확인후, 참(true)을 만족하는 아이템을 걸러내서 새로운 배열을 리턴
 - (각 아이템을 필터링해서, 걸러내서 새로운 배열을 만들때 사용)
*/


let names = ["Apple", "Black", "Circle", "Dream", "Blue", "bbbbbb" , "BBBBBB"]

var newName = names.filter { str in
    return str.contains("B")
}

print(newName)

let array = [1,2,3,4,5,6,7,8,9]

var evenNumber = array.filter { num in
    return num % 2 == 0
}

print(evenNumber)


evenNumber = array.filter({
    return $0 % 2 == 1
})

print(evenNumber)




//함수로 한번 전달해보기


func isEven(_ i: Int) -> Bool {
    return i % 2 != 0
}

let evens = array.filter(isEven)
print(evens)


//필터를 두번 사용하기

var envenNumber2 = array.filter {
    return $0 % 2 == 0
} .filter {
    return $0 < 5
}

print(envenNumber2)


```