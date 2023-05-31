# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

```swift

//CaseLterable 프로토콜
//열거형에서만 사용할수 있는 프로토콜

/*
 열거형에서 CaseLterable 프로토콜을 채택하면 타입 계산 속성이 자동으로 구현된다.
 static var allCases: Self.Allcase { get }
 
 이 타입 계산속성을 컴파일러가 자동으로 구현해주고 이 계싼속성은
 모든 케이스를 정의한순서대로 하나의 배열로만들어 리턴해준다.
 연관값이 없는 경우에만 채택이가능하다. 원시값은 상관없고
 
 */


enum Color: Int, CaseIterable {
    case red = 1
    case blue
    case green
    case pink
}

var color1 = Color.red
color1 = .blue
color1 = .green


Color.allCases //열거형의 모든 속성을 담아 배열로 만듬
dump(Color.allCases)


//애플아~ 이거 왜만들었니?

//배열의 장점을 사용해 여러가지 편의적 기능 활용이 가능하다 =================

//손쉽게 반목문 사용이 가능

for i in Color.allCases {
    print("\(i)")
}


//필요로 하는곳 에서 선언도 간단하게
struct SomeView {
    let colors = [Color.allCases]
    //let colors: [Color] = [Color.red, Color.green, Color.blue] //이렇게 귀찮게 안해도됨
}


//공식문서의 예제

enum CompassDirection: CaseIterable {
    case north, south, east, west
}

// 1. 케이스의 갯수를 세기 편해짐 (케이스를 늘려도 코드를 고칠필요가없어짐)
print("방향은 \(CompassDirection.allCases.count) 가지입니다")

//2. 배열 ===> 고차함수로 이용이 가능

let caseList = CompassDirection.allCases.map {
    "\($0)"
}.joined(separator: ", ")

print(caseList)

//3. 랜덤케이스를 뽑아낼수 있음

let randomValue = CompassDirection.allCases.randomElement()




//원시값을 이용한 방법 ==============

// 가위바위보 케이스

enum RpsGame: Int, CaseIterable {
    case rock = 0
    case paper = 1
    case scissors = 2
}

//예전에 했던 가위바위보를 만들었던 방식
//let number = Int.random(in: 0...100) % 3    // 3을 조금 더 멋지게 처리할 수 있는 것은 고급내용에서 다룸

let number2 = Int.random(in: 0...100) % RpsGame.allCases.count    // 나머지를 구하는 것이니 무조건 0, 1, 2 중에 한가지임


print(RpsGame.init(rawValue: number2)!)


```