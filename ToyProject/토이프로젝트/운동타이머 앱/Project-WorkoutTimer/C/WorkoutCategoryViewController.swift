
//
//  DailyMemoTableViewController.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/01/28.
//

import UIKit
import RealmSwift





class WorkoutCategoryViewController: UIViewController {

    
    
    private var workoutCategories: Results<WorkoutCategory>?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableviewSet()
        navigationSet()
        addButtonSet()
        
        
    }

   

    
//MARK: - segu로 데이터 주고 받기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popupVC = segue.destination as? PopupViewController {
            popupVC.delegate = self
        } else if let dailyVC = segue.destination as? DailyViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                dailyVC.selectCategory = workoutCategories?[indexPath.row]
                dailyVC.nameOfCategory = workoutCategories?[indexPath.row].name ?? "Untitled".localized()
            }
        }
    }
}



//MARK: - 버튼 둥글게 하는 기능
extension UIButton {
     var circleButton: Bool {
        set {
            if newValue {
                self.layer.cornerRadius = 0.5 * self.bounds.size.width
            } else {
                self.layer.cornerRadius = 0
            }
        } get {
            return false
        }
    }
}





//MARK: - 테이블뷰 데이터 소스 메서드
extension WorkoutCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutCategories?.count ?? 1
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = workoutCategories?[indexPath.row].name ?? "error no Cell"
        return cell
    }
    
    
}




//MARK: - 테이블뷰 델리개이트 메서드
extension WorkoutCategoryViewController: UITableViewDelegate {
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
        return 70
    }
}




//MARK: - realm CRUD ex: 델리게이트로 받은 데이터 활용
extension WorkoutCategoryViewController: SendUpdatedelegate {
    func sendUpdate(_ name: String) {
        saveCategories(name: name)
    }
    
    private func saveCategories(name: String) {
        try! RealmSingleton.shared.realm.write {
            RealmSingleton.shared.realm.add(WorkoutCategory(name: name))
        }
        
        tableView.reloadData()
    }
    
    private func loadCategories() {
        workoutCategories = RealmSingleton.shared.realm.objects(WorkoutCategory.self)
        tableView.reloadData()
    }
    
    private func deleteCategories(index: Int) {
        if let categories = workoutCategories?[index] {
            try! RealmSingleton.shared.realm.write{
                RealmSingleton.shared.realm.delete(categories.items)
                RealmSingleton.shared.realm.delete(categories)
            }
        }
        tableView.reloadData()
    }
}

//MARK: - view관련 메서드
extension WorkoutCategoryViewController {
    //삭제시 얼럿
   private func deleteAlert(_ index: Int) {
        
       let alert = UIAlertController(title: "Are you sure you want to delete?".localized(), message:
                                        "All contents inside will be deleted".localized(), preferredStyle: .alert)
       let yesAction = UIAlertAction(title: "yes".localized(), style: .default) {[self] _ in
            deleteCategories(index: index)
        }
       let noAction = UIAlertAction(title: "no".localized(), style: .default, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //네비게이션 관련 조정
    private func navigationSet() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.backButtonTitle = "back".localized()
    }
    
    
    //테이블뷰 관련 조정
    private func tableviewSet() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset.left = 0
        tableView.reloadData()
    }
    
    //add버튼 관련 조정
    private func addButtonSet() {
        addButton.circleButton = true
        addButton.tintColor = .black
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowOffset = CGSize.zero
        addButton.layer.shadowRadius = 5
    }
    
    
    
    
    
}





