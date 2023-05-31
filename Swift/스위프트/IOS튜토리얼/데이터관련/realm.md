# 코어 데이터보다 realme 선호


# realme 라이브러를 설치 = 스위프트 패키지 매니저

# 기본 설정
appdelegate
```swift
import RealmSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



     
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        do {
        let realm = try Realm()
        } catch {
            print("릴림 에러")
        }
        
        
        return true
    }
 ```
 item
 ```swift
import RealmSwift

class Item : Object {
   @objc dynamic var title: String = ""
   @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
```   
category
```swift
import RealmSwift


class Category {
   @objc dynamic var name: String = ""
    
    let items = List<Item>()
    

}
```
# realm 파일 경로 찾기
print(Realm.Configuration.defaultConfiguration.fileURL)


# 데이터 생성하기 C
viewcontroller

```swift

let realem = try! Realm()

    func saveCategory(category: Category) {
        
            try! realem.write{
                realem.add(category)
            }

    }
```

# 데이터 불러오기 R
viewcontroller

```swift
var categoryArray: Results<Category>!

    func loadCategories() {
        
        categoryArray = realem.objects(Category.self)
        
        
//참고로 자동업데이트가 되기때문에 배열에 따로 append 시켜주거나 할필요가없음
        
}
```

# 데이터 업데이트하기 U
```swift
if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("데이터 불러오기 에러")
            }
        }
```


# 데이터 삭제하기 D
```swift
    if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("데이터 불러오기 에러")
            }
        }

```
