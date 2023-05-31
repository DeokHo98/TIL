//
//  DailyViewController.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/01/28.
//

import UIKit
import RealmSwift

class DailyViewController: UIViewController {
    
    
    var nameOfCategory: String = ""
    
    private let realm = try! Realm()
    
    var selectCategory : WorkoutCategory?
    
    private let formatter = DateFormatter()
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewSet()
        navigationSet()
        addButtonSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    
    
    
   //MARK: - segu로 데이터주고받기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as? MemoViewController {
                vc.memo = selectCategory?.items[indexPath.row]
            }
        }
        if let textVC = segue.destination as? textViewController {
            textVC.delegate = self
        }
        if let memoVC = segue.destination as? MemoViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                memoVC.textTitle = (selectCategory?.items[indexPath.row].title)!
            }
        }
    }
    
    
}





//MARK: - 테이블뷰 데이터 소스 메서드
extension DailyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectCategory?.items.count ?? 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath)
        let target = selectCategory?.items[indexPath.row]
        cell.textLabel?.text = target?.title
        dateFormatter()
        cell.detailTextLabel?.text = formatter.string(from: (target?.date)!)
        return cell
    }
}




//MARK: - 테이블뷰 델리개이트 메서드
extension DailyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteAlert(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete".localized()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}




//MARK: - realm CRUD ex: 델리게이트로 받은 데이터를 이용
extension DailyViewController: Updatedelegate {
    func update(title: String, memo: String) {
        saveItem(title: title, memo: memo)
    }
    
    private func saveItem(title: String, memo: String) {
        try! realm.write {
            let newMemo = Item(title: title, memo: memo)
            selectCategory?.items.append(newMemo)
        }
    }
    
    private func deleteItem(index: Int) {
        if let item = selectCategory?.items[index] {
            try! realm.write{
                realm.delete(item)
            }
        }
        tableView.reloadData()
    }
}



//MARK: - view관련 메서드
extension DailyViewController {
    //삭제 버튼의 얼럿
    private func deleteAlert(_ index: Int) {
        let alert = UIAlertController(title: "Are you sure you want to delete?".localized(), message: "All contents inside will be deleted".localized(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "yes".localized(), style: .default) { _ in
            self.deleteItem(index: index)
        }
        let noAction = UIAlertAction(title: "no".localized(), style: .default, handler: nil)
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
    
    //날짜 출력 조정
    private func dateFormatter() {
        formatter.locale = Locale(identifier: "en_US".localized())
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .full
        formatter.timeStyle = .none
    }
    
    //네비게이션 관련 뷰 조정
    private func navigationSet() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.backButtonTitle = "back".localized()
        navigationItem.title = nameOfCategory
    }
    
    //add버튼 관련 뷰 조정
    private func addButtonSet() {
        addButton.circleButton = true
        addButton.tintColor = .black
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowOffset = CGSize.zero
        addButton.layer.shadowRadius = 5
    }
    
    //tableview 관련
   private func tableviewSet() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset.left = 0
        tableView.reloadData()
    }
    
}
