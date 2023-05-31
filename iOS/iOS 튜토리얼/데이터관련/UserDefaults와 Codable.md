# 기본데이터 베이스 만들고 정보 저장하기 UserDefaults

## viewcontroller

```swift

var itemArray = ["한별이랑 산착하기","달걀사오기"]



//앱이 실행되는 동안 지속적으로 키와 값의 쌍을 저장하는 기본 데이터베이스이다.
    
let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()

        //우리 기본 데이터베이스의 저장된 데이터를 키를 입력해서 문자열 배열 형태로 가져오는것이다
        //그리고 그 가져온 데이터를 itemArray 넣는다
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }


@IBAction func dataButten(_ sender: Any) {
        
        itemArray = ["밥먹기","화장실가기"]

        //우리가 이버튼을 누르면 itemArray 에 추가된 "밥먹기","화장실가기" 두개의 데이터가 
        //"TodoListArray"라는 키값으로 저장이된다.
        //그리고 Viewdidload 에서는 계속 그값을 불러와서 itemArray에 넣기때문에 
        //itemArray에 요소가 추가될때마다.
        //지속적으로 업데이트가 되는것이다. 
            defaults.set(itemArray, forKey: "TodoListArray")



우리가 저장한 데이터의 경로를 알고싶으면 appdelgate의 첫번째 apllication 메서드에
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
       를 넣어보면 콘솔에 프린트가될것이다.


```

# UserDefaults로 할수있는 몇가지 작업
```swift
let defaults = UserDefaults.standard

//예를들어 음악 볼륨을 조절하는앱에서 볼륨을 저장하고싶다면
defaults.set(0.24, forKey: "Volume")

let volume = defaults.float(forKey: "Volume")
print(volume)


//게임을 열때마다 항상 음악을 켜고 끄고싶다면
defaults.set(true, forKey: "MusicOn")
defaults.set(false, forKey: "MusicOff")

let musicOn = defaults.bool(forKey: "MusicOn")
print(musicOn)

//문자열 저장하고 가져오기
defaults.set("정한별", forKey: "name")
let name = defaults.string(forKey: "name")!

print(name)

//문자열은 옵셔널 타입으로 저장되기때문에 옵셔널을 벗겨줘야함



//날짜 시간 저장하고 가져오기

defaults.set(Date(), forKey: "date")

let date = defaults.object(forKey: "date")!
print(date)



//배열 저정하고 가져오기

let array = [1,2,3]
defaults.set(array, forKey: "array")

let myarray = defaults.array(forKey: "array")


//딕셔너리 저장하고 가져오기

let dic = ["이름": "정한별"]
defaults.set(dic, forKey: "dicdic")
let mydic = defaults.dictionary(forKey: "dicdic")

```

# UserDefaults 방법은 작은 비트의 데이터에 적합하다. 예를들어 게임에서 닉네임, 음악이 켜지고 꺼진것을 표시하는것 과 같은것
# 조금더 많은 오브젝트데이터를 저장하기위해서는 codable 적합하다.
# 우리만의 파일을 만들고 거기에 데이터를 저장해보자.
```swift

class TodolistViewController: UITableViewController {
 //items.plist 라는 파일을 커스텀 하고 Url 형식으로 바꾼것
let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

class Item: Codable {
    let defaultTittle: String = ""
    var title : String = ""
    var done: Bool = false
}


override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem?.tintColor = .white
        
        let newItem = Item()
        
        newItem.title = "한별이랑 산책하기"
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "공부하기"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "밥먹기"
        itemArray.append(newItem3)
        
        
        loadItem() //디코딩함수 불러오기

    }


 @IBAction func addButtenPressed(_ sender: Any) {
        
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "새로운 할 일을 만드시겠습니까?", message: "", preferredStyle: .alert) 
        
        let yesAction = UIAlertAction(title: "네", style: .default) { [self] action in
            
            let newItem = Item()
            
            if textField.text == "" {
                newItem.title = "새로운 할 일"
                itemArray.append(newItem)
            } else {
                newItem.title = textField.text!
                itemArray.append(newItem)
            }
            
         saveItem() //인코딩 함수 불러오기

        
        
        let noAction = UIAlertAction(title: "아니요", style: .default, handler: nil)
        
        

        alert.addTextField { alertTextfield in
            alertTextfield.placeholder = "새로운 할 일"
            textField = alertTextfield
        }
        
        
        
        
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
       //데이터를 인코딩 해서 파일로 저장
         func saveItem() {
             let encoder = PropertyListEncoder()
            
            do {
            let data = try encoder.encode(itemArray)
                try data.write(to: dataFilePath!)
            } catch {
                print("에러 인코딩")
            }
            tableView.reloadData()
           }
        }
  
     //데이터를 디코딩 해서 우리 앱으로 불러오기
      func loadItem() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("에러 디코딩")
            }
        }
    }

}