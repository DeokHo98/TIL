# coreData 를 사욜하기위한 준비
appdelegate
```swift
import CoreData

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "coredata 파일 이름")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}




```

# coreData 데이터를 저장하기 (C)
viewcontroller
```swift
import CoreData

   var itemArray = [Item]()

   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext



    @IBAction func addButtenPressed(_ sender: Any) {
        
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "새로운 할 일을 만드시겠습니까?", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .default) { [self] action in
            
          
            //이부분 써주고
            let newItem = Item(context: self.context)

            //기본적으로 coredata에 데이터들을 옵셔널체크를 안했기때문에 꼭 초기값을 넣어줘야한다
            newItem.title = textField.text!
            newItem.done = false


            if textField.text == "" {
                newItem.title = "새로운 할 일"
                itemArray.append(newItem)
            } else {
                newItem.title = textField.text!
                itemArray.append(newItem)
            }
   
            saveItem()
            
            tableView.reloadData()
        }


    func saveItem() {
           do {
              try self.context.save()
               
           } catch {
              print("데이터 세이브 에러")
           }
    }

```


# coredata 데이터 자져오기 (U)
viewcontroller

```swift

override func viewDidLoad() {
        super.viewDidLoad()
    

        loadItem()
        
    }

    func loadItem() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("데이터 로드 에러")
        }
        
        
    }

```


# coredata 데이터 업데이트 (U)



# coredata 데이터 삭제하기 (D)
viecontroller

```swift

테이블뷰에서 셀을 클릭했을떄 작동하는 함수 
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        context.delete(itemArray[indexPath.row]) //먼저 coredata에서 삭제한뒤에
        itemArray.remove(at: indexPath.row) //배열에서 삭제를 해줘야 에러가 나지 않는다.
        //여기서는 다른 조건문을 사용하지 않고 그냥 셀을 클릭하면 삭제가되는것을 예시로 들었다.
        
        saveItem()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

```

# coredata 사용 주의점
항상 context.save는 깃에서의 커밋같은 기능이라고 생각해야된다.    
contxt.save를 해줘야 삭제던 업데이트던 저장이되는것...

