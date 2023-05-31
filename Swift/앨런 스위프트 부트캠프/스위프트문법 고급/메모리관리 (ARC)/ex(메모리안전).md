
# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

```swift
//메모리 안전(Memory Safety)
//별로 중요하지않기때문에 개념만 짚고 넘어가자

//메모리 안전이란 싱글 쓰레드의 환경에서도 하나의 메모리에 동시적 접근이 발생가능하다 라는것
//동시성 프로그래밍에서 Thread Safe 하지 않는다. 라는걸 배운적이있는데
//복습하자면 같은 시점에 동시에 접근하는경우를 얘기한다.
//싱글 쓰레드에서도 이런일이 발생할수있는데 이럴때를 Memory Safety 하지않는다고 표현한다.
//멀티 쓰레드에서만 메모리 충돌이 일어나는것은 아니다.

var stepConflict = 1

//변수 stepConfilt에 장기적인 쓰기 접근

func increment(_ number: inout Int) {
    number += stepConflict //변수에 stepConfilt에 읽기접근
}

//inout은 함수가 진행되는동안 파라미터가 외부 변수의 메모리를 가리킨다.
//그런데 파라미터에서도 변수의 메모리를 가리키는데, 함수의 내부에서도 변수에 접근해서 가리키고 있다.
//그럼 컴파일러는 도대체 어떤 숫자를 담아야돼? 라고 헷갈리게 된다.

//increment(&stepConflict) //메모리에 동시접근으로 인한 문제가 발생함

//이런문제를 해결하려면? 다른변수를 잠깐만들어서 해결한다

//복사할 다른 변수를 만든다.
var copyOfStepConflict = stepConflict

increment(&copyOfStepConflict)

//그리고 곡 다시 원본을 바꿔줘야한다.

stepConflict = copyOfStepConflict








//동일한 함수의 여러 입출력 매개변수로 단일변수를 전달하는것도 에러.

func balance(_ x: inout Int,_ y: inout Int) { //평균값을 설정하는 함수
    let sum = x + y
    x = sum / 2
    y = sum - x
}

var playerOneScore = 42

//balance(playerOneScore, playerOneScore) // 동시에 똑같은 변수를 가리키니까 에러발생

//사실이건 예제라 그렇지 이렇게 만드는사람은 없을것





//구조체의 인스턴스에서 메모리 안전

struct Player {
    var name: String
    var health: Int
    var energy: Int
    
    static let maxHealth = 10
    
    //health 값을 바꾸는 메서드 (self.health에 접근)
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}

//확장
extension Player {
    //자신의 체력과, 동료의 체력을 공유해서 평균을 설정
    mutating func shareHealth(with teammate: inout Player ) {
        balance(&teammate.health, &health)
    }
}


var mario = Player(name: "마리오", health: 10, energy: 10)
var luigi = Player(name: "루이지", health: 5, energy: 10)


//마리오와 루이지의 체력을 공유
mario.shareHealth(with: &luigi) //괜찮음

//mario.shareHealth(with: &mario) //동일한 인스턴스의 구조체의 접근해서 저장속성에 접근하는것은 불가능하다라는것이다.



/*
 컴파일러가 안전하다는것을 판단하는 경우는
 1. 계산속성이나타입속성이 아닌 인스턴스의 저장속성에만 접근하는경우
 2. 구조체가 전역변수가 아닌 , 지역변수로만 선언될떄
 3. 구조체가 클로저에 의해 캡처되지않았거나 non = escaping 클로저로만 캡쳐되었을때
 */

//근데 그냥 이론적으로 접근하지말자
// 컴파일러는 때로 메모리안전에 대한 증명이 가능해서
// 그냥 하럭되는 경우가 있다 정도로 기억하자

//메모리안전의  개념 2줄 요약
//싱글쓰레드에서도 메모리에 동시에접근하는경우가 있고
//그런 경우가 바로 메모리가 안전하지않는것이다.
```