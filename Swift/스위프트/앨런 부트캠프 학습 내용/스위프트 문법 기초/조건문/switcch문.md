# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 직접 요약정리하여 공부하기 위해 작성하는 글입니다.
https://inf.run/YyoR

# Switch문

표현식/변수를 (매칭시켜) 분기처리할때 사용하는 조건문   
if문보다 한정적인 상황에서 사용   

```swift
var choice: String = "보"

// 조건을 부등식이 아닌 "=="와만 비교
// 변수가 어떤값을 가지냐에 따라 실행문을 선택하고 진행

switch choice {   // 변수(표현식)
case "가위": // "가위" == choice 쉽게말해 같은지 비교하는것이다.
    print("가위입니다.")
case "바위":
    print("바위입니다.")
case "보":
    print("바위입니다.")
default:
    print("기본 케이스")
}
// 아무런 케이스에 해당되는않을때 작성하는 코드를 default에 넣으면 된다.

switch choice {   // 변수(표현식)
case "가위":       
    print("가위 입니다.")
case "바위":
    print("바위 입니다.")
case "보":
    print("보 입니다.")
default:
    break // 무언가 깬다.
}
//defalut break는 아무것도 실행을 원하지않으면 break를 넣어주면 된다.
```

 [스위치문의 특징]    
 - 1) 스위치문에서 케이스의 ,(콤마)는 또는의 의미로 하나의 케이스에    
      여러 매칭값을 넣을 수 있음    
 - 2) switch 문은 (비교하고 있는)값의 가능한 모든 경우의 수를 반드시    
      다루어야 함 (exhaustive: 하나도 빠뜨리는 것 없이 철저한)    
      모든 사례를 다루지 않았을 때에는 디폴트 케이스가 반드시 있어야 한다.      
 - 3) 각 케이스에는 문장이 최소 하나 이상 있어야 하며 만약 없다면 컴파일    
      에러 발생(의도하지 않은 실수를 방지 목적)     
      실행하지 않으려면, break를 반드시 입력해야함 (if문에서는 실행문을    
      입력안해도 괜찮지만, 스위치문에서는 필요함)    

```swift
switch choice {  // 문자열
case "가위":
    print("가위 입니다.")
case "바위", "보":
    print("바위 또는 보 입니다.")
default:
    break
}

// 스위치문에서 , 는 뭐다? 또는이다. 쉽게말해 "둘 중 하나라도 해당되는 케이스야?" 라고 물어보는겁니다.


var isTrue = true


switch isTrue {
case true:
    print("true")
case false:
    print("false")
}

//defalut값이 없는경우다. 참이랑 거짓 말고는 사실 다른 값이 존재하지않기때문에 defult값을 굳이 넣어주자않아도된다.
```

# fallthrough 키워드의 사용

```swift
var num1 = 9

switch num1 {
case ..<10:
    print("1")        // 매칭된 값에 대한 고려없이 무조건 다음블럭을 실행함
    fallthrough
case 10:
    print("2")
    fallthrough
default:
    print("3")
}
// 스위치문에서 fallthrough라는 키워드가있는데
//이건 뭔가 다음case의 코드를 무조건 실행하라는 녀석이다.
//아주 가끔씩 쓰이는경우가 있다.
```

# switch문의 범위 매칭 - 패턴 매칭 연산자와 관련

```swift
var num = 30

// ⭐️ 범위연산자, 패턴매칭 연산자 (참과 거짓의 결과가 나옴)

0...50 ~= num   //... 연산자는 0부터 50까지의 값을 가지고 있는걸 의미한다.(51개값)
51...100 ~= num  // ~= 패턴매칭 연산자는 앞에있는 범위에 뒤에있는 변수가 속한다면, 속하지 않는다면? true 아니면 false를 알려주는 연산자이다.

switch num {
case 0...50:      // 0...50 ~= 30 내부적으로 패턴매칭으로 확인
    print("숫자의 범위: 0 ~ 50")
case 51...100:
    print("숫자의 범위: 51 ~ 100")
default:
    print("그 외의 범위")
}

var temperature = 19

switch temperature {
case ..<0:   //범위를 ... 뿐만아니라 ..< 를 통해서 옆에 값보다 작은숫자까지를 표현할수도 있다. 여기서는 음수에 해당될것이다.
    print("영하 - 0도 미만")
case 0...18:
    print("0도 이상 무덥지 않은 날씨")
case 19...:
    print("여름 날씨")
default:
    break
}
```

스위치문은 이해보다는 여러번 안보고 직접 작성해보는 것이 중요 ⭐️