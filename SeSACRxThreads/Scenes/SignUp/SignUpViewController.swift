//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SignUpViewController: UIViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configure()
        
        // email 조건 검사에 따라 버튼 활성화, 색 변경, 중복확인 버튼 isHidden 처리
        emailTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
            .bind(with: self) { owner, flag in
                if flag {
                    owner.nextButton.isEnabled = true
                    owner.nextButton.backgroundColor = Color.green
                    owner.validationButton.isHidden = false
                } else {
                    owner.nextButton.isEnabled = false
                    owner.nextButton.backgroundColor = Color.red
                    owner.validationButton.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        // 중복 확인 버튼
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "중복이 아닙니다.", completionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        // Password 화면으로 이동
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = PasswordViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = Color.white
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
