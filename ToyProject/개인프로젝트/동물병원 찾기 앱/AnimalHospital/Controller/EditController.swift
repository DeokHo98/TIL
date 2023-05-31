//
//  EditController.swift
//  AnimalHospital
//
//  Created by 정덕호 on 2022/04/17.
//

import UIKit



class EditController: UIViewController {
    
    deinit{
        print("메모리해제")
    }
    
    
    var name: String?
    
    var curretText = true
    
    private var segmentedValue: String {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return "병원폐업 정보 수정 요청"
        case 1: return "시간정보 정보 수정 요청"
        case 2: return "위치변경 정보 수정 요청"
        case 3: return "기타 정보 수정 요청"
        default:
            return ""
        }
    }
    
    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["병원폐업","시간변경","위치변경","기타"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .systemBlue
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        return sc
    }()
    
    private let segeLabel: UILabel = {
        let label = UILabel()
        label.text = "수정항목 (필수)"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let textView: UITextView = {
        let tf = UITextView()
        tf.textColor = .lightGray
        tf.backgroundColor = .white
        tf.font = .systemFont(ofSize: 18)
        tf.text = "예시: 병원이 폐업했어요,   병원이 더이상 24시간 운영하지않아요,    병원이 다른곳으로 이사갔어요,    병원전화번호가 달라요 등등"
        return tf
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "수정내용"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "수정요청", style: .plain, target: self, action: #selector(tapRightButton))
        return button
    }()
    
    private let activity = UIActivityIndicatorView()
    
    //MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "뒤로가기"
        
        
        
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = "정보 수정요청"
        
        textView.delegate = self
        
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,paddingTop: 80,paddingLeading: 20,paddingTrailing: 20)
        
        view.addSubview(segeLabel)
        segeLabel.anchor(leading: segmentedControl.leadingAnchor,bottom: segmentedControl.topAnchor, paddingBottom: 15)
        
        view.addSubview(textView)
        textView.anchor(top: segmentedControl.bottomAnchor,leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,paddingTop: 80, paddingLeading: 20, paddingTrailing: 20)
        
        view.addSubview(textLabel)
        textLabel.anchor(leading: textView.leadingAnchor,bottom: textView.topAnchor, paddingBottom: 15)
        
        activity.hidesWhenStopped = true
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.color = .darkGray
        view.addSubview(activity)
        activity.centerX(inView: view)
        activity.centerY(inView: view)
        
        //키보드가 올라오는 시점을 아는 옵저버를 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    //MARK: - 셀렉터메서드
    @objc private func tapRightButton() {
        if let text = textView.text, textView.textColor == .black {
            
            if text != "" {
                fetchAlert(text: text)
            } else {
                showAlert(title: "수정내용을 입력해주세요") { _ in
                }
            }
        } else {
            showAlert(title: "수정내용을 입력해주세요") { _ in
            }
        }
    }
    
    //키보드를 올리면 키보드의 높이를 구해서 키보드 높이만큼의 앵커를 조정하는 메서드
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHieght = keyboardFrame.cgRectValue.height
            textView.anchor(bottom: view.bottomAnchor, paddingBottom: keyboardHieght)
        }
        
    }
    
    
    //MARK: - 도움메서드
    private func showAlert(title: String,compltion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: compltion)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchAlert(text: String) {
        let alert = UIAlertController(title: "수정요청을 하시겠습니까?", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "네", style: .default) { [self] _ in
            activity.startAnimating()
            EditService.uploadEditData(type: segmentedValue, name: self.name!, text: text) { [weak self] error in
                if error != nil {
                    self?.activity.stopAnimating()
                    self?.showAlert(title: "실패했습니다 다시한번 시도해보세요",compltion: { _ in
                    })
                    return
                } else {
                    self?.activity.stopAnimating()
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
    
    
}

//MARK: - 텍스트뷰 델리게이트
extension EditController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if curretText {
            textView.text = nil
            textView.textColor = .black
            curretText = false
        }
        
    }
    
    
    
}
