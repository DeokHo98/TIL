# 텍스트필드와 다르게 텍스트뷰의 특화된 특성
Editable 옵션에 true면 편집모드로 동작하고 fasle면 보기모드로 동작한다.   
Selectable 옵션이 true면 원하는 부분을 선택할수 있고 false면 선택이 불가능 하다.복사기능 이런거 못함..   


# 텍스트뷰 여백 넣기
textView.textContainerInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)   
이렇게 내부 여백을 직접 지정했으면   
textView.scrollIndicatorInsets = textView.textContainerInset   
을 꼭 해주자   

# 텍스트뷰에 이미지를 넣기

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        let attachment = NSTextAttachment()
        attachment.image = logo
        
        let attrString = NSAttributedString(attachment: attachment)
        textView.textStorage.insert(attrString, at: 0)
    }

```


# 텍스트뷰의 범위

```swift
class TextSelectionViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var selectedRangeLabel: UILabel!
    
    @IBAction func selectLast(_ sender: Any) {
        //내가 원하는 글자가 있는 범위를 찾는 방법
        let lastWord = "pariatur?"
        if let text = textView.text as NSString? {
            let range = text.range(of: lastWord)
            textView.selectedRange = range
            
            //선택한 범위로 스크롤 하는방법
            textView.scrollRangeToVisible(range)
        }
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
}


extension TextSelectionViewController: UITextViewDelegate {
//텍스트뷰에서 특정 범위를 선택하면 이 메서드가 호출이된다.
    func textViewDidChangeSelection(_ textView: UITextView) {
        let range = textView.selectedRange
        print(range)
        //선택한 범위와 글자 개수가 프린트된다.
    }
}
```



# 텍스트뷰의 다양한 문자열 옵션
Date Detectros 옵션을 이용하면   
link, phoneNumber, Address 등등 텍스트 뷰에 다양한 문자열을 표현할수 있다.