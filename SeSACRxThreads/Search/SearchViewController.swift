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
    
    let disposeBag = DisposeBag()
    
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    lazy var list = BehaviorRelay(value: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setSearchController()
        bind()
    }
    
    func bind() {
        list
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .systemBlue
                
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            // 과호출 막기
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            // 중복 단어 막기
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                print("실시간 검색: \(value)")
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.list.accept(result)
            }
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .withLatestFrom(searchBar.rx.text.orEmpty) { void, text in
                return text
            }
            .bind(with: self) { owner, value in
                print("추가: \(value)")
                owner.data.insert(value, at: 0)
                owner.list.accept(owner.data)
            }
            .disposed(by: disposeBag)
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
