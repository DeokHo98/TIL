//
//  Popup.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/01/29.
//

import UIKit

protocol SendUpdatedelegate {
    func sendUpdate(_ name: String)
}

class PopupViewController: UIViewController{
 
    var delegate: SendUpdatedelegate?
  
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var textField: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.placeholder = "Please enter".localized()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    

    @IBAction func yesButton(_ sender: Any) {
        dismiss(animated: false, completion: updateWorkout)
        }
       
    @IBAction func noButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    

    
    
    
//MARK: - 델리게이트로 데이터 주고 받기
    
    private func updateWorkout() {
        if textField.text == "" {
            delegate?.sendUpdate("no name".localized())
        } else {
            delegate?.sendUpdate(textField.text!)
        }
    }
  
    
    
}


    

//MARK: - 키보드가 화면을 가리지않게하기

extension PopupViewController {
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -(customView.frame.height / 2)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
      }
}



//MARK: - 텍스트필드 델리게이트 메서드
extension PopupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismiss(animated: false, completion: updateWorkout)
        return true
    }
    
}


    
    

