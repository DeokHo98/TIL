# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 직접 요약정리하여 공부하기 위해 작성하는 글입니다.
https://inf.run/YyoR

# 범위(Scope)
스코프의 기본 개념은    
1. 변수는 코드에서 선언되어야하며, 그이하 코드에서 접근이 가능하다.   
   
2. 상위 스코프에서 선언된 변수에는 접근이 가능하지만, 하위 스코프에서 선언된 변수에는 접근이 불가능하다.   
   
3. 가장 인접해있는 스코프에 있는 변수에 접근한다.

```swift
//변수는 코드에서 선언이 되어야, 그 이하의 코드에서 접근 가능

func greeting1() {
    print("Hello")
    
    var myName = "홍길동"
    print(myName)
    
    print(name)
    
    if true {
        print(myName)
        print(name)
    }
}


//print(myName)
//print(name)



greeting1() //여기서 함수를 실행하면 에러가 뜬다. 이뉴는 name이라는 변수에 아무것도 들어가있지않기 때문


var name = "잡스" //여기서 변수를 선언해주고 다시 함수를 실행하면 작동이된다. 전역변수라고도 한다.


greeting1()





//상위스코프(범위)에 선언된 변수와 상수에 접근가능하며, 하위스코프(범위)에는 접근할 수 없다.



func doSomething() {
    print(realName)       // 코드는 순서대로 작동하기 때문에, 선언이 되어있어야 사용 가능
    
    var realName = "앨런"
} //이 예제 자체가 잘못된것 변수선언과 프린트의 위치를 바꿔줘야함


doSomething()








// 줄맞춤 주의 뭔가 빠지면 줄맞춤이 안된다.
// 줄맞춤 단축키는 전체선택: command + A 줄맞추기: control + i

func sayGreeting1() {
    print("Hello")
    
    
    func sayGreeting2() {
        print("Hey")
        
        if true {
            print("")
        }
    }
    
    sayGreeting2()
    
}


//sayGreeting1()
//sayGreeting2()