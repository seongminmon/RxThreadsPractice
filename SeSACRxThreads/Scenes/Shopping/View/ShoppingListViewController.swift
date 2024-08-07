//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ShoppingListViewController: UIViewController {
    
    private let searchTextField = UITextField()
    private let addButton = UIButton()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let tableView = UITableView()
    
    static func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private let viewModel = ShoppingListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let cellCheckTap = PublishRelay<Int>()
        let cellStarTap = PublishRelay<Int>()
        
        let input = ShoppingListViewModel.Input(
            searchText: searchTextField.rx.text.orEmpty,
            addTap: addButton.rx.tap, collectionViewCellSelected: collectionView.rx.modelSelected(String.self),
            tableViewCellSelected: tableView.rx.itemSelected,
            tableViewCellDeleted: tableView.rx.itemDeleted,
            tableViewCellCheckTap: cellCheckTap.asObservable(),
            tableViewCellStarTap: cellStarTap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 컬렉션뷰
        output.recommendList
            .bind(to: collectionView.rx.items(
                cellIdentifier: ShoppingCollectionViewCell.id,
                cellType: ShoppingCollectionViewCell.self
            )) { row, element, cell in
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)
        
        // 테이블뷰
        output.list
            .bind(to: tableView.rx.items(
                cellIdentifier: ShoppingTableViewCell.id,
                cellType: ShoppingTableViewCell.self
            )) { row, element, cell in
                cell.configureCell(element)
                
                cell.checkButton.rx.tap
                    .map { row }
                    .bind(to: cellCheckTap)
                    .disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .map { row }
                    .bind(to: cellStarTap)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // 셀 선택 시 화면 전환
        output.cellSelected
            .bind(with: self) { owner, value in
                let vc = ShoppingDetailViewController()
                vc.naviTitle = value
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        navigationItem.title = "쇼핑"
        
        view.backgroundColor = Color.white
        
        searchTextField.placeholder = "무엇을 구매하실 건가요?"
        searchTextField.backgroundColor = .systemGray6
        searchTextField.borderStyle = .roundedRect
        
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .systemGray5
        addButton.layer.cornerRadius = 10
        
        collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.id)
        tableView.rowHeight = 60
        
        [searchTextField, addButton, collectionView, tableView].forEach {
            view.addSubview($0)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextField)
            make.trailing.equalTo(searchTextField).inset(8)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
