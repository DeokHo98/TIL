# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

```swift

/*
원칙적으로 함수의 실행이 종료되면 파라미터로 쓰이는 클로저 또한 제거된다.
하지만 @escaping(탈출한다) 키워드는 클로저를 제거하지않고 함수에서 탈출시킨다 이말은 즉슨 함수가 종료되도 클로저는 존재하는것이다.
 클로저가 함수의 실행흐름(스택프레임)을 벗어날수 있게 해주는것
 */



//지금까지 다룬 내용
func performEscaping1(closure: () -> ()) {
    print("프린트 시작")
    closure()
}


performEscaping1 {
    print("프린트 종료")
}



// 클로저를 외부변수에 저장 (@escaping 키워드 필요 ==========
//@escaping 사용의 대표적인경우
// 내부에서 사용한 클로저를 외부 변수에 저장할때
// GCD 비동기 코드의 사용


var aSavedFunc: () -> () = {
    print("출력")
}

//aSavedFunc()

func performEscaping2(closure: @escaping () -> () ) {
    aSavedFunc = closure //클로저를 실행하는것이아니라 aSavedFunc에다 저정하는것
}

performEscaping2 {
    print("다르게 출력")  //그냥 단순히 변수에다 할당하는것 뿐
}

aSavedFunc()
//결국에는 클로저를 받아서 그 클로저를 외부의 변수에 할당하는것이다.











//autoclosure 키워드 ============================
//autoclosure는 파라미터가 없는 클로저만 사용가능

func someFunction(closure: @autoclosure () -> Bool) {
    if closure() {
        print("참")
    } else {
        print("거짓")
    }
}

var num = 1

someFunction(closure: false)

someFunction(closure: num == 1)


//일반적으로 클로저 형태로 써도되지만, 너무 번거로울때 사용
//번거로움을 해결해주지만 실제 코드가 명확해 보이지않을수 있으므로 사용 지양....
// 잘 사용하지않고 그냥 읽기위한 문법이다.

//autoclosure는 기본적으로 non-ecaping 특성을 가지고 있다.












//참고 클로저의 사용법
/*
 실제 프로젝트에서 스토리보드가 아닌 코드로 프로젝트를 작성시 속성선언을 클로저를 직접 실행해서 해당 타입을 반환하는
 아래와 같은 형식으로 많이 작성함
 코드로 프로젝트 작성시, 연관성 있는 코드를 묶어놓음으로 가독성이 높아짐
 */

//let emailTextField: UITextField = {
//    let tf = UITextField()
//    tf.placeholder = "Email"
//    tf.backgroundColor = UIColor()
//    tf.borderStyle = .roundedRect
//    tf.font = UIFont.systemFont(ofSize: 14)
//    return tf
//}()

//이런거 저런거를 다 세팅해서 리턴시켜서 담는것...
```