# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR

```swift

// #KeyPath ===================================
//속성에 쉽게 접근하기위한 기술이다.
//경로를 만들어서 아주 쉽게 접근이 가능함

class Dog {
    var name: String
    init(name: String) {
        self.name = name
    }
}

let dog1 = Dog(name: "한별")

dog1.name

"dog1.name" //이런식으로 접근하면 안될까?

// 위의 코드에서 굳이 필요성을 못 느낄수도 있겠지만

class School {
    var name: String
    var affiliate: SmallSchool
    
    init(name: String, affiliate: SmallSchool) {
        self.name = name
        self.affiliate = affiliate
    }
}

class SmallSchool {
    var classMember: Person
    init(classMember: Person) {
        self.classMember = classMember
    }
}

class Person {
    var name: String
    init(name: String) {
        self.name = name
    }
}

let person1 = Person(name: "홍길동")
let smallSchool1 = SmallSchool(classMember: person1)
let school1 = School(name: "슈퍼고", affiliate: smallSchool1)

//만약에 접근하기 위해 써야하는 코드가 늘어난다면

var gildongsName = school1.affiliate.classMember.name



//keypath로 표현한다면?

let namePath = \School.affiliate.classMember.name //미리 경로를 만들어둠 이걸 keyPath라고함


school1[keyPath: namePath] //서버스크립트로 접근
//school1[keyPath: namePath.appending(path: \.name)] //경로를 추가하는것도 가능함(appending 메서드)


print(school1[keyPath: namePath])


/*
keyPath 타입 (외울 필요 없음)
- AnyKeyPath                             : 어떤 속성인지 특정되지 않음(보통, 함수 파라미터형식으로만 사용)
- PartialKeyPath<Root>                   : 타입에 대한 키패스(예를 들어 배열 같은 것으로 묶을때 사용)
- KeyPath<Root, Value>                   : 타입과 (읽기)속성에 대한 키패스(구조체)
- WritableKeyPath<Root, Value>           : 타입과 읽기/쓰기 가능한 속성에 대한 키패스(구조체)
- ReferenceWritableKeyPath<Root, Value>  : 클래스의 타입과 읽기/쓰기 가능한 속성에 대한 키패스
*/













// #selector ===================================

//클래스, Objective-c 프로토콜에 포함된 멤버에만 적용가능(구조체 적용불가)
//내부적으로 Objective-C 프레임워크를 사용하고 있기 때문에
//@objc 특성을 추갛야지만 사용가능
//어디에 자주쓰냐면 주로 코드에서 특정 이벤트를 함수/메서드에 연결시킬때 많이쓴다.
//버튼, 타이머, 알림 등등



class Dog {
    var num = 1.0
    
    @objc var doubleNum: Double {
        get {
            return num * 2.0
        }
        set {
            num = newValue / 2.0
        }
    }
    
    @objc func run() {
        print("강아지가 달립니다")
    }
}


//문법적인 약속
//계산 속성을 가르킬때
let eyesSelector = #selector(getter: Dog.doubleNum) //계산 읽기 속성
let nameSelector = #selector(setter: Dog.doubleNum)


//메서드를 가리킬떄
let runSelector = #selector(Dog.run)
//#selector(여기안에 우리가 가리키고싶은 메서드를 넣는다)
//예를들어 Dog.run 의 메모리주소가 90번이면 90번째 메모리르 주소를 runSelector 변수에 담는것


//셀렉터는 속성에 접근이나 메서드를 호출하는것이 아님 -> 가르키기만 할뿐

class ViewController: UIViewController {
    let codeButton: UIButton = UIButton(type: .system) //버튼을만들고
    
    override func viewDidLoad() { //뷰디드로드 함수를 재정의
        super.viewDidLoad()
        configureUI() //그리고 우리가 만든 함수를 또 호출
    }
    
    
    func configureUI() {
        //버튼셋팅
        codeButton.setTitle("버튼", for: .normal)
        codeButton.setTitleColor(.white, for: .normal)
        codeButton.backgroundColor = UIColor.black
        
        
        //자동제약 잡아주는 것 취소 ---> 코드로 오토레이아웃을 잡으려면 필수
        codeButton.translatesAutoresizingMaskIntoConstraints = false
        
        //버튼을 눌렀을때 실행시킬 함수 연결하기 ******
        //이 버튼이 더치업인사이드 방식으로 눌렸을때 어떤 인스턴스의 메서드를 실행을 시킬지를 연결하는 함수
        //이함수는 지금 뷰컨 클래스 안에있고 나는 뷰컨안에있는 다른 메서드를 실행시키고 싶으니까 Target은 self
        codeButton.addTarget(self, action: #selector(codeButtonTapped), for: .touchUpInside)
        
        //버튼을 화면에 올리기
        //UIViewController클래스에는 view라는 변수가있음 스토리보드에있는 그 View다 전체화면을 의미함
        view.addSubview(codeButton)
        
        //오토레이아웃 코드로 짜기
        NSLayoutConstraint.activate([
            codeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            codeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 30),
            codeButton.widthAnchor.constraint(equalToConstant: 200),
            codeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    @objc func codeButtonTapped() {
         print("코드 버튼 눌림")
    }
}






