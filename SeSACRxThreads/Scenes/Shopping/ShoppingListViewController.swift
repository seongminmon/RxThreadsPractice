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
    private let tableView = UITableView()
    
    private let viewModel = ShoppingListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let input = ShoppingListViewModel.Input(
            searchText: searchTextField.rx.text.orEmpty,
            addTap: addButton.rx.tap,
            cellSelected: tableView.rx.itemSelected,
            cellDeleted: tableView.rx.itemDeleted
        )
        let output = viewModel.transform(input: input)
        
        output.list
            .bind(to: tableView.rx.items(
                cellIdentifier: ShoppingTableViewCell.id,
                cellType: ShoppingTableViewCell.self
            )) { row, element, cell in
                cell.configureCell(element)
                
                // TODO: - 셀 내부의 버튼 탭 뷰 모델로 전달하기
//                cell.checkButton.rx.tap
//                    .bind(with: self) { owner, _ in
//                        print("완료 버튼 탭")
//                        owner.data[row].isComplete.toggle()
//                        owner.list.accept(owner.data)
//                    }
//                    .disposed(by: cell.disposeBag)
//                
//                cell.starButton.rx.tap
//                    .bind(with: self) { owner, _ in
//                        print("즐겨찾기 버튼 탭")
//                        owner.data[row].isStar.toggle()
//                        owner.list.accept(owner.data)
//                    }
//                    .disposed(by: cell.disposeBag)
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
        
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.id)
        tableView.rowHeight = 60
        
        [searchTextField, addButton, tableView].forEach {
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
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
