//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BoxOfficeViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let tableView = UITableView()
    
    private let viewModel = BoxOfficeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let input = BoxOfficeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        
    }
    
    private func configureView() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .lightGray
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        
        [searchBar, tableView, collectionView].forEach {
            view.addSubview($0)
        }
        
        navigationItem.titleView = searchBar
        
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}

