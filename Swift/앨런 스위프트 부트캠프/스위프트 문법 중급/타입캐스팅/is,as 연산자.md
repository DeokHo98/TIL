# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

```swift

//타입캐스팅 =========================



class Person {
    var id = 0
    var name = "이름"
    var email = "abc@gmail.com"
}


class Student: Person {
    // id
    // name
    // email
    var studentId = 1
}



class Undergraduate: Student {
    // id
    // name
    // email
    // studentId
    var major = "전공"
}



let person1 = Person()
person1.id
person1.name
person1.email



let student1 = Student()
student1.id
student1.name
student1.email
student1.studentId // 추가적으로



let undergraduate1 = Undergraduate()
undergraduate1.id
undergraduate1.name
undergraduate1.email
undergraduate1.studentId
undergraduate1.major    //  추가적으로





//인스턴스 타입을 검사하는 is 연산자 =====================
/*
 - 인스턴스 is 타입   (이항연산자)
   ▶︎ 참이면 true 리턴
   ▶︎ 거짓이면 false 리턴
 
 - 상속관계의 계층에서 포함관계를 생각해보면 쉬움
*/


// 사람 인스턴스는 학생/대학생 타입은 아니다. (사람 타입이다.)
person1 is Person                // true
person1 is Student               // false
person1 is Undergraduate         // false


// 학생 인스턴스는 대학생 타입은 아니다.  (사람/학생 타입니다.)
student1 is Person               // true
student1 is Student              // true
student1 is Undergraduate        // false


// 대학생 인스턴스는 사람이거나, 학생이거나, 대학생 타입 모두에 해당한다.
undergraduate1 is Person         // true
undergraduate1 is Student        // true
undergraduate1 is Undergraduate  // true




// 예제를 통한 활용

let person2 = Person()
let student2 = Student()
let undergraduate2 = Undergraduate()


let people = [person1, person2, student1, student2, undergraduate1, undergraduate2]


// 학생 인스턴스의 갯수를 세고 싶다.

var studentNumber = 0

for someOne in people {
    if someOne is Student { //쉽게말해 is연산자는 포함하고 있니? 라고 물어보는 녀석하고 같다.
        studentNumber += 1
    }
}


print(studentNumber)
```


# 인스턴스 타입의 (메모리구조에 대한) 힌트를 변경하는 - as 연산자

```swift
class Person {
    var id = 0
    var name = "이름"
    var email = "abc@gmail.com"
}


class Student: Person {
    // id
    // name
    // email
    var studentId = 1
}


class Undergraduate: Student {
    // id
    // name
    // email
    // studentId
    var major = "전공"
}



let person1 = Person()
person1.id
person1.name
person1.email



let student1 = Student()
student1.id
student1.name
student1.email
student1.studentId // 추가적으로



let undergraduate1 = Undergraduate()
undergraduate1.id
undergraduate1.name
undergraduate1.email
undergraduate1.studentId
undergraduate1.major    //  추가적으로

/*
- 타입캐스팅 / 타입캐스팅 연산자 (이항 연산자)
 (1) Upcasting (업캐스팅)
 - 인스턴스 as 타입
 - 하위클래스의 메모리구조로 저장된 인스턴스를 상위클래스 타입으로 인식

 (2) Downcasting (다운캐스팅) (실패가능성이 있음)
 - 인스턴스 as? 타입  / 인스턴스 as! 타입
   ▶︎ as? 연산자
    - 참이면 반환타입은 Optional타입
    - 실패시 nil 반환
   ▶︎ as! 연산자
    - 참이면 반화타입은 Optional타입의 값을 강제 언래핑한 타입
    - 실패시 런타임 오류
 
 [타입캐스팅의 의미]
 - 인스턴스 사용시에 어떤 타입으로 사용할지(속성/메서드) 메모리구조에 대한 힌트를 변경하는 것
 - 메모리의 값을 수정하는 것이 아님
 - (단순히 해당 타입의 인스턴스인 것처럼 취급하려는 목적)
 */


 let persons: Person = Person()
persons.id
persons.name
persons.email
//person.studentId    // Value of type 'Person' has no member 'studentId'
//person.major          // Value of type 'Person' has no member 'major'



// 그런데, 왜 studentId 와 major 속성에는 접근이 되지 않을까? ⭐️

// person2변수에는 Person타입이 들어있다고 인식되는 것임
// ===> 그래서 접근불가 ===> 접근하고 싶다면 메모리구조에 대한 힌트(타입)를 변경 필요




//다운캐스팅 as? / as! =================
let persons2: Person = Undergraduate()
let ppp = persons2 as? Undergraduate  // Undergraduate? 타입 여기에 지금 이 타입이 담겨 있니? 아니면 nil을 반환하고 맞으면 변수에 옵셔널타입으로 할당해라 하는 녀석



if let newPerson = persons2 as? Undergraduate {   // if let 바인딩과 함께 사용 (옵셔널 언래핑)
    newPerson.major
    print(newPerson.major)
}

// 실제로 인스턴스의 접근 범위를 늘려주는 것 뿐임

let person3 = persons2 as! Undergraduate
person3.major

//업캐스팅 as ===================

let undergraduate2: Undergraduate = Undergraduate()
undergraduate2.id
undergraduate2.name
undergraduate2.studentId
undergraduate2.major
//undergraduate2.name = "길동"




let person4 = undergraduate2 as Person       // 항상 성공 (컴파일러가 항상 성공할 수 밖에 없다는 것을 알고 있음)
person4.id
person4.name
//person4.studentId
//person4.major



//as 연산자의 활용 =========================



//Bridging (브릿징) ➞ 서로 호환되는 형식을 캐스팅해서 쉽게 사용하는 것
// 스위프트에서는 내부적으로 여전히 Objective-C의 프레임워크를 사용하는 것이 많기 때문에
// 서로 완전히 상호 호환이 가능하도록 설계해놓았음(completely interchangeable)
// 타입 캐스팅을 강제(as!)할 필요 없음


let str: String = "Hello"
let otherStr = str as NSString


```