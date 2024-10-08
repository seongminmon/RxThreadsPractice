//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let viewModel = PasswordViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        let input = PasswordViewModel.Input(
            text: passwordTextField.rx.text.orEmpty,
            nextTap: nextButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.validation
            .bind(with: self) { owner, value in
                owner.nextButton.isEnabled = value
                owner.descriptionLabel.isHidden = value
                owner.nextButton.backgroundColor = value ? Color.green : Color.red
            }
            .disposed(by: disposeBag)
        
        output.nextTap
            .bind(with: self) { owner, _ in
                let vc = PhoneViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = Color.white
        descriptionLabel.text = "8자 이상 입력해주세요"
        descriptionLabel.textColor = Color.red
        
        view.addSubview(passwordTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(passwordTextField)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
