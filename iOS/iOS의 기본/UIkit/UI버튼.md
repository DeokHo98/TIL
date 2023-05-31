```swift
UI버튼





UI버튼을 코드로 연결 하는방법

@IBOutlet weak var button: UIButton!

func action() {

}

@objc func action(_ sender : Any) {

}

func action(_ sender: Any, forEvnet event: UIEvent) {

}



viewdidload() {
    let sel = #selector(action(_ :))
    btn.addTarget(self, action: sel, for: .tochUpInside)
}



버튼의 타입
버튼의 타입은 여러기자 있지만 가장 기본적인 타입은
System 타입이며
Detail Disclosure
Info light, Dark
Add contact 
close 
등등 여러 버튼의 타입이 있다.


버튼의 state config
버튼의 state config는 4가지가 있다.
Default Highlighted, selected, Disabled 가 있다.

Default는 isEnabled = true 인 상태이며 isHighlighted = false, isSelected = false 인 상태이다.
Disable는 isEnabled  = false 상태이다.

코드로 각 상태의 따라서 글자라던가 글자색이라던가 등을 바꿔 줄수 있다.

        btn.setTitle("하", for: .normal)
        btn.setTitle("마", for: .highlighted)
        
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.setTitleColor(.red, for: .highlighted)
        
이러한 기능을 가지고 버튼이 클릭되었을때 아닐때 누르고있을때 등등의 이미지도 각각 구현이 가능하다.



```

# 텍스트 버튼 만들기
```swift
    func attributedTitle(firstPart: String, secondPart: String) {
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "\(firstPart) ", attributes: atts)
        
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 16)]
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
```