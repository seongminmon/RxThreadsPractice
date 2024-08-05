//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let viewModel = NicknameViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        let input = NicknameViewModel.Input(
            text: nicknameTextField.rx.text.orEmpty, 
            tap: nextButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.validation
            .bind(with: self) { owner, value in
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = value ? Color.green : Color.red
                owner.descriptionLabel.textColor = value ? Color.green : Color.red
            }
            .disposed(by: disposeBag)
        
        output.description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.tap
            .bind(with: self) { owner, _ in
                let vc = BirthdayViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = Color.white
        
        view.addSubview(nicknameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(nicknameTextField)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
