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
    
    let info = PublishRelay<String>()
    let infoColor = PublishRelay<UIColor>()
    
    let year = PublishRelay<Int>()
    let month = PublishRelay<Int>()
    let day = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        info
            .bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        infoColor
            .bind(to: infoLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .map {
                // 만 17세 이상인지 판별
                let component = Calendar.current.dateComponents([.year, .month, .day], from: $0, to: Date())
                guard let diffYear = component.year,
                      let diffMonth = component.month,
                      let diffDay = component.day else { return false }
                if diffYear > 17 {
                    return true
                } else if diffYear == 17 {
                    if diffMonth > 0 {
                        return true
                    } else if diffMonth == 0 {
                        if diffDay >= 0 {
                            return true
                        }
                    }
                }
                return false
            }
            .bind(with: self) { owner, value in
                // 레이블 표시 + 색 변경, 버튼 활성화 + 색 변경
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = value ? Color.green : Color.red
                owner.infoColor.accept(value ? Color.green : Color.red)
                owner.info.accept(value ? "가입 가능한 나이입니다" : "만 17세 이상만 가입 가능합니다")
            }
            .disposed(by: disposeBag)
        
        // 현재 선택한 날짜 표시하기
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                guard let year = component.year,
                      let month = component.month,
                      let day = component.day else { return }
                owner.year.accept(year)
                owner.month.accept(month)
                owner.day.accept(day)
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
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
