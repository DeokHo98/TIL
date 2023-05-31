```swift

//다중화면을 구현할때 다른 화면으로 넘어가는 segu 라고한다. 여러가지 넘어가는 방식이있고
//segu에 identifier 이름을 만들어주면 코드에서도 사용할수 있다.


class CalculateViewController: UIViewController {
    @IBAction func seguPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "segu identifier 이름", sender: self)
        //sender는 segue의 창시자. 이동을 시작하는 뷰컨이 될것.
    }
    
}

//물론 스토리보드를 통해서 이런 코드없이 세구를 만들수도 있다. 그냥 버튼에 바로 다른 뷰를 연결시키는것도 가능





//다른 veiwcontroller 에 있는 변수나 데이터에 접근하는 방법

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let 변수이름 = segue.destination as! 다른veiwcontroller
            변수이름.num = 0
        }
    }





//segu를 통해 왔던 길을 되돌아 가는방법

@IBAction func returnsegu(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        //animated: 애니메이션을 넣을것이냐? true
        //completion: 완료한뒤에 어떤 클로저를 실행할것이냐? nil
    }


navigationController.pop 을 이용해 맨처음 뷰로 바로 이동할수도 있음
    @IBAction func segu(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
        
    }



// 네이게이션바에서 back 버튼을 없애는 코드

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "⚡️FlashChat"
        navigationItem.hidesBackButton = true

    }


//네비게이션바를 숨기는 방법 이렇게하면 어떤 뷰에서든 가려짐

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
 navigationController?.isNavigationBarHideen = true
}

 //만약 네비게이션 연결된 뷰를 제외하고 다른 뷰에서 네비게이션바를 나타나게 하고싶다면?

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
     navigationController?.isNavigationBarHideen = false
}
```



# 네비게이션바 투명하게 하는법
```swift
viewdidload에다 작성

navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
```

# 네비게이션바에 서치바 구현하기

```swift

  navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "🔍 전체에서 검색하기", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        navigationItem.searchController?.searchBar.searchTextField.textColor = .black
        navigationItem.searchController?.searchBar.tintColor = .systemGray2
        navigationItem.searchController?.searchBar.searchTextField.backgroundColor = .systemGray2
        navigationItem.searchController?.searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)

```
