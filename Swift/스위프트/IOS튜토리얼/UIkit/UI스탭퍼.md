```swift
class StepperViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueStepper: UIStepper!
    @IBOutlet weak var autorepeatSwitch: UISwitch!
    @IBOutlet weak var continuousSwitch: UISwitch!
    @IBOutlet weak var wrapSwitch: UISwitch!
    
    @IBAction func toggleAutorepeat(_ sender: UISwitch) {
        valueStepper.autorepeat = sender.isOn
        //true면 스텝퍼를 길게 터치하고있으면 계속 값이 변동된다.
    }
    
    @IBAction func toggleContinuous(_ sender: UISwitch) {
        valueStepper.isContinuous = sender.isOn
        //이 옵션이 true면 스탭퍼가 올라가거나 내려가면 즉시 이벤트를 전달하고
        //false면 다 끝나면 이벤트를 전달한다.
    }
    
    @IBAction func toggleWrap(_ sender: UISwitch) {
        valueStepper.wraps = sender.isOn
        //이옵션이 true면 값이 순환한다. 최댓값에서 값을 늘리면 다시 최솟값으로 가는것
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        valueStepper.value = 0 //스탭퍼의 초기 값
        valueStepper.minimumValue = 0 //최솟값
        valueStepper.maximumValue = 100 //최댓값
        valueStepper.stepValue = 1 //올라갈 값
        
        
        autorepeatSwitch.isOn = valueStepper.autorepeat
        continuousSwitch.isOn = valueStepper.isContinuous
        wrapSwitch.isOn = valueStepper.wraps
        
    }
    @IBAction func stepperButton(_ sender: UIStepper) {
        valueLabel.text = "\(sender.value)"
    }
}



```