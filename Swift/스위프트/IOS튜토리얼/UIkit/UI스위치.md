```swift

class SwitchViewController: UIViewController {
    
    @IBOutlet weak var bulbImageView: UIImageView!
    
    @IBOutlet weak var testSwitch: UISwitch!
    
    
    
    @IBAction func toggle(_ sender: Any) {
        testSwitch.setOn(!testSwitch.isOn, animated: true)
        switchon(testSwitch)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testSwitch.thumbTintColor = .blue //스위치가 꺼졌을때 색깔
        testSwitch.onTintColor = .red //스위치가 켜졌을때 색깔
        
        testSwitch.isOn = bulbImageView.isHighlighted
    }
    @IBAction func switchon(_ sender: UISwitch) {
        bulbImageView.isHighlighted = sender.isOn
    }
}


```