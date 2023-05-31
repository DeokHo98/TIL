# 파이어베이스 기본 세팅

일단 Xcode => File => addPackAges => 파이어베이스깃허브 주소 => 원하는서비스 클릭   



# AppDelegate   

```swift
import Firebase //AppDelegate에 요거추가하기
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure() //요것도 추가하자
        return true
    }
```


# 전역변수 선언시 문자열 오타의 위험성이 크게 줄어든다.
```swift
//인스턴스 생성없이 바로 접근하기 위해서 이렇게 만드는거야~
struct Constants {
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "registerToGo"
    static let loginSegue = "loginToGo"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
```


# 사용저 정보(이메일 패스워드 생성하기)
```swift
import UIKit
import Firebase
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let password = passwordTextfield.text, let email = emailTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    print("에러다아아아아아아아아아아==========================")
                    return
                } else {
                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
                
                
            }
        }
    }
    
}
```


# 로그인 하기

```swift

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    print("에러다==================")
                    return
                } else {
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
            }
        }
        
    }
}

```

# 로그아웃 하기

```swift

import UIKit
import Firebase


class ChatViewController: UIViewController {

    @IBAction func logOutPrseed(_ sender: UIBarButtonItem) {
     do {
         try Auth.auth().signOut()
         navigationController?.popToRootViewController(animated: true) //처음화면으로 돌아가는 코드
     } catch let signOutError as NSError {
       print("Error signing out: %@", signOutError)
     }
    }
}
```


# 파이어베이스 파이어스토어를 이용해 메시지 데이터를 저장하기

## appdelgate
```swift

class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        

        //파이어스토어 초기화
        let db = Firestore.firestore()

        return true
    }
```



## viewcontroller
```swift

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore() //파이어베이스 초기화
    
    var messagesArray: [MessageStruct] = [
    ]

    
    @IBAction func sendPressed(_ sender: UIButton) {
        if messageTextfield.text != "" {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email { //만약 텍스트필드에 글자를 쓰고, email이 등록되어있는 정보면?
            db.collection("messages").addDocument(data: ["sender":  messageSender,"body": messageBody, "date": Date().timeIntervalSince1970]) { error in //"messages" 라는이름의 딕셔너리형태로된 보낸사람, 채팅내용, 시간대(정렬에 쓰려고) 를 저정하겠다.
                if error != nil {
                    print("파이어스토어 에러났다~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                } else {
                    print("파이어스토어 성공")
                }
            }
        }
        messageTextfield.text = ""
    }
}
```


# 파이버베이스 파이어스토어를 이용해 메시지 데이터를 불러오기

## viewcontroller
```swift
class ChatViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messagesArray: [MessageStruct] = [

    ]
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = Constants.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages() //데이터 불러오는 함수
    }
    
    
    
    func loadMessages() {
        
        
        
        db.collection("messages")
            .order(by: "date") //여기서 .order "date"의 값을 오름차순으로 정렬하는 키워드이다.
            .addSnapshotListener { [self] querySnampshot, error in //.addSnapshotListener는 데이터를 계속업데이트하는것 .getDocuments는 데이터한번받아오기
            
            messagesArray = [] //이걸 해주지않으면 계속 중첩돼서 메시지가 불러와짐
            
            if error != nil {
                print("데이터블러오기 에러났다~~~~~~~~~~~~")
            } else {
                print("데이터불러오기 성공")
                if let snapshotDocments = querySnampshot?.documents { //에러가 아니라면 데이터를 받아오고
                    for i in snapshotDocments { //그데이터들을 하나하나 뽑아서
                        let data = i.data() //다시 data 에 넣고
                        if let sender = data["sender"] as? String, let messagerBody = data["body"] as? String { //만약 data에 딕셔너리 "sender","body" 가있으면?
                            let newMessage = MessageStruct(sender: sender, body: messagerBody) //newMessage 에다 MessageStruct 생성자의 파라미터로 sender와 messagerBody를 넣는다.
                            messagesArray.append(newMessage) //그리고 messagersArray에 담는다
                            
                            DispatchQueue.main.async {
                                tableView.reloadData() //테이블뷰 불러오기
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
```
    
    
    
    