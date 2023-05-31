# 24시 동물병원 앱

## 배경
강아지를 키우면서 꼭두 새벽이나 밤에 강아지가 아픈경우가 생길때가 있는데. 그때 당황한 상태로 늦은시간에 운영하는 병원을 찾기란 쉽지가 않았습니다. 그래서 앱을통해 내 주변에 24시간 운영중인 병원이 있는지 확인하고 빠르게 병원으로 가 치료를 받을수 있게 도와주는 서비스가 있었으면 좋겠다고 생각했고 이런 생각을 바탕으로 기획부터 데이터설계까지 모든 부분을 구현하여 24시 동물병원 앱을 만들어 보았습니다.


## 구현기능
1. 위치 검색기능: 위치검색기능은 네이버 검색Api를 사용했습니다. 아무래도 5개의 결과 밖의 보여주지않는다는 점은 단점이였지만 네이버맵 api와 연동성이 좋을거라 생각해 사용했습니다   
   
2. 주변 동물병원 위치 기능: 대한민국 사용자가 가장 많이 사용하는 가장 편한 지도가 네이버지도라고 생각되어 네이버맵 api를 이용했습니다.   
   
3. 수정요청, 제보 기능: 파이어베이스가 ios개발자가 가장쉽게 접할수 있는 데이터베이스이기도 하고 병원정보를 담을 Firestore와 사진을 저장한 FireStorage가 제겐 딱 안성맞춤 이였습니다.   
또한 읽기와 쓰기가 몇번 일어났는지에 대한 기록도 쉽게 볼수있어 선택했습니다.
   
4. 즐겨찾기 기능: coreData를 이용해 병원데이터를 저장했습니다. 이전 운동타이머 앱을 만들며 Realm 데이터베이스를 사용해보았기때문에 다 경험을 해보고싶어 coreData를 사용한것도 있고    
이미 많은 라이브러리를 사용중이 었기때문에 애플의 기본 프레임워크인 coreData를 사용해 앱이 커지는것을 조금 방지하기위해 사용했습니다.   
또한 Realm이 성능이나 속도에선 우수하지만 그렇게 복잡한 데이터를 다루는것이 아니기때문에 coreData로 충분해보였습니다.   
    
5. 티맵 내비 연동기능 ,전화 걸기 기능: UIApplication.shared.canOpenURL 을 이용해 다른앱으로 연동시켰습니다.  
네비게이션의 TmapApi를 이용해 Tmap이 설치되어있을 경우 앱을 연동시키고 아닐경우 앱스토어 페이지로 안내하게 구현했습니다.    



## 배운점 및 고민점
1. MVVM 디자인 패턴에대해 고민해 구현해보는 경험을 했습니다.   
    
2. 델리게이트 패턴을 익숙하게 사용할수 있게되었습니다.   
    
3. URLSession을 이용한 네트워킹에서 Result타입을 이용한 에러처리를 배웠습니다.

4. 이미지 캐시처리와 이미지를 비동기적으로 불러오는 방법에 대해 배웠습니다.



## 개발과정



### 위치검색기능

