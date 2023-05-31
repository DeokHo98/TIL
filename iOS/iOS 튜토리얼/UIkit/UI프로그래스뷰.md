```swift

뭔가 시간이 지나거나 완료되면 게이지가 올라가는 바 그런거 생각하면됨
완료 시점을 아는 경우에만 사용

class ProgressViewViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progressViewStyle = .default ////프로그래스뷰의 스타일
        progressView.progress = 0 //프로그래스뷰의 진행값을 의미 0부터 1 사이에 값을넣어야함
        progressView.progressTintColor = .red //진행된정도의 색깔
        progressView.trackTintColor = .blue //진행될 정도의 색깔
        
    }
    
    
    
    
    @IBAction func progressButton(_ sender: Any) {
        progressView.progress += 0.1
        
       //혹은 이런것도 가능
       // progressView.setProgress(0.5, animated: true)
    }
}