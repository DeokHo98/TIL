```swift

import UIKit

//UITextFieldDelegate 프로토콜 채택하기
//UITextFieldDelegate는 쉽게말해 textfield에서 무슨일이 일어날때마다 말해주는 역할을한다 
//어이 뷰컨 사용자가 뭔가 입력하는데?
//어이 뷰컨 사용자가 뭔가 다른걸 탭하려는데?
//어이 뷰컨 사용자가 내가 이제 필요없다는데?
class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self
        //textfield 대리자한테 알림을 받을 녀석을 누구로할래? self 지금 이 뷰컨트롤러


    }

    @IBAction func searchPressed(_ sender: UIButton) {
                searchTextField.endEditing(true)
        //키보드 입력을 완료 했을때 키보드를 화면에서 내려가게 하기
    }

        //사용자가 리턴키를눌렀을때 이벤트 발생 함수 (텍스트 필드 는 반환 해야 합니다)
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         searchTextField.endEditing(true) 
         return true
        //델리게이트는 이봐 뷰컨 사용자가 키보드에서 리턴키를눌렀어 라고 말한다.
        //그럼 델리게이트는 textFieldShouldReturn함수를 실행한다.
        
        //공식문서
        //텍스트 필드는 사용자가 리턴 버튼을 누를 때마다 이 메소드를 호출합니다. 이 메서드를 사용하여 버튼을 누를 때 사용자 지정 동작을 구현할 수 있습니다



    //사용자가 아무것도 입력하지않았을때의 이벤트를 발생시키기 (텍스트 필드 는 편집을 종료 해야 합니다)
    //쉽게말해서 true면 textField 편집을 끝내겠다. 그래서 textFieldDidEndEditing 함수도 실행되고, 
    //false면 textField 편집을 끝내지 않겠따. 그래서 textFieldDidEndEditing 함수가 실행되지않는다,

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "똑바로 입력 해주세요"
            return false
        }
       //사용자가 텍스트필드를 선택해제하려는데 그 trexfield.text가 nil이 아닐경우에 return true
        //nil인경우에 return false

       //텍스트 필드는 첫 번째 응답자 상태를 사임하라는 요청을 받을 때 = 쉽게얘기해 여기서는 키보드가 끝니가전에!!
    }
         
    }

        //사용자가 편집을 완료했을때 이벤트 발생시키기 (텍스트 필드 가 편집을 종료했습니다)
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
        //델리게이트는 이봐 뷰컨 사용자가 편집을 완료했어 라고 말한다.
        //리턴이나 검색키를 눌러서 searchTextField.endEditing(true) 함수가 실행되고나면
        //이 함수가 실행되는것이다.


        //텍스트 필드는 첫 번째 응답자 상태를 사힘하라는 효청을 받고 난 뒤 = 쉽게 말해 여기서는 키보드가 끝나고난 뒤!
    }
    
}

```

# 텍스트필드 border style   
   
None , Line, Bezel, Rounded Rect 4가지가 있다 기본설정은 Rounded Rect   
   
# 백그라운드 이미지   
백그라운드 이미지는 보더 스타일의 영향을 받는다, rounded Rect로 하면 이미지를 표시하지 않는다     
disabled 이미지는 비활성화 상태에서의 이미지를 표시한다.     
    
# 텍스트필드 오른쪽의 삭제버튼을 넣는법    
clear Button 을 활성화 시켜주고 스타일을 정해주면 됨      
clear 버튼에서 clear when deting begines 옵션을 true로 하면 편집을시작할때 전에 입력되어있던 모든 텍스트가 삭제된다.      
       
# 오버레이 뷰     
텍스트 필드 왼쪽이나 오른쪽에 버튼같은걸 오버레이뷰로 추가할수 있다.       
       
textfield.leftView = button     
textfiedl.leftViewMode = .always     
   
      
   
# 키보드 입력에 관한 설정 text input traits
1. capitalization 옵션: 대문자 처리 방식을 처리 words를 선택하면 첫번째 어절의 첫문자를 대문자로 바꿔줌 문장마다 바꿔준다 생각    
sentences도 words 랑 비슷하다 이건 문장의 첫문자만 바꺼준다 all charactors 를 선택하면 모든글자를 대분자로 바꿔줌   
    
2. correction 옵션: 자동완성기능 no yes 두가지가 있다. 사용하지않는다면 명시적으로 no로 설정 아나리면 그냥 디폴트로 둔다   
    
3. Spell Checking 옵션: 맞춤법에 어긋나는 부분이 있으면 밑에 빨간줄로 나타내주는 옵션  
   
4. secure text entry 옵션: true면 비밀번호같은걸 입력할때 글자를 숨겨서 보여줄수 있다. 보안 수준이 올라감    
     
5. smart Dashes, smart insert, smart quotes 같은 사용자가 입력할때 자동으로 뭔가를 해주는기능 이건 필요할대마다 찾아서 보자   
    
     
    
# 다양한 키보드 타입
keyboard Type 속성에는 여러가지 옵션이있다. 기본은 default    
keyboard Look 이건 키보드의 색을 조정할수있는 옵션이다.   
