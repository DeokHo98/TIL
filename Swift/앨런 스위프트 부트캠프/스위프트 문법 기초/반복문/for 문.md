# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 직접 요약정리하여 공부하기 위해 작성하는 글입니다.
https://inf.run/YyoR

#  for문
For문의 기본 형태

```swift
//스위프트 스타일의 문법은 직관적이고 쉽게 작성이 가능하도록 되어있음

for index in 1...5 {        //let index = 1, let index = 2, let index = 3, let index = 4, let index = 5
    print("For문 출력해보기: \(index)")
}
//순서대로 숫자를 뽑아서 index에 넣는것 1을넣고 끝 그리고 2를넣고 끝 또 3을넣고 끝 이런식으로
//여기서는 그렇게 넣을때마다 프린트한다는 코드를 실행하는것이다.

for index in 1...5 {
    print("\(index)에 5를 곱하면 \(index * 5)")
}

var sum = 0

for i in 1...10 {
    sum += i
}

print(sum)

//이 예제는 sum에 계속해서 더하는것 0+1+2+3+4+5+6... 그렇게해서 마지막엔 55란 숫자가나오고 sum의 값은
//55로 바뀌게된다. 그래서 스코프를 나와 출력을해보면 55가 프린트된다.

// 이런 방식으로 많이 활용

var number = 10


for i in 1...number {
    print(i)
}
```

# 와일드 카드 패턴

와일드 카드 패턴 _ (언더바)은 스위프트에서 생략의 의미!

```swift
for _ in 0...10 {
    print("hello")
}



let _ = "문자열"
```

# 문자열에서도 사용 가능
```swift
// 문자열에서 각 문자를 차례 차례 한개씩 뽑아서 중괄호 안에서 사용

for chr in "Hello" {
    print(chr)
    //print(chr, terminator: " ")     //다음줄로 넘어가지 말고, 한칸을 띄워라
}
```

# 특정한 함수 활용 가능

```swift

// 역순으로 바꾸기

for number in (1...5).reversed() {
    print(number)
}


//홀수 또는 홀수만 뽑아내기

for number in stride(from: 1, to: 15, by:2) {     //마지막 숫자는 포함하지 않음
    print(number)                                 //stride: 성큼성큼 걷다.
}  

//stride 는 1부터 15까지 성큼성큼 걷는데 2씩 걸을꺼야~ 라고 하는말이랑 같다.
//1 3 5 7 9 11 13 15전까지 그니까 13까지 나온다.
//다른식으로 표현 가능

for number in 1...15 where number % 2 == 1 {
    print(number)
}
// 이렇게 where문을 가지고도 표현 할수 있음.





let range = stride(from: 1, to: 15, by: 2)     //  StrideTo<Int>
print(range)
// 1, 3, 5, 7, 9, 11, 13

for i in range {
    print(i)
}


let range1 = stride(from: 1, through: 15, by: 2)     // StrideThrough<Int>
print(range1)
// 1, 3, 5, 7, 9, 11, 13, 15
//through는 15까지 포함이라는 의미이다.
for i in range1 {
    print(i)
}
//through 키워드를 이용해 15를 포함해서 출력하기


let range2 = stride(from: 10, through: 2, by: -2)      //   StrideThrough<Int>
print(range2)
// 10, 8, 6, 4, 2


for i in range2 {
    print(i)
}
//내림차순으로 프린트하기

```