```swift
주로 연관된 옵션중 하나를 선택하는 ui를 구현할때 사용한다.
세그먼티드에서의 isMomentary 속성을 체크되어있지않으면 선택을 계속 유지하고
속성을 체크하면 선택상태가 유지가되지않는다.

private let  accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()



```