![Simulator Screen Recording - iPhone 13 Pro - 2022-04-22 at 16 50 13](https://user-images.githubusercontent.com/93653997/164642882-f7b2a238-42f7-4bfe-afe1-63faf7a6966f.gif)


원하는 지역을 검색하고 그 위치로 이동한뒤   
그위치 주변의 병원정보를 알기위해 네이버 검색 API를 활용했습니다.   
검색 결과를 테이블뷰로 보여주고 셀을 클릭하면 클릭한 셀의 해당지역 좌표값을 가지고   
네이버맵의 카메라를 이동시킵니다.   
<details>
<summary>코드보기</summary>

네이버 검색 결과를 URL세션을 이용해 JSON형태로 받아와 모델로 만드는 코드  

```swift
static func fetchSearchService(queryValue: String, compltion: @escaping (Result<[SearchModel], Error>) -> Void) {
        DispatchQueue.global(qos: .default).async {
            let clientID = "AZNe9xs00tGIlUvyHPXj"
            let secretID = "XbdL_MZyWc"
            
            let query = "https://openapi.naver.com/v1/search/local.json?query=\(queryValue)&display=10&start=1&sort=random"
            
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {return}
            
            guard let url = URL(string: encodedQuery) else {return}
            
            var requestURL = URLRequest(url: url)
            
            requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
            requestURL.addValue(secretID, forHTTPHeaderField: "X-Naver-Client-Secret")
            
            URLSession.shared.dataTask(with: requestURL) { data, respones, error in
                if error != nil {
                    compltion(.failure(error!))
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let decodeData = try JSONDecoder().decode(SearchModelList.self, from: data)
                    let searhModels = decodeData.items.map {
                        SearchModel(name: $0.title, address: $0.roadAddress, x: $0.mapx, y: $0.mapy)
                    }
                    compltion(.success(searhModels))
                } catch {
                }
            }.resume()
        }
        
    }
}

```

받아온 모델을 통해 뷰에 보여줄 Viewmodel 코드   
데이터를 받기 시작한 시점과 끝난시점을 알기위해    
loddingStart와 lodingEnd 를만들었고    
이로인해 받아오는중의 로딩뷰를 표시했음    
델리게이트 패턴으로 HomeViewController에 lating값을 전달하고   
그 값을 이용해 카메라를 이동시켰음

```swift
final class SearchViewModel {
    
    var models : [SearchModel] = []
    
    var loddingStart: () -> Void = {}
    
    var lodingEnd: () -> Void = {}
    
    func count() -> Int {
        return models.count
    }
    
    func name(index: Int) -> String {
        return models[index].name.components(separatedBy: ["b","/","<",">"]).joined()
    }
    
    func address(index: Int) -> String {
        return models[index].address
    }
    
    func lating(index: Int) -> NMGLatLng {
        guard let xInt = Int(models[index].x) else {return NMGLatLng()}
        guard let yInt = Int(models[index].y) else {return NMGLatLng()}
        let xDouble = Double(xInt)
        let yDouble = Double(yInt)
        let tm = NMGTm128(x: xDouble, y: yDouble)
        let lating = tm.toLatLng()
        return lating
    }
    
    func fetch(searhText: String) {
        loddingStart()
        SearchService.fetchSearchService(queryValue: searhText) { [weak self] result in
             switch result {
             case .success(let models):
                 self?.models = models
                 self?.lodingEnd()
             case .failure(_):
                 self?.lodingEnd()
             }
        }
    }
}





```

델리게이트 패턴

```swift
protocol SearchViewDelegate: AnyObject {
    func locationData(lating: NMGLatLng)
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lating = searchViewModel?.lating(index: indexPath.row) else {return}
        delegate?.locationData(lating: lating)
        navigationController?.popViewController(animated: true)
        
        
    }
```
</details>




   
### 주변 동물병원 위치 기능    
![Simulator Screen Recording - iPhone 13 Pro - 2022-04-22 at 16 29 26](https://user-images.githubusercontent.com/93653997/164627998-dbfbf64c-405d-46d4-a186-9052abed6be2.gif)


동물병원의 위치를 나타낼 지도는 네이버 맵 Api를 활용했습니다.    
네이버맵 API같은경우 여러가지 기능을 제공하는데       
그중 병원의 위치를 알수있는 마커를 활용했습니다.
앱을 켠후 데이터 로딩화면이 표시되고   
데이터 로딩이 완료되면 로딩화면이 사라진후에 받아온 데이터를 반복문을 활용해 마커로 표시합니다.   
그럼 결과적으로 화면에 모든 동물병원의 위치가 마커로 표시됩니다.
<details>
<summary>코드보기</summary>

파이어베이스에서 데이터를 받아와 모델로 만드는 Service 코드

```swift
struct HospitalService {
    static func fetchHospital(compltion: @escaping (Result<[HospitalModel],Error>) -> Void) {
        let db = Firestore.firestore().collection("hospital")
        db.getDocuments() { snapshot, error in
            if let error = error {
                compltion(.failure(error))
                return
            }
            guard let doc = snapshot?.documents else {return}
            let model = doc.map {
                HospitalModel(dic: $0.data())
            }
            compltion(.success(model))
        }
    }
}
```
  
ViewModel 코드   
데이터를 받은게 끝나는 시점을 알기위해 만든 lodingEnd   
이 클로져를 이용해 로딩이 끝난 시점에 뷰를 보여줌   

```swift
final class HospitalViewModel {
    

    var models: [HospitalModel] = []
    
    var lodingEnd: () -> Void = {}
    
    func fetch() {
        HospitalService.fetchHospital { [weak self] result in
            switch result {
            case .success(let model):
                self?.models = model
                self?.lodingEnd()
            case .failure(_):
                self?.lodingEnd()
            }
        }
    }
}

```

이 viewModel을 이용해 반복문을 통해 마커를 생성하는 코드   
viewModel에서 만든 lodingEnd 클료져가 호출되면 아래 함수가 호출됨   

```swift
private func lodingViewOFF() {
        //네이버 공식문서에서 같은 이미지를 쓰는경우 오버레이 이미지를 하나만 생성해서 사용해야한다고 합니다.
        let image = NMFOverlayImage(name: "마커이미지")
        loadingView.removeFromSuperview()
            for models in hospitalViewModel.models {
                DispatchQueue.global(qos: .default).async { [weak self] in
                let marker = NMFMarker()
                marker.iconImage = image
                marker.position = NMGLatLng(lat: models.x, lng: models.y)
                marker.width = 40
                marker.height = 60
                marker.touchHandler = { [weak self] (ovrlay: NMFOverlay) -> Bool in
                    self?.marker.mapView = nil
                    self?.containerView.viewModel = DetailViewModel(model: models)
                    self?.animatePresentContainer()
                    self?.selectCameraZoom()
                    let camUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: models.x, lng: models.y))
                    self?.naverMapView.moveCamera(camUpdate)
                    return true
                }
                DispatchQueue.main.async { [weak self] in
                    marker.mapView = self?.naverMapView
                   }
                }
            }
        }
```
</details>



### 수정요청, 제보기능

![Simulator Screen Recording - iPhone 13 Pro - 2022-04-22 at 17 03 38](https://user-images.githubusercontent.com/93653997/164645152-cef8e7a0-2c26-49fc-ab2a-729c620fc962.gif)


병원의 정보가 잘못되었거나 수정할정보가 있으면 수정사항을 사용자가 요청할수 있는 기능입니다.   
또한 제보를 통해 새로운 병원을 알릴 수 있습니다.     
수정요청이나 제보을 하면 파이어스토어의 항목에 정보가 올라옵니다.   

<img width="779" alt="스크린샷 2022-04-22 오후 5 04 56" src="https://user-images.githubusercontent.com/93653997/164645445-aaefcce1-3dae-4baa-87c7-5142670c9d74.png">

   
<details>
<summary>코드보기</summary>


제보, 수정요청 서비스 코드
```swift
struct EditService {
    static func uploadEditData(type: String, name: String, text: String,compliton: @escaping (Error?) -> Void) {
        let db = Firestore.firestore().collection(type)
        db.document().setData(["병원이름": name,"수정내용" : text]) { error in
            compliton(error)
        }
    }
    
    static func report(name: String, address: String, compltion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore().collection("새로운 병원 제보")
        db.document().setData(["병원이름": name,"위치" : address]) { error in
            compltion(error)
        }
    }
}
```

</details>


### 즐겨찾기 기능

![Simulator Screen Recording - iPhone 13 Pro - 2022-04-22 at 17 15 38](https://user-images.githubusercontent.com/93653997/164647188-ed97da58-db2d-4028-a9ca-371108a50b31.gif)

즐겨찾기 버튼을 누르면 선택한 병원의 주소와 이름 데이터가 coreData에 저장됩니다.   
그리고 어떤 병원의 정보를 클릭했을때 coreData의 데이터를 모두 불러오고   
불러온 데이터와 현재 데이터가 일치하는경우 즐겨찾기버튼이 노란색으로 바뀝니다.   
즐겨찾기 목록 버튼을 누르면 coreData의 데이터를 모두 블러와 테이블뷰로 표시합니다.   

<details>
<summary>코드보기</summary>

코어데이터의 CRD 코드입니다.
```swift
struct CoreDataService {
    
  static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func uploadCoreData(name: String, address: String) {
        let model = Favorite(context: context)
        model.name = name
        model.address = address
        do {
            try context.save()
        } catch {
        }
    }
    
    static func loadCoreData(compltion: @escaping ([Favorite]) -> Void) {
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let model = try context.fetch(request)
            compltion(model)
        } catch {
        }
    }
    
    static func deleteCoreData(model: Favorite) {
        context.delete(model)
        do {
           try context.save()
        } catch {
        }
    }
}

```

즐겨찾기 ViewModel과 현재보고있는 ViewModel을 비교해서 즐겨찾기버튼을 노란색으로 설정하는 코드입니다

```swift
private func fetchFavorite(image: UIImageView) {
         guard let viewModel = viewModel else {return}
        favoriteviewModel.fetch()
        for model in favoriteviewModel.coreDataModels {
            if model.name == viewModel.name {
                currentFavorite = true
                image.tintColor = .yellow
                break
            } else {
                currentFavorite = false
                image.tintColor = .white
            }
        }
     }
```

</details>


### 이미지 불러오기
   
![Simulator Screen Recording - iPhone 13 Pro - 2022-04-22 at 22 41 01](https://user-images.githubusercontent.com/93653997/164726088-1f49c35f-7b84-466d-b2b5-529f5f7cbfa8.gif)


url을 이용해 이미지를 불러오고 반복되는 네트워크통신을 방지하기위해 NSCache 를 이용해 이미지를 캐시에 저장한뒤 캐시에 이미지가 있는지 확인후 없을경우에만 네트워크통신을 하게끔 구현했습니다. 

<details>
<summary>코드보기</summary>

```swift
var imageCache = NSCache<NSString, UIImage>()

struct ImageLoader {
    static func fetchImage(url: String, compliton: @escaping (UIImage) -> Void) {
        
        DispatchQueue.global(qos: .default).async {
            let cachedKey =  NSString(string: url)
            //이미지가 캐시에 있는지 확인
            //캐시에 이미지가 있으면 이미지를 바로 전달
            if let cachedImage = imageCache.object(forKey: cachedKey) {
                compliton(cachedImage)
                return
            }
        
        //없는 경우 url통신 시작
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { data, respones, error in
            if error != nil {
                guard let image = UIImage(named: "이미지가없습니다") else {return}
                compliton(image)
                return
            }
            
            guard let imageData = data else {return}
            
            guard let photoImage = UIImage(data: imageData) else {return}
            
            //그리고 캐시에 넣어줌 그럼 다음부터는 url 통신을 안해도됨
            imageCache.setObject(photoImage, forKey: cachedKey)
            
            
            compliton(photoImage)
        }.resume()
        }
    }
}
```


</details>



## 앱스토어 심사
1. 첫번째 리젝   
처음 앱을 켰을때 위치사용권한요청이 나오는데 그때 일방적으로 "위치를사용합니다" 라고만 표기한것이 첫번째 리젝사유가 되었습니다.. 구체적으로 위치사용을 어디에 사용하는가를 표기해야한다고 했고 "내 주변 24시동물병원의 표시를위해 위치를 사용합니다" 라고 구체적으로 바꿔준뒤 재 심사를 요청했습니다.

후에 심사가 승인되어 츨시했습니다.


