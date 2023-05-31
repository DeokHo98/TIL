//
//  ReportViewController.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/21.
//

import UIKit

class ReportViewController: UIViewController {
    
    private let label: UILabel = UILabel().reportLabel(text: "이 앱에 등록되어 있지 않은 24시 동물병원의 정보를 모두에게 알려주세요!", font: .systemFont(ofSize: 18))
    
    private let nameTextField = UITextField().reportTextField(title: "  예) 한별이네 24시동물병원")
    
    private let nameLabel: UILabel = UILabel().reportLabel(text: "병원이름",font: .boldSystemFont(ofSize: 18))
    
    private let addressTextField = UITextField().reportTextField(title: "  예) 서울시 강남구")
    
    private let adressLabel: UILabel = UILabel().reportLabel(text: "병원위치",font: .boldSystemFont(ofSize: 18))
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("제보하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setHeight(50)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return button
    }()
    
    private let activity = UIActivityIndicatorView()
    
    
    @objc private func tapButton() {
        if nameTextField.text == "" || addressTextField.text == "" {
            showAlert(title: "모두 입력해주시길 바랍니다") { _ in
            }
        } else {
            fetchAlert()
        }
    }
    
    private func showAlert(title: String, compltion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: compltion)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchAlert() {
        let alert = UIAlertController(title: "새로운 병원을 제보하시겠습니까?", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "네", style: .default) { [self] _ in
            activity.startAnimating()
            EditService.report(name: nameTextField.text!, address: addressTextField.text!) { [weak self] error in
                if error != nil {
                    activity.stopAnimating()
                    self?.showAlert(title: "실패했습니다 다시한번 시도해보세요",compltion: { _ in
                    })
                    return
                } else {
                    activity.stopAnimating()
                    self?.showAlert(title: "정보를 제공해주셔서 감사합니다",compltion: { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        let noButton = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "뒤로가기"
        
        
        view.addSubview(label)
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor,leading: view.leadingAnchor,trailing: view.trailingAnchor,paddingTop: 20, paddingLeading: 20,paddingTrailing: 20)
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top:label.bottomAnchor, leading: view.leadingAnchor, paddingTop: 40, paddingLeading: 20,width: 80)
        
        view.addSubview(nameTextField)
        nameTextField.anchor(leading: nameLabel.trailingAnchor,trailing: view.trailingAnchor, paddingTrailing: 20)
        nameTextField.centerY(inView: nameLabel)
        
        view.addSubview(adressLabel)
        adressLabel.anchor(top:nameLabel.bottomAnchor, leading: view.leadingAnchor, paddingTop: 40, paddingLeading: 20,width: 80)
        
        view.addSubview(addressTextField)
        addressTextField.anchor(leading: adressLabel.trailingAnchor,trailing: view.trailingAnchor, paddingTrailing: 20)
        addressTextField.centerY(inView: adressLabel)
        
        view.addSubview(button)
        button.anchor(top: addressTextField.bottomAnchor, leading: view.leadingAnchor,trailing: view.trailingAnchor, paddingTop: 40, paddingLeading: 20,paddingTrailing: 20)
        
        activity.hidesWhenStopped = true
        activity.color = .darkGray
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        view.addSubview(activity)
        activity.centerX(inView: view)
        activity.centerY(inView: view)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
