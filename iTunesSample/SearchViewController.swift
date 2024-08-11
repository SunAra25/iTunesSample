//
//  SearchViewController.swift
//  iTunesSample
//
//  Created by 아라 on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    private let searchController = UISearchController()
    private let tableView = {
        let view = UITableView()
        view.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        return view
    }()
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        configureView()
        bind()
    }
    
    func bind() {
        let searchBtnTap = searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
        let contentDidSelect = PublishSubject<SearchResult>()
        let input = SearchViewModel.Input(searchBtnTap: searchBtnTap.asObservable(),
                                          contentDidSelect: contentDidSelect)
        let output = viewModel.transform(input: input)
        
        output.appList
            .bind(to: tableView.rx.items(cellIdentifier: ContentTableViewCell.identifier, cellType: ContentTableViewCell.self)) { row, element, cell in
                cell.configureCell(element)
            }.disposed(by: disposeBag)
    }
    
    func setNavigation() {
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
