# 테이블뷰 셀 옵션
```swift
스타일의 종류
커스텀은 직접 커스텀
베이직은 하나의 텍스트만 표시
라이트 디테일은 셀 양쪽에 텍스트를 표시
레프트 디테일은 라이트디테일히고 비슷하지만 텍스트 정렬방식이 다름
서브타이틀은 텍스트 두개가 수직으로 표시됨

selection 옵션은 셀을 선택했을때 시각적으로 강조하는것을 표현한다. .none을 선택하면 셀을 선택해도 강조되지않음

아이덴티파이어 옵션에 셀을 구분하는 문자열을 입력해야함

엑세서리 옵션은 셀에 여라가지 엑세세리를 넣을수 있다. 체크마크 라던가 디테일이미지라던가 등등



```

# 테이블뷰 아주 기본적으로 구현하기
```swift
테이블뷰는 기본적으로 재사용 메커니즘을 가지고있다.
테이블뷰의 셀이 1만개면? 메모리용량이늘어나고 성능이 저하되기때문에 이런 메커니즘을 가지고 있다.


class viewcon: UIViewController {
    
    let list = ["iPhone", "iPad", "Apple Watch", "iMac Pro", "iMac 5K", "Macbook Pro", "Apple TV"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}



extension viewcon: UITableViewDataSource {
    //섹션에 표시할 셀 개수를 리턴
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    //섹션에 표시할 셀을 리턴
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
        return cell
    }
    
    
}

```



# 테이블뷰 섹션

```swift
//이 메서드가 리턴하는 수만큼 섹션을 표시함

extension viewcon: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
}
```



# 테이블뷰 Separator
```swift
//테이블뷰에서 세퍼레이터 스타일 바꾸기
   override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.separatorStyle = .singleLine
    }



//세퍼레이터 inset으로 줄을 원흐는대로 자루고 할수 있음
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row % list.count]
        cell.separatorInset.left = 30
        cell.separatorInset.right = 30
        return cell
    }



//각 셀마다 다르게 할수도 있음

unc tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row % list.count]
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        }
        return cell
    }
```


# 테이블뷰셀
테이블뷰 셀을 커스텀할때는 꼭 ContentView 아래 추가해주면 된다.   

```swift

//셀에 이미지나 레이블울 추가하기
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "star")
        return cell
    }

//특정 셀에 접급하는 방법
extension TableViewCellViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if let celltext = cell.textLabel?.text {
                print(celltext)
            }
        }
    }
}

//셀을 클릭했을때 다른 뷰로 넘어가며 특정 셀의 데이터도 세구로 넘겨주기

    @IBOutlet weak var tableview: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableview.indexPath(for: cell) {
                if let vc = segue.destination as? DetailViewController {
                    vc.value = list[indexPath.row]
                }
            }
        }
    }



    //다른 뷰
    class DetailViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    var value: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueLabel.text = value
    }
}


```


# 테이블뷰 악세사리뷰
```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Disclosure Indicator"
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell.textLabel?.text = "Dtail button"
            cell.accessoryType = .detailButton
        case 2:
            cell.textLabel?.text = "디테이 디스클"
            cell.accessoryType = .detailDisclosureButton
            cell.tintColor = .black //색을 바꾸려면 직접적으로 접근하는게 아닌 cell.tintColor에 접근해야함
        case 3:
            cell.textLabel?.text = "체크마크"
            cell.accessoryType = .checkmark
        default:
            cell.textLabel?.text = "없음"
            cell.accessoryType = .none
        }
        return cell
    }



악세서리뷰를 커스텀 해서 구현하기
class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let v = UIImageView(image: UIImage(systemName: "star"))
        accessoryView = v
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


     if indexPath.row == 4 {
            return tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        }


디테일버튼을 클릭했을때 이벤트 처리하기
extension AccessoryViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("셀을 클릭했습니다")
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("악세서리 뷰를 클릭했습니다")
    }
}
```


# self sizing
```swift
코드로 테이블뷰를 구현할때 셀프사이징을 활성화 시켜주는 방법
viewDidload 에서
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = UITableViewAutomaticDimension

긴 문자열을 셀에 입력하는경우 짤리는건 셀에설정하는것이아니라 레이블 자체에서 lines를 0 으로해줘야함


특정셀의 높이만을 조정하고 나머지셀은 셀프사이징으로 하기
extension SelfSizingCellViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 1000
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 1000
        } else {
            return UITableViewAutomaticDimension
        }
    }
}

```        


# 셀을 커스텀하는방법
```swift
extension CustomCellViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        if let dateLabel = cell.viewWithTag(100) as? UILabel {
            dateLabel.text = "오늘 -14시간"
        }
        if let locationLabel = cell.viewWithTag(200) as? UILabel {
            locationLabel.text = "뉴욕"
        }
        
        if let ampmLabel = cell.viewWithTag(300) as? UILabel {
            ampmLabel.text = "오전"
        }
        
        if let timeLabel = cell.viewWithTag(400) as? UILabel {
            timeLabel.text = "12:31"
        }
        
        return cell
    }
    
    //사실 태그 방식으로 잘 사용하지않고 아웃렛 방식으로 사용하는데 그냥 예시라고 생각하면된다.
}

```

