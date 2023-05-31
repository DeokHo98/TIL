
# 본문의 글은 인프런 앨런 Swift문법 마스터 스쿨(온라인) 부트캠프의 강의 영상을 본후 공부한 내용을 정리하여 기록한것입니다.
https://inf.run/YyoR


```swift
import PlaygroundSupport
//플레이 그라운드 작업 중간에 멈추지 않게 하기 위함
// 비동기작업으로 인해 플ㄹ레이그라운드의 모든 작업이 끝난다고 인식할수 있기때문에 사용
PlaygroundPage.current.needsIndefiniteExecution = true






//디스패치큐 = GCD 크게는 3가지있다.
//1. DispatcgQueue.main
//2. DispatcgQueue.global()   //글로벌큐도 몇가지 종류가 또 있기는함
//3. DispatcgQueue.(label:"...") //커스텀큐


//큐(Queue/대기열)의 종류 ==============================
//1)메인큐
//1번 쓰레드를 메인큐라고 한다. 메인쓰레드("쓰레드1번"을 의미), 한개뿐이고 당연히 직렬큐

let mainQueue = DispatchQueue.main

mainQueue.async { //이런경우는 뒤에배울 특별할 상황에만 쓰인다 어차피 원래 보통 다른쓰레드에서 실행하지않으면  작업들은메인큐에서 일어나기때문.
    
}



//2) 글로벌큐
//글로벌큐 라는 녀석은 서비스의 품질에 따라서 종류가 여러개 있음 기본적으로는 동시큐다.
// 6가지의 Qos를 가지고 있는 글로벌(전역) 대기열
//서비스의 품질이 높을수록 여러개의 쓰레드를사용한다.
//서비스의 품질의 개념 => ios가 알아서 우선적으로 중요한 일임을 인지하고 쓰레드의 우선순위를 매겨 더 많은 쓰레드를 배치하고 cpu의 배터리를 더 집중해서 사용하도록 해서 일을 빨리 끝내도록 하는 개념


//아래로갈수록 서비스품질(사용하는 쓰레드)이 낮다. 근데 또 서비스품질이 높다고 무조건 작업을 빨리하고 하지는 않는다.

let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
//소요시간: 거의즉시   //유저와 직접적 인터렉티브: ui업데이트관련,애니메이션,ui반응 등등
//사용자와 직접상호작용하는작업에 권장되며 작업이 빨리처리되지않으면 앱이 멈춘거같이 보일만한 작업같은..

let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
//소요시간: 몇초  //유저가 즉시필요하긴하지만 비동기적으로 처리된작업 ex: 앱내에서 pdf파일을 여는 것과같은..

let defaultQueue = DispatchQueue.global()  // 디폴트 글로벌큐 : 일반적인작업 이걸 아주자주사용함

let utilityQueue = DispatchQueue.global(qos: .utility) //디폴트 글로벌큐 다음으로 자주사용함
//소요시간: 몇초에서 몇분 //보통 Progress indicator와 함께 길게 실행되는 작업이나 계산.

let backgroundQueue = DispatchQueue.global(qos: .background)
//소요시간 몇분이상(연비위주)  //유저가 직접적으로 인지하지않고(시간이안중요한) 작업 백업같은거
let unspecifiedQueue = DispatchQueue.global(qos: .unspecified)
//스레드를 서비스 품질에서 제외 시키는것)



//3) 프라이빗(커스텀)큐
//기본적인 설정은 직렬, 다만 동시 설정도 가능


let privateQueue = DispatchQueue(label: "com.inflearn.serial")


DispatchQueue(label: "abcdef") //이렇게 개발자가 직접 만들수 있음
DispatchQueue(label: "정덕호", qos: <#T##DispatchQoS#>, attributes: .concurrent) //이렇게 동시설정도 가능
//근데 일반적으로 직렬큐룰 만들때 씀..





sleep(5)

PlaygroundPage.current.finishExecution()



//플레이그라운드 vs 실제 앱 (주의)
//실제 앱에서는 UI관련작업들이 DispatchQueue.main(메인큐)에서 동작하지만, 플레이 그라운드에서는 DispatchQueue.global()(글로벌 디폴트큐)에서 동작한다. 따라서 플레이그라운드에서는 메인큐에 일을 시키면 안된다.
// DispatchQueue.main ====> 앱에서는 UI를 담당
// DispatchQueue.global() ====> 플레이그라운드에서 프린트영역를 담당
```