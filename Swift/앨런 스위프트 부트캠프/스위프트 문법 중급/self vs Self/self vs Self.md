

```swift

// self vs Self =================================


// 소문자 self 는 인스턴스를 가리킨다. "hello", 7 등등....
 
// 1. 인스턴스를 가리키기 위해 사용한다.

class 사람 {
    var 이름: String
    init(이름: String) {
        self.이름 = 이름
    }
}


//2. 새로운 값으로 속성 초기화 가능한 패턴에서 사용한다  (값타입만 해당됨)

struct 계산 {
    var 숫자: Int = 0
    
    mutating func 더하기(_ num: Int) {
        숫자 = 숫자 + num
    }
    
    mutating func 리셋() {
        self = 계산() //값타입에서는 인스턴스 값 자체를 치환하는것도 가능하다.
    }
}


//3.타입 멤버에서 사용하면, 인스턴스가 아닌 타입 자체를 가리킨다.

struct 내스트럭트 {
    static let 클럽 = "ios 부서"
    
    static func 프린팅() {
        print("소속은 \(self.클럽)입니다.") //내스트럭트.클럽이랑 똑같은거...
    }
}


//4. 타입 인스턴스를 가리키는 경우에 사용한다 (외부에서 타입을 가리키는 경우)

class 썸클래스 {
    static let 이름 = "썸클래스"
}

let 나의클래스: 썸클래스.Type = 썸클래스.self //데이터영역에 있는 타입 인스턴스를 가리킨다..

썸클래스.이름 //사실 이건 밑에걸 줄여서 썼던것 이다.
썸클래스.self.이름

Int.max
Int.self.max


//대문자 Self 는 타입을 가리킨다. String, Int 등등.....

// 1. 해당타입을 가르키는 용도로 Self 를 사용한다.
//타입을 선언하는 위치에서 사용하거나, 타입속성/타입메서드를 지칭하는 자리에서 대신 사용한다.

extension Int {
    static let 제로: Self = 0 //int타입인 것이다.
    
    
    var 제로: Self { //타입을 선언하는 위치에서 사용
        return 0
    }
    
    
    static func 투제로() -> Self {
        return Self.제로 //int.제로 와 같은것이다.
    }
    
    func 투제로() -> Self {
        return self.제로
    }
}



Int.제로
5.제로

Int.투제로()
5.투제로()


//2. 프로토콜에서의 Self사용 (프로토콜을 채택하는 해당 타입을 가르킴)
//프로토콜의 확장 ==> 구현의 반복을 줄이기 위한 방법

extension BinaryInteger { //바이너리뭐시기라는 애플이 구현해놓은 프로토콜
    func squared() -> Self { //타입 자체를 가리킨다
        return self * self // 인스턴스 (7)을 가리킨다
    }
}

// 간단하게 얘기하면 Int, UInt 간에도 비교가능하도록 만드는 프로토콜
// (타입이 다름에도 비교가 가능)

let x1: Int = -7
let y1: UInt = 7


if x1 <= y1 {
    print("\(x1)가 \(y1)보다 작거나 같다.")
} else {
    print("\(x1)가 \(y1)보다 크다.")
}



// 실제로는 Int가 BinaryInteger 프로토콜을 채택
// Int에 기본구현으로 squared() 메서드가 제공  ===>  func squared() -> Int {..}


7.squared()



protocol 리모트 {
    func 온() -> Self //이렇게 선언해주면
}


extension String: 리모트 {
    func 온() -> String {//여기서 이렇게 자동으로 String타입이 들어온다.
        return ""
    }
    
    
}

```