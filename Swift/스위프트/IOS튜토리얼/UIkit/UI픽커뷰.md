```swift
픽커뷰는 슬롯머신 형태로 ui를 가지고 있고 휠을 돌려서 값을 설정한다.
데이트 픽커와 픽커뷰 두가지가 있다.
다양한 데이터를 포현할수 있다는 장점이 있다.
데이트 피커는 원하는 모드를 선택하기만하면 UI와 데이터는 자동으로 지원된다.
픽커에서 항목을 선택하면 valueChange 이벤트가 전달된다.
반면 피커뷰는 표시할데이털르 직접 구성하고 경우에따라 표시할 뷰 역시 직접 구성해야한다.
그리고 선택 이벤트는 델리게이트 패턴으로 처리한다.

픽커뷰 먼저 알아보자

픽커뷰에서의 핵심은 UIPickerViewDataSource 와 델리게이트이다.
픽커뷰 데이터 소스에는 필수메서드 두개가있는데
numberofcomponents 는 픽커뷰의 표시할 컴포넌트의 수를 리턴하고
numberOfRowsinComponent는 특정 컴포넌트에서 표실 데이터의 수를 리턴한다

픽커뷰는 데이터를 표시하는 메서드는 픽커뷰 델리게이트에서 구현 하면 된다.

예시 

class TextPickerViewController: UIViewController {
    let devTools = ["Xcode", "Postman", "SourceTree", "Zeplin", "Android Studio", "SublimeText"]
    let fruits = ["Apple", "Orange", "Banana", "Kiwi", "Watermelon", "Peach", "Strawberry"]
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //만약 버튼 같은걸로 내가 원할때 선택한 문자열이 무엇인지 알려면
    @IBAction func button(_ sender: UIButton) {
        let firstRow = picker.selectedRow(inComponent: 0)
        let secondRow = picker.selectedRow(inComponent: 1)
        
        print(devTools[firstRow])
        print(fruits[secondRow])
        
    }
}

extension TextPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { //픽커뷰에 표시할 컴포넌트의 숫자
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //특정 컴포넌트에서 표시될 데이터의 숫자
        switch component {
        case 0:
            return devTools.count
        case 1:
            return fruits.count
        default:
            return 0
        }
    }
    
    
}

extension TextPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { //문자열을 표시하고 싶을때 쓰는 메서드
        switch component {
        case 0:
            return devTools[row]
        case 1:
            return fruits[row]
        default:
            return "0"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            return print(devTools[row])
        case 1:
            return print(fruits[row])
        default:
            return
        }
    }
    

}



픽커뷰로 슬롯머신 만들기 예시


class ImagePickerViewController: UIViewController {
    
    lazy var images: [UIImage] = {
        return (0...6).compactMap { UIImage(named: "slot-machine-\($0)") }
    }()
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBAction func shuffle(_ sender: Any?) {
        let first = Int.random(in: 0..<images.count + images.count)
        let second = Int.random(in: 0..<images.count + images.count)
        let third = Int.random(in: 0..<images.count + images.count)
        
        //픽커뷰에서 특정항목을 선택하고 싶다면 아래 메서드를 사용한다 select"ed" 가 아니다
        picker.selectRow(first, inComponent: 0, animated: true)
        picker.selectRow(second, inComponent: 1, animated: true)
        picker.selectRow(third, inComponent: 2, animated: true)
        
        //이미지 3개가 일치했을때 코드
        if picker.selectedRow(inComponent: 0) == picker.selectedRow(inComponent: 1) && picker.selectedRow(inComponent: 1) == picker.selectedRow(inComponent: 2) {
            print("당첨")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.isUserInteractionEnabled = false //사용자가 픽커뷰의 터치이벤트를 발동시키지 못하게하는 코드
        
        
        picker.reloadAllComponents() //섞이기 전에 픽커뷰의 데이터가 모두 구성되지않을수도 있기때문에 모든 컴포넌트를 리로드 하는 코드를 추가함
        shuffle(nil) //화면이 구성될때 이미 섞이게끔 하려고
    }
}

extension ImagePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count
    }
    
    
}

extension ImagePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let imageview = view as? UIImageView { //픽커뷰에 뷰를 나타낼때는 재사용을 하게되는데 그 재사용뷰가 이미지인지를 먼저 확인하고 맞다면 이미지를 설정해서 리턴한다.
            imageview.image = images[row % images.count]
            return imageview
        } else { //재사용 뷰가 이미지가 아니라면 이미지뷰를 하나 새로 만들어서 설정해준다.
        let imageView = UIImageView()
        imageView.image = images[row % images.count]
        imageView.contentMode = .scaleAspectFit
        return imageView
        }
    }
    
}


