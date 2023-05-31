//
//  File.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/25.
//

import Foundation
import UIKit
import MapKit


protocol AddLocationContrllerDelegate: AnyObject {
    func updateLocation(locationString: String, type: locationType)
}


class AddLocationController: UITableViewController {
    //MARK: - 속성
    
    weak var delegate: AddLocationContrllerDelegate?
    
    
    private let searchBar = UISearchBar()
    private let searchComplete = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private let type: locationType
    private let location: CLLocation
    //MARK: - 라이프사이클
    
    init(type: locationType, location: CLLocation) {
        self.type = type
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        confiureSearchComplater()
        

    }
    //MARK: - 도움 메서드
    func configureTableView() {

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "addcell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        
        tableView.addShadow()
        
    }
    
    func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func confiureSearchComplater() {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        searchComplete.region = region
        searchComplete.delegate = self
    }
}

//MARK: - 테이블뷰
extension AddLocationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "addcell")
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        let title = result.title
        let subtitle = result.subtitle
        let locationString = subtitle + " " + title
        
        
        delegate?.updateLocation(locationString: locationString, type: type)
    }
}

//MARK: - 서치바
extension AddLocationController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchComplete.queryFragment = searchText
        
    }
}


//MARK: - 맵lt

extension AddLocationController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        
        
        tableView.reloadData()
    }
}

