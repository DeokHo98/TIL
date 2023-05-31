# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

```swift
//할일을 미루는 defer문에 대한 이해

// defer문은 코드의 실행을 스코프가 종료되는 시점으로 연기시키는 문법
// 일반적인 사용은, 어떤 동작의 마무리 동작을 특정하기 위해서 사용 (정리의 개념)


func deferStatement1() {
    
    defer { //deferStatement1 함수가 종료되는 시점에 코드를 실행시키는 녀석
        //호출을 뒤로 미룬다
        print("나중에 실행하기")
    }
    
    print("먼저 실행하기")
}

deferStatement1()






func deferStatement2() {
    
    if true {
        print("먼저 실행하기")
        return //리턴이기때문에 함수를 벗어남
    }
    
    defer {
        print("나중에 실행하기") // 디퍼문은 한번이라도 호출이 호출되어야, 해당 디퍼문의 실행이 예약되는 개념
        //한번도 호출되지않아 예약을 안해서 실행이안된다는것
    }
}

deferStatement2()






// 등록한 역순으로 실행  ====> 일반적으로 하나의 디퍼문만 사용하는 것이 좋음

func deferStatement3() {
    defer {
        print(1) //가장먼저 마지막을 예약 마지막 자리 우선순위 1등
    }
    defer {
        print(2) //두번째로 마지막을 예약 마지막 자리 우선순위 2등
    }
    defer  {
        print(3) //마지막으로 마지막을 예약 마지막 자리 우선순위 3등
    }
}

deferStatement3()





// 어떻게 실행될까?

for i in 1...3 { //반드시 함수에서만 쓰는것은 아님
    defer { print ("Defer된 숫자?: \(i)") }
    print ("for문의 숫자: \(i)")
}

//디퍼문에 1이 들어오고 마지막자리 예약 => 포문에 1이들어오고 실행 => 디퍼문 실행 => 다음주기......
```