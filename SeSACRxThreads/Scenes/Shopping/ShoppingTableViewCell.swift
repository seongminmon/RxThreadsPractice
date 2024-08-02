//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/2/24.
//

import UIKit
import SnapKit

final class ShoppingTableViewCell: UITableViewCell {
    
    static let id = "ShoppingTableViewCell"
    
    let containerView = UIView()
    let checkButton = UIButton()
    let mainLabel = UILabel()
    let starButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .systemGray6
        checkButton.tintColor = Color.black
        starButton.tintColor = Color.black
        
        [checkButton, mainLabel, starButton].forEach {
            containerView.addSubview($0)
        }
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }
        
        starButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.trailing.equalTo(starButton.snp.leading).offset(-8)
            make.height.equalTo(50)
        }
    }
    
    func configureCell(_ data: Shopping) {
        let checkImage = data.isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        checkButton.setImage(checkImage, for: .normal)
        let starImage = data.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        starButton.setImage(starImage, for: .normal)
        mainLabel.text = data.contents
    }
}
