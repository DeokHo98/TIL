```swift

페이지컨트롤은 현재 내가 보고있는 페이지가 몇번째인지 알려주는 오프젝트라고 생각하면 된다.
컬렉션뷰와 같이 많이 사용하기때문에
컬렉션뷰로 예를 들어서 설명하겠다


lass PageControlViewController: UIViewController {
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var pages: UIPageControl!
    
    
    
    
    let list = [UIColor.red, UIColor.green, UIColor.blue, UIColor.gray, UIColor.black]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pages.numberOfPages = list.count //현재 페이지를 컬렉션뷰 데이터의 숫자와 맞춘다.
        pages.currentPage = 0 //들어가자마자 현재페이지는 첫번째 페이지로 설정한다.
        
        pages.pageIndicatorTintColor = .red //다른 페이지의 색깔
        pages.currentPageIndicatorTintColor = .black //현재페이지의 색깔
        

    }
    @IBAction func pagesChanged(_ sender: UIPageControl) {
        //페이지컨트롤을 이동하면 컬렉션뷰도 같이 이동하도록 하는 코드
        //대신 한번에 하나씩만 이동이가능한것 페이지컨트롤의 특징이다.
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        listCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension PageControlViewController: UIScrollViewDelegate {
    //이메서드는 컬렉션뷰를 스크롤 하면 반복적으로 출력된다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //컬렉션뷰의 페이지를 이동하면 페이지컨트롤도 이동하도록 만드는 코드
        let width = scrollView.bounds.size.width
        let x = scrollView.contentOffset.x + (width / 2.0)
        
        let newpages = Int(x / width)
        if pages.currentPage != newpages {
            pages.currentPage = newpages
        }
    }
}


extension PageControlViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = list[indexPath.item]
        return cell
    }
}


extension PageControlViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}


```