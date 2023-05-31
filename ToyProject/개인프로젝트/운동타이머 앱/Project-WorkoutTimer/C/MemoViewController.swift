//
//  MemoViewController.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/02/04.
//

import UIKit
class MemoViewController: UIViewController {
    
    var memo: Item?
    var textTitle: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSet()
        navigationItem.title = textTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    //공유버튼
    @IBAction func shareButton(_ sender: Any) {
        guard let memo = memo?.memo else { return }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }



//MARK: -  segu로 데이터 받기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? textViewController {
            vc.editTarget = memo
        }
    }
}

//MARK: - 테이블뷰 데이터소스
extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)
        navigationItem.title = memo?.title
        cell.textLabel?.text = memo?.memo
        return cell
    }
    
    
}

//MARK: - view관련 메서드
extension MemoViewController {
    
    func tableViewSet() {
        tableView.dataSource = self
        tableView.separatorInset.left = 0
    }
}
