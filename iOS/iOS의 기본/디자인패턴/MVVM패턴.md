# MVVM 패턴
M model: 서버 등 에서 받아온 데이터 구조를 정의하고 뷰 모델에 결과를 알려준다.   
V view: 뷰와 뷰컨트롤러 등으로 이벤트 발생시 이벤트를 viewmodel에게 전해주며 viewmodel이 업데이트한 데이터를 화면에 보여준다    
VM viewmodel : 뷰에 나타나는 형태의 데이터 뷰에서 발생한 이벤트에 대응해서 데이터를 업데이트한다.
view와 model사이에는 어떤 교환도 이뤄지지않는다.

# mvvm패턴의 예시

## 1. viewmodel만 있는 예시
텍스트 필드에 텍스트가 있는지 없는지에 따라 버튼을 활성화 비활성화 시키는 예시.

```swift
VIEW MODEL
protocol FormViewModel {
    func unpdateForm()
}

protocol AuthViewModel {
    var formIsVaild: Bool { get }
    var buttonOptionColor: UIColor { get }
    var buttonOptionTextColor: UIColor { get }
}

struct LoginViewModel: AuthViewModel {
    var email: String?
    var password: String?
    
    var formIsVaild: Bool {
        return email?.isEmpty == false && password?.isEmpty == false 
    }
    
    var buttonOptionColor: UIColor {
        return formIsVaild ? UIColor.systemPurple.withAlphaComponent(1) : UIColor.systemPurple.withAlphaComponent(0.2)
    }
    
    var buttonOptionTextColor: UIColor {
        return formIsVaild ? .white : UIColor(white: 1, alpha: 0.2)
    }
}


VIEW

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNotificationObsrvers()
    }

func configureNotificationObsrvers() {
        emailTextField.addTarget(self, action: #selector(textDidchange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidchange), for: .editingChanged)
    }

    @objc func textDidchange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        unpdateForm()
    }


extension LoginViewController: FormViewModel {
    func unpdateForm() {
        loginButton.backgroundColor = viewModel.buttonOptionColor
        loginButton.setTitleColor(viewModel.buttonOptionTextColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsVaild
    }
}

```

