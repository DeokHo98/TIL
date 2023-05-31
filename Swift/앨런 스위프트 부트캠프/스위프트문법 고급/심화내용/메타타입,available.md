
# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR



메타타입
```swift
//메타 타입

//타입: Dog , Person , Int , String
//인스턴스: dog1, person1, 5 , "안녕"


class Dog {
    static let specties = "Dog"
    var name: String = ""
    var weight: Double = 0.0
}


let dog1: Dog = Dog()

dog1.name = "한별"
dog1.weight = 10.0


let dog2: Dog = Dog()

dog2.name = "보리"
dog2.weight = 15.0

//메타입이은 타입(인스턴스,붕어빵틀의 메모리)의 타입임

let dog: Dog.Type = Dog.self
let dogSelf1: Dog.Type = type(of: dog1) //어떤 인스턴스를 집어넣으면 타입을 알려주는? 위에코드랑 완전히 동일


Dog.specties //타입 속성에 접근하는 방법
Dog.self.specties //근데 원래 원칙적으로는 이게 맞음
dogSelf1.specties


class Person {
    static let species = "인간"
    var name: String = ""
}


//인스턴스의 타입과 인스턴스
let person1: Person = Person()
person1.name = "홍길동"

//인스턴스의 타입과 인스턴스
let person2: Person = Person()
person2.name = "임꺽정"


//메타 타입의 이해
let pSelf1: Person.Type = Person.self

pSelf1.species
Person.species
Person.self.species


var num1: Int = 10
var num2: Int = 2

Int.max
Int.self.max

Int.zero
Int.self.zero

var numberSelf: Int.Type = Int.self
numberSelf.max



//메타 타입을 선언하는 방법 =================================
/*
 커스텀 타입의 경우
 클래스이름.Type
 구조체이름.Type
 엵형이름.Type
 
 프로토콜의 겨웅
 프로토콜이름.Protocol
 */


//메타타입을 사용하는 api

//1
//테이블뷰셀을 등록하는 경우에 메타타입을 사용

//UITableView().register(<#T##aClass: AnyClass?##AnyClass?#>, forHeaderFooterViewReuseIdentifier: <#T##String#>)

//typealias AnyClass = AnyObject.Type



//2
//JSONDecoder 객체를 사용해서 디코드 메서드 사용시

// JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
```




available
```swift
// @available/#available 키워드

/*
1. @available ==============
타입, 속성, 메서드 앞에
컴파일러가 API의 사용 가능성을 결정
@available(iOS 10.0, *)
 func doSomething() {}
쉽게 얘기해서 어떤 버전에서 사용하고 싶은 코드 중에서도 타입, 속성, 메서드 앞에붙히는것이다.
이 클래스,함수,타입은 ,IOS 10.0 버전일때만 존재하는거야~ 라고 컴파일러한테 알려주는것이다.


2. #@available =============
 @@available 은 타입, 속성, 메서드였다면
 #@available 은 조건문 if guard while 문 앞에서 쓴다.
 
 if #@available(Ios 11.0, *) {
  11버전일때 코드는 이코드를 실행
 } else {
  11버전이 아니면 이코드를 실행
 }
 

 */
@available(iOS 11.0, *)
class ViewController: UIViewController {
    
    @available(iOS 11.0, *)
    func doSomething() {
        if #available(iOS 11.0, *) {
            print("ios 11버전 이상에서만 프린트됨")
        } else {
            print("ios 11버전 이하에서는 이게 프린트됨~")
        }
    }
}


```