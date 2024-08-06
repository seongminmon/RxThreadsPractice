//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel = UILabel()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        let input = BirthdayViewModel.Input(
            date: birthDayPicker.rx.date,
            nextTap: nextButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.validation
            .map { $0 ? Color.green : Color.red }
            .bind(to: infoLabel.rx.textColor,
                  nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.validation
            .map { $0 ? "가입 가능한 나이입니다" : "만 17세 이상만 가입 가능합니다" }
            .bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.year
            .map { "\($0 ?? 0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nextTap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "가입 완료", completionHandler: nil)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = Color.white
        
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
