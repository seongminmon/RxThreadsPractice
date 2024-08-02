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
    
    let disposeBag = DisposeBag()
    
    let descriptionText = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        nicknameTextField.rx.text.orEmpty
            .bind(with: self) { owner, value in
                do {
                    _ = try owner.checkNickname(value)
                    owner.descriptionLabel.textColor = Color.green
                    owner.descriptionText.onNext("사용 가능한 닉네임이에요")
                    owner.nextButton.isEnabled = true
                    owner.nextButton.backgroundColor = Color.green
                } catch {
                    guard let error = error as? NicknameValidationError else {
                        owner.descriptionText.onNext("알 수 없는 에러가 발생했습니다")
                        return
                    }
                    owner.descriptionLabel.textColor = Color.red
                    owner.descriptionText.onNext(error.errorDescription ?? "알 수 없는 에러가 발생했습니다")
                    owner.nextButton.isEnabled = false
                    owner.nextButton.backgroundColor = Color.red
                }
            }
            .disposed(by: disposeBag)
        
        // 구독 시점 미뤄서 맨 처음에는 빈 텍스트로 표시하기
        descriptionText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = BirthdayViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    enum NicknameValidationError: Error, LocalizedError {
        case length
        case invalidCharacter
        case number
        case whitespace
        
        var errorDescription: String? {
            switch self {
            case .length: "2글자 이상 10글자 미만으로 설정해주세요"
            case .invalidCharacter: "닉네임에 @, #, $, % 는 포함할 수 없어요"
            case .number: "닉네임에 숫자는 포함할 수 없어요"
            case .whitespace: "닉네임에 공백은 포함할 수 없어요"
            }
        }
    }
    
    func checkNickname(_ text: String) throws -> Bool {
        // 1) 2글자 이상 10글자 미만
        guard text.count >= 2 && text.count < 10 else {
            throw NicknameValidationError.length
        }
        // 2) @, #, $, % 사용 불가
        let invalidCharacters = "@#$%"
        guard text.filter({ invalidCharacters.contains($0) }).isEmpty else {
            throw NicknameValidationError.invalidCharacter
        }
        // 3) 숫자 사용 불가
        guard text.filter({ $0.isNumber }).isEmpty else {
            throw NicknameValidationError.number
        }
        // 4) 공백 사용 불가
        guard text.filter({ $0.isWhitespace }).isEmpty else {
            throw NicknameValidationError.whitespace
        }
        return true
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
