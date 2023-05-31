# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

```swift

//플레이 그라운드 작업 중간에 멈추지 않게 하기 위함
// 비동기작업으로 인해 플ㄹ레이그라운드의 모든 작업이 끝난다고 인식할수 있기때문에 사용
PlaygroundPage.current.needsIndefiniteExecution = true


//GCD 사용시 주의사항 ===========================
//1. 반드시 메인큐에서 처리해야하는 작업

//화면을 다시그리는것과 관련된 Ui와 관련된 일을 메인쓰레드만 할 수 있기 때문에 다시 보내줘야 한다.
//DispatchQueue.main.async { } 이렇게 다시 보내주자

var imageView: UIImageView? = nil


let url = URL(string: "https://bit.ly/32ps0DI")!


// URL세션은 내부적으로 비동기로 처리된 함수임.
URLSession.shared.dataTask(with: url) { (data, response, error) in
    DispatchQueue.global().async { //URLSeesion 자체가 이런 코드안에서 동작하고있다고 생각하면됨
        
        if error != nil{
            print("에러있음")
        }
        
        guard let imageData = data else { return } //데이터를 옵셔널바인딩 한 다음에
        
        let photoImage = UIImage(data: imageData)     // 즉, 데이터를 가지고 UI이미지로 변형하는 코드
        
        // 🎾 이미지 표시는 DispatchQueue.main에서 🎾
        DispatchQueue.main.async {
            imageView?.image = photoImage //이 UIimage형태의 이미지를 var imgageView에다 표시를 하고싶은것
        } //이 과정을 반드시 메인큐에서 해야한다는것이다
        
    }
}.resume()





DispatchQueue.global().async {
    
    // 비동기적인 작업들 ===> 네트워크 통신 (데이터 다운로드)
    
    DispatchQueue.main.async {
        // UI와 관련된 작업은
    }
}


sleep(4)

PlaygroundPage.current.finishExecution()









//2. 컴플리션핸들러의 존저이유 - 올바른 콜백함수의 사용 ( 매우중요 )
//다른쓰레드로 작업을 던저주고 바로 리턴을 받기때문에 리턴형으로 함수를 만들면 안된다.
//올바른 비동기함수의 설계 => 리턴(return)이 아닌 콜백함수를 통해, 끝나는 시점을 알려줘야 한다.
//다른쓰레드에서의 작업을하는 함수는 기존처럼 함수를 리턴형으로 통한설계를하면 안된다.
//즉 비동기적인 작업을 해야하는 함수는 항상 클로저를 호출할수 있도록 설계해야한다.
//@escaping(데이터) -> Void

//잘못된 설계

func getImages(with urlString: String) -> UIImage? {
    
    let url = URL(string: urlString)!
    
    var photoImage: UIImage? = nil
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print("에러있음: \(error!)")
        }
        // 옵셔널 바인딩
        guard let imageData = data else { return }
        
        // 데이터를 UIImage 타입으로 변형
        photoImage = UIImage(data: imageData)
        
    }.resume() //비동기라 기다리지않고 바로 리턴으로 넘어감

    
    return photoImage //비동기적을 동작하는거라 기다리지않고 바로 리턴으로 넘어감
    // 항상 nil 이 나옴 왜냐 아무런것도 실행하지않고 계속 바로 리턴으로 넘어오니까
}



getImages(with: "https://bit.ly/32ps0DI")    // 무조건 nil로 리턴함 ⭐️






sleep(5)


PlaygroundPage.current.finishExecution()





//올바른 함수의 설계
func properlyGetImages(with urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
    //일반적으로 비동기적함수를 실행시키고 콜백함수로 실행하겠다 라는 함수를 completionhandler 라고 함
    let url = URL(string: urlString)!
    
    var photoImage: UIImage? = nil
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print("에러있음: \(error!)")
        }
        // 옵셔널 바인딩
        guard let imageData = data else { return }
        
        // 데이터를 UIImage 타입으로 변형
        photoImage = UIImage(data: imageData)
        
        completionHandler(photoImage) //@escaping 키워드를 붙혔기때문에 함수가 끝나더라도 클로져는 남이 있다.
        
    }.resume()
    
}



// 올바르게 설계한 함수 실행
properlyGetImages(with: "https://bit.ly/32ps0DI") { image in
    DispatchQueue.main.async {
        guard let image1 = image else { return}
        print(image1)
    }
}












//3. weak, strong 캡쳐의 주의 - 객체 내에서 비동기 코드 사용시
//대부분의 경우, 캡처리스트 안에서 weak self로 선언하는것이 권장
//클로저의 강한 참조 주의


// 강한 참조가 일어나고, (서로가 서로를 가르키는) 강한 참조 사이클은 일어나지 않지만
// 생각해볼 부분이 있음
// 예전 ARC 예제
class ViewController: UIViewController {
    
    var name: String = "뷰컨"
    
    func doSomething() {
        DispatchQueue.global().async {
            sleep(3)
            print("글로벌큐에서 출력하기: \(self.name)")
        }
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


func localScopeFunction() {
    let vc = ViewController()
    vc.doSomething()
}


//localScopeFunction()

/*
 - (글로벌큐)클로저가 강하게 캡처하기 때문에, 뷰컨트롤러의 RC가 유지되어
 - 뷰컨트롤러가 해제되었음에도, 3초뒤에 출력하고 난 후 해제됨
 - (강한 순환 참조가 일어나진 않지만, 뷰컨트롤러가 필요없음에도 오래 머무름)

 - 그리고 뷰컨트롤러가 사라졌음에도, 출력하는 일을 계속함
 */



//====================================================================================
class ViewController1: UIViewController {
    
    var name: String = "뷰컨"
    
    func doSomething() {
        // 강한 참조 사이클이 일어나지 않지만, 굳이 뷰컨트롤러를 길게 잡아둘 필요가 없다면
        // weak self로 선언
        DispatchQueue.global().async { [weak self] in
            guard let weakSelf = self else { return }
            sleep(3)
            print("글로벌큐에서 출력하기: \(weakSelf.name)")
        }
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


func localScopeFunction1() {
    let vc = ViewController1()
    vc.doSomething()
}


localScopeFunction1()

/*
 - 뷰컨트롤러를 오래동안 잡아두지 않음
 - 뷰컨트롤러가 사라지면 ===> 출력하는 일을 계속하지 않도록 할 수 있음
   (if let 바인딩 또는 guard let 바인딩까지 더해서 return 가능하도록)
 */
















//4. 동기함수를 비동기적으로 동작하는 함수로 변형하는 방법
//작업을 오랫동안 실행하는 함수가 있다고 가정
func longtimePrint(name: String) -> String {
    print("프린트 - 1")
    sleep(1)
    print("프린트 - 2")
    sleep(1)
    print("프린트 - 3 이름:\(name)")
    sleep(1)
    print("프린트 - 4")
    sleep(1)
    print("프린트 - 5")
    return "작업 종료"
}


longtimePrint(name: "잡스")

// 작업을 오랫동안 실행하는데, 동기적으로 동작하는 함수를
// 비동기적으로 동작하도록 만들어, 반복적으로 사용하도록 만들기
// 내부적으로 다른 큐로 비동기적으로 보내서 처리

func asyncLongtimePrint(name: String, completion: @escaping (String) -> Void) {
    DispatchQueue.global().async {
        let n = longtimePrint(name: name)
        completion(n)
    }
}

asyncLongtimePrint(name: "잡스") {
    print($0)
}
//결론적 동기함수를 비동기적으로 변경하려면 디스패치큐로 한번 감싸주면 된다.









//5.URLSession은 비동기 메서드
//URLSeesion 이나 네퉈이킹과 관련된 코드 등등은 대부분 비동기적인 처리가 이미 되어있다.
//하지만 어떤 코드들은 비동기적처리가 안되어있다. 그렇기때문에 제대로사용해주려면 디스패치큐로 감싸줘야한다.

let movieURL = "https://bit.ly/2QF3ID2"


// 1. URL 구조체 만들기
let url = URL(string: movieURL)!

// 2. URLSession 만들기 (네트워킹을 하는 객체 - 브라우저 같은 역할)
let session = URLSession.shared


// 3. 세션에 (일시정지 상태로)작업 부여
let task = session.dataTask(with: url) { (data, response, error) in
    if error != nil {
        print(error!)
        return
    }

    guard let safeData = data else {
        return
    }

    print(String(decoding: safeData, as: UTF8.self))

}

// 4.작업시작
task.resume()   // 일시정지된 상태로 작업이 시작하기 때문
//URLSession 사용하기 ➡︎ 내부적으로 비동기 동작한다는 것을 알고 써야함








print("출력 - 1")

URLSession.shared.dataTask(with: url) { (data, response, error) in
    if error != nil {
        print(error!)
        return
    }
    
    guard let safeData = data else {
        return
    }
    
    print(String(decoding: safeData, as: UTF8.self))
    
}.resume()

print("출력 - 2")






















sleep(5)


PlaygroundPage.current.finishExecution()

```