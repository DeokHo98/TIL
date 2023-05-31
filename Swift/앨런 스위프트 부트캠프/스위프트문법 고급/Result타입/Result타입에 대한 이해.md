
# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR





```swift
//Result 타입
/*
 에러가 발생하는경우 에러를 따로 외부로 던지는 것이 아니라
 리턴타입 자체를 Result Type (2가지를 다 담을 수 있는) 으로 구현해서
 함수 실행의 성공과 실패의 정보를 함께 담아서 리턴
 
 실제 Result 타입의 내부 구현
 enum Result<Success, Failure> where Failure : Error
 Result타입은 열거형
 case success(연관값) 연관값을 담을수 있다. 그리고 제네릭으로 선언되어있음
 case failure(연관값) 연관값을 담을수 있다. 그리고 제네릭으로 선언되어있음
 
 */


//원래 우리가 배운 에러처리 방법
// 에러 정의 (어떤 에러가 발생할지 경우를 미리 정의)

enum HeightError: Error {    //에러 프로토콜 채택 (약속)
    case maxHeight
    case minHeight
}




// throwing함수 (앞에서 배운)

func checkingHeight(height: Int) throws -> Bool {    // (에러를 던잘수 있는 함수 타입이다)
    
    if height > 190 {
        throw HeightError.maxHeight
    } else if height < 130 {
        throw HeightError.minHeight
    } else {
        if height >= 160 {
            return true
        } else {
            return false
        }
    }
}




do {
    let _ = try checkingHeight(height: 200)
    print("놀이기구 타는 것 가능")
} catch {
    print("놀이기구 타는 것 불가능")
}

//일반적인 에러처리는 실제 함수를 호출하는 곳에서 어떤 에러형식인지를 특정짓기 어렵다.
//반면에 Result타입은 실제 함수를 정의시에 에러타입을 명시적으로 선언하기때문에 어떤에러인지 바로알수있다. 







//Result 타입을 활용한 에러 처리 ==============================
//에러는 동일하게 정의 되어 있다고 가정
//Result 타입에는 성공/실패 했을 경우에 대한 정보가 다 들어 있음
func resultTypeCheckingHeight(height: Int) -> Result<Bool, HeightError> { //미리정의한 에러
//성공했을때는 연관값에 Bool의 정보를 주고 실패했을때는 연관값에 Height에러의 정보를 주는것
    if height > 190 {
        return Result.failure(HeightError.maxHeight) //원래는 throw했어야되는덱 그냥 리턴을 하면 됨
    } else if height < 130 {
        return Result.failure(HeightError.minHeight)
    } else {
        if height >= 160 {
            return Result.success(true)
        } else {
            return Result.success(false)
        }
    }
}


let result = resultTypeCheckingHeight(height: 140)


switch result {
case .success(let data):
    print("결과값은 \(data)입니다")
case .failure(let error):
    print(error.localizedDescription)
}


//Result타입에 다야안 활용 =============================================
//Result타입에는 여러 메서드가 존재
// get() 메서드는 결과값을 throwing함수처럼 변환가능한 메서드 (Success벨류를 리턴)

do {
    let data = try result.get() //다시 에러를 던지는 함수 라고 생각하면 됨.
    print("결과값은 \(data)이네요~~~~")
} catch {
    print(error.localizedDescription)
}

//이런경우는 드물겠지만 어쨌는 리절트는 여러 메서드를 가지고 있다.

/*
 Result타입은 성공/실패의 경우를 아주 깔끔하게 처리할수 있다.
 하지만 기존의 에러처리 패턴을 완전히 대체하려는 목적은 아니다.
 단지 개발자에게 에러처리에 대한 여러가지 방법에 대한 옵션을 제공하는거 라고 생각하면 된다.

 */
```