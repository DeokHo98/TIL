//
//  textViewController.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/02/03.
//

import UIKit
import RealmSwift


protocol Updatedelegate {
    func update(title: String, memo: String)
}

class textViewController: UIViewController {
    
    private var willshowToken: NSObjectProtocol?
    deinit {
        if let token = willshowToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    private let realm = try! Realm()
    var delegate: Updatedelegate?
    var editTarget: Item?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldSet()
        keyboredUp()
        titleSet()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        view.endEditing(true)
        cancelAlert()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        dismiss(animated: false, completion: update)
        navigationController?.popViewController(animated: true)
    }
}




//MARK: - 텍스트필드 델리게이트
extension textViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textView.becomeFirstResponder()
        return true
    }
}



//MARK: - 뷰관련 메서드
extension textViewController {
    
    //텍스트필드관련 뷰
    func textfieldSet() {
        titleTextField.delegate = self
        titleTextField.placeholder = "Please enter title".localized()
        titleTextField.borderStyle = .none
    }
    
    
    
    //내용이 길어지면 키보드가 그 내용을 가리는 문제 해결
    private func keyboredUp() {
        willshowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] noti in
            guard let strongSelf = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.textView.contentInset
                inset.bottom = height
                strongSelf.textView.contentInset = inset
                
                
                inset = strongSelf.textView.verticalScrollIndicatorInsets
                inset.bottom = height
                strongSelf.textView.verticalScrollIndicatorInsets = inset
                
            }
        })
    }
    
    
    
    
    //취소버튼눌렀을때 얼럿
    private func cancelAlert() {
        let alert = UIAlertController(title: "Are you sure you want to cancel?".localized(), message: "The content is not saved".localized(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "yes".localized(), style: .default) { [self] _ in
            navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "no".localized(), style: .default) { [self] _ in
            titleTextField.becomeFirstResponder()
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    //메모를 작성하거나 수정할때 로직
    private func update() {
        if let editTarget = editTarget {
            let item = realm.objects(Item.self).filter("title = %@", editTarget.title).filter("memo = %@", editTarget.memo).filter("date = %@", editTarget.date!).first!
            try! realm.write {
                if titleTextField.text == "" {
                    item.title = "Untitled".localized()
                } else {
                    item.title = titleTextField.text!
                }
                
                item.memo = textView.text
            }
        } else {
            if titleTextField.text == "Please enter title".localized() || titleTextField.text == "" && textView.text == "" {
                delegate?.update(title: "Untitled".localized(), memo: "no content".localized())
            } else if titleTextField.text == "Please enter title".localized() || titleTextField.text == "" {
                delegate?.update(title: "Untitled".localized(), memo: textView.text)
            } else if textView.text == "" {
                delegate?.update(title: titleTextField.text!, memo: "no content".localized())
            } else {
                delegate?.update(title: titleTextField.text!, memo: textView.text)
            }
        }
    }
    
    
    
    
    //메모를 작성하거나 수정할때 네비게이션 타이틀이 달라지는 로직
    func titleSet() {
        if let memo = editTarget {
            navigationItem.title = "edit".localized()
            titleTextField.textColor = .black
            titleTextField.text = memo.title
            textView.text = memo.memo
        } else {
            navigationItem.title = "new log".localized()
            textView.text = ""
        }
    }
}


