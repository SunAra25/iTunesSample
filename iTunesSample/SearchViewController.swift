//
//  SearchViewController.swift
//  iTunesSample
//
//  Created by 아라 on 8/8/24.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        configureView()
    }
    
    func setNavigation() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "음악, TV, 팟캐스트 등"
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
