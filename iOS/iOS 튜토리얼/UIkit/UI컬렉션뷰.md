# 컬렉션뷰 기본 구현
```swift

//기본적으로는 테이블뷰와 거의 같다

let color: [UIColor] = [.blue,.red,.gray,.blue,.red,.gray,.blue,.red,.gray,.blue,.red,.gray,.blue,.red,.gray,.blue,.red,.gray,.blue,.red,.gray,.blue,.red,.gray,.blue,.red,.gray,.blue,.red,.gray,.blue,.red,.gray]
    
extension ColorListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return color.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ㅅ"cell", for: indexPath)
        cell.contentView.backgroundColor = color[indexPath.row]
        return cell
    }
    
    
}

```

# 컬렉션뷰 Flow 레이아웃
대상마다 개별적인 속성을 적용하는것도 가능   
스크롤방향이 수직일땐 셀을 수평으로 배치   
스크롤방향이 수평일때는 셀을 수직으로 배치함   
셀크기는 itemSize 속성으로 조절할수있고 50 x 50이 기본   
셀 사이 여백은 고정된값이 아닌 최솟값으로 설정 이값은 minimuminteritemspacing으로 조절    
여백은 항상 셀의 너비에 따라 달라질수있지만 최솟값은 보장함   
라인사이의 여백도 똑같다 ( 위아래 여백 ) minimumlinespacing으로 조절    
셀여백과 라인여백은 기본적으로 10포인트로 설정되어있고 스크롤방향에따라 여백판단 방향이 다르다.   
수직일땐 셀 여백이 왼쪽 또는 오른쪽과의 거리 라인은 위쪽 아래쪽 거리    
스크롤방향이 수평일때는 두여백이 반대가됨   
섹션 여백은 sectioninset 속성으로 조절하고 상하 좌우 여백을 설정할수 있음 이건 고정된값임 최솟값 xxxx    
스크롤 방향에 관한 속성은 scrollDirection 속성으로 변경할수 있다.   
```swift
기본적인 레이아웃
    @objc func toggleScrollDirection() {
        //애니메이션 효과로 전환하기 애니메이션 효과를 원하지않으면 그냥 perfombatchUpdates를 지우면됨
        if let layout = listCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            listCollectionView.performBatchUpdates({
                if layout.scrollDirection == .vertical {
                    layout.scrollDirection = .horizontal
                } else {
                    layout.scrollDirection = .vertical
                }
            }, completion: nil)
        }
        
   
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = listCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.minimumInteritemSpacing = 20
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
        }

```


# 실제로 어떻게 쓰는가에 대한 예시

```SWIFT
class HomeViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    
    let systemImageNameArray = [
           "star", "star", "star", "star", "star", "star", "star", "star"
       ]
    let systemImageNameArray2 = [
     "zzz","zzz","zzz","zzz","zzz","zzz","zzz","zzz"
    ]
    
    let systemArtist = [
        "AAAA","BBBB","CCCC","DDDD","EEEE","FFFF","GGGG","HHHH"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLayout()
    }
}

extension HomeViewController {
    //레이아웃은 어떻게 할지
    func myLayout() {
        if let layout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {

            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            //헤더 레이아웃 바꾸는 코드
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 100)
            layout.sectionHeadersPinToVisibleBounds = true //이건 헤더를 계속 고정시키고싶을때 사용
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    //컬렉션뷰를 몇개 표현할지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return systemImageNameArray.count
    }
    
    // 셀을 구성하고 어떻게 표시 할지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackCollecionViewCell else { return UICollectionViewCell() }
        if indexPath.section == 0 {
            cell.trackThumbnail.image = UIImage(systemName: systemImageNameArray[indexPath.row])
            cell.trackTitle.text = systemImageNameArray[indexPath.row]
            cell.trackArtist.text = systemArtist[indexPath.row]
        } else {
            cell.trackThumbnail.image = UIImage(systemName: systemImageNameArray2[indexPath.row])
            cell.trackTitle.text = systemImageNameArray[indexPath.row]
            cell.trackArtist.text = systemArtist[indexPath.row]
        }
        return cell
    }
    
    
    //헤더를 어떻게 표시할지
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CollectionReusableView
        if indexPath.section == 0 {
            header.label.text = "별모음집"
        } else {
            header.label.text = "zzz 모음집"
        }
        return header
    }
    
    
    
    

}

extension HomeViewController: UICollectionViewDelegate {
    // 클릭했을때 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("셀 클릭됨 \(indexPath.row)")
    }
}



extension HomeViewController: UICollectionViewDelegateFlowLayout {
    //셀의 크기를 각각 바꾸고싶다면
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (myCollectionView.bounds.width - 20 - 20 * 2) / 2
        if indexPath.section == 0 {
        if indexPath.row == 0 {
            return CGSize(width: width * 2, height: width + 60 * 2)
        } else {
            return CGSize(width: width, height: width + 60)
        }
        }
        return CGSize(width: width, height: width + 60)
    }
    
}

```