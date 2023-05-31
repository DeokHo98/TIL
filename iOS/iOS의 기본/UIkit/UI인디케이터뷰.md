```swift


우리가 완료시점을 알수 있다면 프로그래스바로 구현하고
알수없다면 인디게이터뷰로 구현을 한다.

class ActivityIndicatorViewViewController: UIViewController {
    
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var hiddenSwitch: UISwitch!
    
    @IBAction func toggleHidden(_ sender: UISwitch) {
        indicatorView.hidesWhenStopped = sender.isOn
    }
    
    @IBAction func start(_ sender: Any) {
        indicatorView.startAnimating()
    }
    
    @IBAction func stop(_ sender: Any) {
        indicatorView.stopAnimating()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.style = .large //크기 스타일 설정
        indicatorView.color = .blue //색깔 설정
        hiddenSwitch.isOn = indicatorView.hidesWhenStopped //true면 애니메이션이 중지되는 시점에 화변에서 인디게이터뷰가 사라진다.
    }
}


```