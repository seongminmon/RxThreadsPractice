//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PhoneViewController: UIViewController {
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let viewModel = PhoneViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        let input = PhoneViewModel.Input(
            text: phoneTextField.rx.text.orEmpty,
            tap: nextButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, value in
                owner.nextButton.backgroundColor = value ? Color.green : Color.red
            }
            .disposed(by: disposeBag)
        
        output.tap
            .bind(with: self) { owner, _ in
                let vc = NicknameViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = Color.white
        phoneTextField.text = "010"
        
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
