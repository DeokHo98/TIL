## Global DispatchQueue 의 Qos 에는 어떤 종류가 있는지, 각각 어떤 의미인지 설명하시오.
<br>

    userInteractive는 UI처리와 관련된 옵션이고, UI처리를 담당해서 메인쓰레드에서 작업을 합니다. userInitiated는 유저의 액션에 대해서 즉각적인 결과를 제공해야 할 때. 예를 들어서 이메일 내용 불러오기 같은 것을 처리할 때 사용합니다.
    default는 우선순위를 지정하지 않으면 사용되는 옵션이고,
    utility는 다운로드 같이 시간이 걸리고 즉각적인 결과가 필요하지 않을 때 사용합니다.
    background는 사용자가 볼 수 없는 백그라운드에서 작동을 하고 에너지 효율에 중점을 두고 있습니다.

- [블로그1](https://zeddios.tistory.com/521)
- [블로그2](https://velog.io/@zeke/whatsDispatchQueueQoS)
<br>
<br>

## iOS 앱을 만들고, User Interface를 구성하는 데 필수적인 프레임워크 이름은 무엇인가?
<br>

    UIKit입니다.

<br>
<br>

## Foundation Kit은 무엇이고 포함되어 있는 클래스들은 어떤 것이 있는지 설명하시오.
<br>

    기본적인 데이터 타입부터 컬렉션, 각종 구조체나 타이머, 네트워크 등 애플리케이션의 기본적인 기능을 담당하는 프레임워크.

- [블로그](https://babbab2.tistory.com/51)
- [공식문서](https://developer.apple.com/documentation/foundation)

<br>
<br>

## Delegate란 무언인가 설명하고, retain 되는지 안되는지 그 이유를 함께 설명하시오.
<br>

    한 객체가 다른 객체의 업무를 대신하거나 객체에게 데이터를 전송하는 방법. 이 때 프로토콜을 이용해서 구현하게 됩니다. 델리게이트는 클래스에서 채택하려면 Anyobject를 채택한 프로토콜을 사용해야 하기 때문에 참조타입으로 바뀝니다.

- [블로그](https://fomaios.tistory.com/entry/iOS-%EB%A9%B4%EC%A0%91%EC%A7%88%EB%AC%B8-Delegate%EB%8A%94-retain%EC%9D%B4-%EB%90%A0%EA%B9%8C)
<br>
<br>

## NotificationCenter 동작 방식과 활용 방안에 대해 설명하시오.
<br>

    어떤 객체가 NotificationCenter에 이벤트롤 발생시키면, NotificationCenter에 등록된 옵저버는 그 이벤트에 대한 알림을 받아서 행동하는 방식입니다. 그래서 어떤 이벤트가 발생하면 다른 객체에서 그 시점에 맞춰서 뭔가 해야할 때 사용이 되고 NotificationCenter에 여러 옵저버를 등록할 수 있어서 동시에 여러 객체에게 전달할 때 사용이 됩니다.

- [블로그](https://jcsoohwancho.github.io/2019-08-23-NotificationCenter-%EC%82%B4%ED%8E%B4%EB%B3%B4%EA%B8%B0/)

<br>
<br>

## UIKit 클래스들을 다룰 때 꼭 처리해야하는 애플리케이션 쓰레드 이름은 무엇인가?
<br>

    메인 쓰레드.
    왜 메인쓰레드에서 처리해야 하나? UIKit은 앱이 실행이 되면 UIApplication 인스턴스화 되는데, 이 인스턴스는 메인 쓰레드에 붙어 있기 때문입니다. 그래서 이미지뷰, 버튼 이런것들도 UIView 이고 UIView는 UIApplication의 자식이기 때문에 (한마디로 애플이 그렇게 만들어서🤬)
    
- [블로그](https://zeddios.tistory.com/519)
<br>
<br>

## App Bundle의 구조와 역할에 대해 설명하시오.
<br>

    코드와 리소스를 폴더에 저장하는 것

- [블로그](https://sihyungyou.github.io/iOS-app-bundle/)
<br>
<br>

## 모든 View Controller 객체의 상위 클래스는 무엇이고 그 역할은 무엇인가?
<br>

    상위 객체는 UIResponder. 이벤트에 응답하고 처리하는 역할을 하는데 여기서 이벤트는 터치, 모션, 원격제어 등을 말한다. 만약 UIResponder가 이벤트를 처리하지 않는다면 처리할 수 있는 Responder가 나올 때 까지 연쇄적으로 다음 Responder에게 넘긴다.

- [UIViewController 상위 객체 확인](https://developer.apple.com/documentation/uikit/uiviewcontroller)
- [UIResponder](https://developer.apple.com/documentation/uikit/uiresponder)
- [UIResponder에 대해 자세히 다루는 블로그](https://jcsoohwancho.github.io/2019-07-25-Responder%EC%99%80-Responder-Chain,-%EA%B7%B8%EB%A6%AC%EA%B3%A0-First-Responder/)

<br>
<br>

## 자신만의 Custom View를 만들려면 어떻게 해야하는지 설명하시오.
<br>

    xib 파일 생성해서 스토리보드처럼 사용하거나, 코드로 클래스에서 UIView를 상속받아 사용

<br>
<br>

## View 객체에 대해 설명하시오.
<br>

    View는 앱에서 컨텐츠롤 보여주는 기본적인 요소이고 세 가지 역할이 있는데 첫번째는 내용을 보여주는 것이고 두번째는 터치 이벤트를 처리 세번째는 자신한테 포함된 서브뷰 관리입니다.

<br>
<br>

## UIView 에서 Layer 객체는 무엇이고 어떤 역할을 담당하는지 설명하시오.
<br>

    뷰를 그리기 위해 사용되는 인스턴스 변수 입니다. 뷰는 직접 컨텐츠나 애니메이션을 그리지 않고 layer에게 위임합니다. 그림자효과나 테두리 같은 시각적 효과를 layer가 맡아서 일을 합니다.

- [블로그](https://babbab2.tistory.com/53)
- [공식문서](https://developer.apple.com/documentation/uikit/uiview/1622436-layer)
<br>
<br>

## UIWindow 객체의 역할은 무엇인가?
<br>

    시각적인 요소를 포함하지 않고, 화면에 표시되는 View의 컨테이너 역할을 하고 뷰한테 터치 이벤트를 전달하는 역할도 하는 객체입니다.

- [블로그](https://woozzang.tistory.com/143)
<br>
<br>

## UINavigationController 의 역할이 무엇인지 설명하시오.
<br>

    내비게이션 컨트롤러의 역할은 사용자의 액션에 응답하여 뷰컨트롤러를 스택에 쌓거나 제거하는 역할은 한다. 스택구조여서 스택의 제일 하단에는 rootViewController가 있고 현재 보여지고 있는 뷰컨트롤러는 스택의 마지막에 위치한다.

- [공식문서](https://developer.apple.com/documentation/uikit/uinavigationcontroller)
- [블로그](https://ttuk-ttak.tistory.com/49)

<br>
<br>

## TableView를 동작 방식과 화면에 Cell을 출력하기 위해 최소한 구현해야 하는 DataSource 메서드를 설명하시오.
<br>

    numberOfRowsInSection, cellForRowAt 이 두가지 메서드가 테이블뷰 구현하기 위한 필수 메서드. numberOfRowsInSection 메서드는 하나의 섹션안에 몇개의 셀이 들어갈지 정하는 메서드이고, cellForRowAt은 셀안에 들어가는 데이터들을 어떻게 보여줄지 설정하는 메서드다.
- [numberOfRowsInSection](https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614931-tableview)
- [cellForRowAt](https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614861-tableview)

<br>
<br>

## 하나의 View Controller 코드에서 여러 TableView Controller 역할을 해야 할 경우 어떻게 구분해서 구현해야 하는지 설명하시오.
<br>

    tag를 활용하거나, 테이블뷰 메서드안에서 조건문으로 테이블뷰 구별해서 구현이 가능합니다.

<br>
<br>
