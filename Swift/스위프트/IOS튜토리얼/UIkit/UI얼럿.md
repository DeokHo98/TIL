# 기본적인 얼럿 띄우기
얼럿 스타일중에 .destructive 라는것이 있는데 이 스타일을 사용하면 빨간색으로 표시된다. 뭔가 부정적인 이미지
또한 순서도 스타일별로 다르다 .defaulu는 넣을 순서대로이지만 .cancle은 항상마지막 그리고 .destructive는 .cancle전에 표시된다.


```swift

    @IBAction func addButtenPressed(_ sender: Any) {
        let alert = UIAlertController(title: "새로운 할일을 만드시겠습니까?", message: "", preferredStyle: .alert) //얼럿 틀을 만들고
        
        let yesAction = UIAlertAction(title: "네", style: .default) { action in //yes 버튼을 만들기 여기서 프린트 자리에는 버튼을 눌렀을때 작동할 코드 작성
         print("성공")
        }
        
        let noAction = UIAlertAction(title: "아니요", style: .default, handler: nil) // no버튼은 눌렀을때 아무일도 일어나지않기때문에 handler가 nil
        
        alert.addAction(yesAction) //얼럿에 yes 버튼 연결
        alert.addAction(noAction)  //얼럿에 no 버튼 연결
        
        present(alert, animated: true, completion: nil) //화면에 띄어주는 녀석
        
    }
    
    


 ```


# 얼럿에 텍스트필드 띄우기

```swift
    @IBAction func addButtenPressed(_ sender: Any) {
        
        var textField = UITextField() //전역변수를 하나만들어주고
        
        let alert = UIAlertController(title: "새로운 할 일을 만드시겠습니까?", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { [self] action in
 
            if textField.text != nil {
                itemArray.append("새로운 할 일")
            } else {
                itemArray.append(textField.text!)
            }
                
                
                
        //textField에 사용자가 아무것도 안쓰면 그냥 "새로운 할일" 이라는 이름의 배열을 추가.
            tableView.reloadData() //table뷰 업데이트하기
        }
        
        let noAction = UIAlertAction(title: "아니요", style: .default, handler: nil)
        
        
        //얼럿창에 텍스트 필드 띄우기
        alert.addTextField { alertTextfield in
            alertTextfield.placeholder = "새로운 할 일" //텍스트 필드 대기문자 만들기 회색 그거
            textField = alertTextfield //이 스코프 밖에 전역변수로 전달
        }
        
        
        
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
        
    }
```



# 얼럿 action sheet 만들기
```swift
class ActionSheetViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func show(_ sender: UIButton) {
        let controller = UIAlertController(title: "Languages", message: "Choose one", preferredStyle: .actionSheet)//.alert이아니라 .actionSheet를 해주면 여백을두고 따로 표시가되고 반투명부분을 터치하면 자동으로 사라지는 기능도 있다. //
        
        let swiftAction = UIAlertAction(title: "Swift", style: .default) { [weak self] (action) in
            self?.resultLabel.text = action.title
        }
        controller.addAction(swiftAction)
        
        let javaAction = UIAlertAction(title: "Java", style: .default) { [weak self] (action) in
            self?.resultLabel.text = action.title
        }
        controller.addAction(javaAction)
        
        let pythonAction = UIAlertAction(title: "Python", style: .default) { [weak self] (action) in
            self?.resultLabel.text = action.title
        }
        controller.addAction(pythonAction)
        
        let cSharpAction = UIAlertAction(title: "C#", style: .default) { [weak self] (action) in
            self?.resultLabel.text = action.title
        }
        controller.addAction(cSharpAction)
        
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { [weak self] (action) in
            self?.resultLabel.text = nil
        }
        controller.addAction(clearAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        
        //아이패드같은경우에는 액션시트를 띄우려면 몇가지가 필요하다.
        if let pc = controller.popoverPresentationController {
            //pc.barButtonItem //만약 얼럿을 띄우는 버튼이 바버튼이면 이걸로 간단해결 아니면 아래로
            pc.sourceView = view
            pc.sourceRect = sender.frame
        }
        
        
        
        //이미 선택한 얼럿 또 선택 못하게하기
        for action in controller.actions {
            if action.title == resultLabel.text {
                action.isEnabled = false
            }
        }
        
        
        
        
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}


```