```swift
슬라이더를 움직이면 값이 막 바뀌는 그런거라고 생각하면 편함

슬라이더를 이용해서 색깔을 한번 바꿔 보자
class SimpleSliderViewController: UIViewController {
    
    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var greenSlider: UISlider!
    
    @IBOutlet weak var blueSlider: UISlider!
    

    
        override func viewDidLoad() {
        super.viewDidLoad()
            //슬라이더는 값의 범위를 가지고 있다.
            redSlider.maximumValue = 255
            redSlider.minimumValue = 0
            redSlider.value = 255
            greenSlider.maximumValue = 255
            greenSlider.minimumValue = 0
            greenSlider.value = 255
            blueSlider.maximumValue = 255
            blueSlider.minimumValue = 0
            blueSlider.value = 255
        
        
    }
    
    
    
    @IBAction func sliderChanged(_ sender: Any) {
        let r = CGFloat(redSlider.value)
        let g = CGFloat(greenSlider.value)
        let b = CGFloat(blueSlider.value)
        
        view.backgroundColor = UIColor(displayP3Red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


슬라이더의 속성을 한번 건드려보자

class CustomSliderViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //슬라이더 동그라미 이미지를 바꾸기
        slider.setThumbImage(UIImage(systemName: "pencil"), for: .normal)
        
        //슬라이더의 작아질때와 커질때의 색갈을 다르게 표시하기
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .blue
        
        //슬라이더 동그라미 색깔 바꾸기
        //slider.thumbTintColor = .black 대신 이걸 바꾸면 이미지는 적용되지않는다.
        
        //슬라더의 커질때와 작아질때의 이미지를 다르게 표시하기
       // slider.setMinimumTrackImage(UIImage(systemName: "folder"), for: .normal)
        //slider.setMaximumTrackImage(UIImage(systemName: "trash"), for: .normal)
    }
}


슬라이더의 continuous updates 옵션이 있는데
이옵션을 체크하면 값이 지속해서 계속 변하고
체크하지않으면 슬라이더에서 손을 뗏을때 그때 딱한번 값이 변한다.
class NonContinuousSliderViewController: UIViewController {
    
    @IBOutlet weak var valueLabel1: UILabel!
    @IBOutlet weak var slider1: UISlider!
    
    @IBOutlet weak var valueLabel2: UILabel!
    @IBOutlet weak var slider2: UISlider!
    
    
    @IBAction func sliderChanged1(_ sender: UISlider) {
        valueLabel1.text = String(format: "%.1f", sender.value)
    }
    
    @IBAction func sliderChanged2(_ sender: UISlider) {
        valueLabel2.text = String(format: "%.1f", sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           
        slider1.isContinuous = false //이렇게 이속성에 false를 저장하면 손을 뗄때 값이 변한다
    }
}

```