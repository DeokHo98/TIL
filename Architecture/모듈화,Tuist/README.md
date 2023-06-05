# Study-Tuist-Tutorial


Tuist Tutorial for Xcode - Kodeco    
https://www.kodeco.com/24508362-tuist-tutorial-for-xcode 학습 레포짓 



# Tuist
Tuist는 프로젝트의 구조에서 복잡성을 제거하여 Xcode 프로젝트를 보다 쉽게 처리 할 수 있도록 하는 도구이다.   
이 자습서에서는 Tuist를 사용하여 기존 Xcode 프로젝트를 Tuist로 관리하는 방법을 배울 수 있다.     
여기서 배우는것은 아래와 같다.    

- project와 workspaces 파일을 제거하고 대신 필요할때마다 생성해서 사용하기    
- 단위 테스트 추가하기     
- Swift Package Manager 종속성 처리하기    
- Tuist에 의존하는 새로운 기능 추가하기   


# Tuist 설치 및 시작
터미널을 열고 아래 명령을 실행
```
bash <(curl -Ls https://install.tuist.io)
```

첫번째 목표는 이 프로젝트를 Tuist를 사용할수 있게 변환하는것이다.   
이 시점부터는 더이상 프로젝트 디렉터리의 루트에 프로젝트 및 작업 영역 파일을 유지하는 의존하지 않는다.    

- Tuist Manifest File의 이해.     
Tuist 매니페스트 파일은 Tuist에게 Xcode 프로젝트 파일을 생성하는 방법을 알려주는 Project.swift라는 파일이다.    
명령줄에서 Tuist와 상호작용하고 Xcode에서 Tuist 매니페스트를 빌드한다.    
Tuist는 매니페스트 파일 작업을 위한 환경을 생성한 다음 Xcode를 시작하여 코드완성 및 Xcode환경을 제공한다.   
       
기존 프로젝트와 workSpace 파일을 삭제하자.     
다음으로 빈 Tuist 매니페스트 파일을 만들자. 터미널에서 프로젝트로 이동하고 다음을 입력
```
touch Project.swift
```
이렇게 하면 빈 매니페스트가 생성된다.    
다음으로 입력하자.   
```
tuist edit

//Generating project Manifests
//Opening Xcode to edit the project. Press CTRL + C once you are done editing
```
이렇게하면 Xcode가 프로젝트 파일 편집을 시작할 수 있는 환경으로 열린다. Project.swift를 선택해보자     
그 뒤에 상단에 다음을 추가하자.    
```
import ProjectDescription
```
이렇게하면 Tuist 프로젝트 DSL에 엑세스 할 수 있다. 이를 사용하여 유용한 코드 완성으로 프로젝트를 구축하는것이 가능하다.       
   
   
   
# 프로젝트 정의
첫번째 단계는 기본 프로젝트를 설정하는 것이다. 아래의 Project.swift에 코드를 추가해보자.   
```
let project = Project(name: "MovieInfo",
                      organizationName: "YOUR_ORG_NAME_HERE",
                      settings: nil,
                      targets: [])
```
    
     
- project: 기본 프로젝트 및 workSpace를 나타내는 프로젝트를 생성한다. 원하는 이름을 지정할수 있지만 project를 추천
- name: 프로젝트 및 작업 공간 "파일"의 이름을 나타낸다.   
- organizationName: 각각의 새 파일 상단에 저작권 표시에 나타나는 이름이다. 조직 이름으로 바꾸면 된다.   
- settings: 설정을 사용하여 다른 프로젝트 설정을 지정할 수 있다.   
- targets: 프로젝트와 연결된 대상 목록을 나타낸다. 

참고: Command-B를 사용하여 다른 Xocde프로젝트와 동일한 방법으로 Tuist 매니페스트를 빌드할 수 있다. Swift를 사용하면 다른곳과 동일한,    
유형의 안전을 얻울 수 있으며, 당신이 잘못한게 있다면 컴파일러가 알려줄 것이다.    
   
   
# 첫번째 Targets 정의
빈targets 배열에 다음을 추가하자.   
```
            targets: [Target(name: "MovieInfo",
                                       platform: .iOS,
                                       product: .app,
                                       bundleId: "<YOUR_BUNDLE_ID_HERE>",
                                       infoPlist: "MovieInfo/Info.plist",
                                       sources: ["MovieInfo/Source/**"],
                                       resources: ["MovieInfo/Resources/**"],
                                       dependencies: [],
                                       settings: nil)]
```
- name: 앱의 이름을 지정       
- platform: 지원할 플랫폼을 설정     
- product: 제품을 앱으로 정의    
- bundleId: 대상의 번들 ID를 설정    
- infoPlist: Porject.swift에 상대적인 info.plist를 찾음    
- sources: 와일드 카드 패턴을 사용해 Source 디렉터리의 모든 소스 파일을 지정, 모든 디렉토리는 프로젝트 생성 후 Xcode 그룹이 된다.   
- resuources: 와이들 카드 패턴을 사용해 Resource 디렉토리의 모든 파일을 지정, 이러한 디렉토리는 프로젝트 생성 후 Xocode 그룹이 된다.   
- dependencies: 연결이 필요한 프레임워크인 종속성을 지정한다, 없는경우 빈 배열 
- settings: 대상에 다른 설정을 지정하는데 사용된다.    
   
     
참고: 더 사용할 수 