# 테이블뷰 헤더
```swift
func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //테이블뷰를 plane로 하면 테이블뷰를 스크롤하면 헤더가 계속 고정되고
        //grouped로 하면 테이블뷰를 스크롤해도 헤더가 고정되지않고 셀과함께 스크롤된다
        //헤더를 원하는 ui로 구현하고싶으면 커스텀하면됨
        return "나라별 정리"
    }
```

# 테이블뷰 헤더를 커스텀
```swift
override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
    }




extension SectionHeaderAndFooterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        
        headerView?.textLabel?.text = "나라별 이름"
        headerView?.detailTextLabel?.text = "lorem ipsum"
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //헤더 레이블의 속성에 관련된 걸 처리할때는 이뷰에 처리해야함
        if let headerView = view as? UITableViewHeaderFooterView {
        
        headerView.textLabel?.textColor = .red
        headerView.textLabel?.textAlignment = .center
        
        if headerView.backgroundView == nil {
            let v = UIView(frame: .zero)
            v.backgroundColor = .systemBlue
            v.isUserInteractionEnabled = false
            headerView.backgroundView = v
        }
        }
    }
}

```


# 섹션 인덱스 타이틀
아이폰 연락처에 오른쪽에 글자별로 시작하면 해당 글자별로 연락처에 쉽게이동할수 있는 녀석이다.
필요할때 찾아서 구현하자.


# 셀 선택
```swift
셀 선택에관한 메서드 4가지


extension SingleSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //이메서드는 셀이 선택 되기전에 호출된다.메서드에서 IndexPath를 리턴하면 셀이 선택되고 nil을 리턴하면 선택되지않는다.
        //주로 어떤 조건에따라서 특정셀의 선택을 금지할때 사용한다
        print("셀선택 되기전")
          //아래처럼 하면 첫번째 셀은 선택하지못한다.
        if indexPath.row == 0 {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //이메서드는 셀이 선택된 직후에 호출된다.어떤셀이 선택됬는지는 IndexPath로 확인한다.
        let target = list[indexPath.section].countries[indexPath.row]
        print("셀선택 직후")
        showAlert(with: target)
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        //이메서드는 셀이 선택된후 해제되기 직전에 호출된다. IndexPath를 리턴하면 선택상태를 해제하고 nil을 리턴하면 선택을 유지한다.
        print("셀해제 전")
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //선택해제된 직후에 호출된다.
        print("셀 해제 직후")
        
    }





    셀의 강조효과

       func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        //셀을 선택시 강조효과를 넣을건지 아닌지
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        //강조된후에 호출됨
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        //강조효과가 제거된후 호출됨
    }
}

셀이 강조되기전과 강조되고나서의 텍스트컬러를 달리하는방버
class SingleSelectionCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textColor = .red
        textLabel?.highlightedTextColor = .blue
    }
}


랜덤한 셀을 선택되게 해보자

  func selectRandomCell() {
        let section = Int.random(in: 0 ..< list.count)
        let row = Int.random(in: 0 ..< list[section].countries.count)
        let target = IndexPath(row: row, section: section)
        
        listTableView.selectRow(at: target, animated: true, scrollPosition: .top)
    }
    


셀의 선택을 여러개할수있게하게하기
TableView.allowsMultipleSelection = true
```


# 편집모드
```swift

편집모드로 진입하는방법
listTableView.setEditing(true, animated: true)
이 역시 필요할때 찾아서 구현하자.

```


# 스와이프 액션 구현하기
```swift

extension SwipeActionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unreadAction = UIContextualAction(style: .normal, title: "읽지않음") { action, view, handler in
            handler(true)
        }
        
       unreadAction.backgroundColor = .blue
        unreadAction.image = UIImage(systemName: "star")

        let configuration = UISwipeActionsConfiguration(actions: [unreadAction])

       configuration.performsFirstActionWithFullSwipe = true //true로 하면 풀 스와이프 기능이 활성화되고 풀스와이프했을때 첫번째 액션이 작동함
        
   return configuration
    }

}

반대로 오른쪽은 trailingSwipeActionsConfigurationForRowAt 메서드에 구현
```


# 셀 순서를 변경하는 방법
```swift
셀을 꾹 누르고 원하는 위치로 이동시키는 방법
  //편집모드에서 순서를 바꾸는 기능은 기본적으로 비활성 그래서 여기서 true를 리턴해줘야함
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        //특정 셀을 이동시키고 싶으면 indexpath 파라미터를 이용
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //여기서 실제 데이터의 이동하는 코드를 만들어줘야함
        //테이블뷰는 셀이동과 애니메이션만 처리해주는것
        
    }
```



# prefetching API
테이블뷰에서 이미지를 불러올때 테이블뷰는 한번에 최대 4개의 이미지를 불러오는데 그래서 최초로딩시점에 4개만 다운로드된다.   
여기서 테이블뷰를 아래로 스크롤하면 5번째부터는 다운로드 후에 업데이트하는데 이시간동안 지연이 된다.   
여기서 prefetching api를 구현하면 다음에 표시할 이미지를 미리 다운로드한다.

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.prefetchDataSource = self
        
    }



extension PrefetchingViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            downloadImage(at: indexPath.row)
        }
        
    }


        func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            cancelDownload(at: indexPath.row)
        }
    }
    
    
}

```