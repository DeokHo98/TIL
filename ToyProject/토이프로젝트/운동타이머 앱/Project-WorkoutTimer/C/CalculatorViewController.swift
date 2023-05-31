//
//  CalculatorViewController.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/02/06.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet var repsLabel: [UILabel]!
    @IBOutlet var rmLabel: [UILabel]!
    
    let rm = OneRM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightTextField.delegate = self
        repsTextField.delegate = self
        ishiddenReps()
        ishiddenRm()
        hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func calculatorButton(_ sender: Any) {
        calculatorRm()
    }





    
    
    private func errorAlert(message: String) {
        let alert = UIAlertController(title: "warning".localized(), message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "check".localized(), style: .default, handler: nil)
    alert.addAction(yesAction)
    present(alert, animated: true, completion: nil)
}

    
    private func calculatorRm() {
        if let weight = weightTextField.text , let reps = repsTextField.text {
            if let doubleWeight = Double(weight), let doubleReps = Double(reps) {
                if doubleWeight > 500 {
                    errorAlert(message: "weight is too heavy".localized())
                } else if doubleReps > 20 {
                    errorAlert(message: "If there are too many reps, it is not accurate".localized())
                } else {
                    let oneRmNum = rm.calculator(weight: doubleWeight, reps: doubleReps)
                    rmLabelOn()
                    swichOneRm(num: oneRmNum)
                }
            } else {
                errorAlert(message: "Please enter a number".localized())
            }
        }
    }
    

   private func swichOneRm(num: Double) {
        for item in 0...11 {
            repsLabel[item].text = String(format: "%.1f", rm.percent(rm: item, num: num))
        }
    }
    
    
    private func ishiddenReps() {
        for item in 0...11 {
            repsLabel[item].text = ""
        }
    }
    
    private func ishiddenRm() {
        for item in 0...11 {
            rmLabel[item].text = ""
        }
    }
    
    private func rmLabelOn() {
        for item in 0...11 {
            rmLabel[item].text = "\(item + 1)RM ="
        }
    }
    


}


//MARK: - 다른뷰를 클릭시 키보드를 끄게하는 기능

extension CalculatorViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalculatorViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}


extension CalculatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == weightTextField {
            repsTextField.becomeFirstResponder()
        } else {
            calculatorRm()
            repsTextField.endEditing(true)
        }
        return true
    }
    
}

