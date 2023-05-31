# UI 서치바를 이용해서 coredata중 서치바에서 입력한 데이터 찾기
```swift
//MARK: - UI서치바 델리게이트

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        

    }


//https://academy.realm.io/posts/nspredicate-cheatsheet/

extension TodolistViewController: UISearchBarDelegate {
    //검색버튼을 눌렀을때 뭐 할건지를 결정하는 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //coredata에 저장된 항목을 배열로 반환하고.
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //검색창의 글자와 일치하거나 혹은 안에들어있거나 포함하거나 등등을 확인하는 코드.
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //위에 링크 참조
      
        
        //데이터베이스에서 가져온 데이터를 정렬
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //ascending은 오름차순으로할꺼냐는뜻
        
        //그리고 이런 데이터를 모두 만족하는 데이터만 로드될것이다.
       loadItem(with: request)
        
        //그리고 테이블뷰 업데이트
        tableView.reloadData()
    }
}
```
## 원래 데이터로 돌아기기

```swift
//서치바에서 텍스트가 바뀌었을때 트리거되는 델리게이트 메서드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            loadItem()
            tableView.reloadData()
        }
    }

```