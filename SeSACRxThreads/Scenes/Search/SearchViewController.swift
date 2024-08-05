//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let searchBar = UISearchBar()
    
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setSearchController()
        bind()
    }
    
    func bind() {
        let input = SearchViewModel.Input(
            searchText: searchBar.rx.text.orEmpty,
            barButtonTap: navigationItem.rightBarButtonItem?.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.list
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchTableViewCell.identifier,
                cellType: SearchTableViewCell.self)
            ) { (row, element, cell) in
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .systemBlue
                cell.downloadButton.rx.tap
                    .bind(with: self) { owner, _ in
                        print("셀 버튼 탭: \(row)")
                        let vc = DetailViewController()
                        vc.naviTitle = element
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        let plusButton = UIBarButtonItem(title: "추가")
        navigationItem.rightBarButtonItem = plusButton
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
