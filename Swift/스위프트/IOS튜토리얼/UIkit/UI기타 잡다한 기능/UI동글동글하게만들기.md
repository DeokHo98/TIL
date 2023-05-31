
```swift
import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messagerBubble: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messagerBubble.layer.cornerRadius = messagerBubble.frame.size.height / 5 //이녀석임
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}










//MARK: - 스토리보드에 UI 오브젝트 둥글게하는 기능 넣기
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}



//MARK: - 버튼 둥글게 하는 기능
extension UIButton {
    var circleButton: Bool {
        set {
            if newValue {
                self.layer.cornerRadius = 0.5 * self.bounds.size.width
            } else {
                self.layer.cornerRadius = 0
            }
        } get {
            return false
        }
    }
}
```

