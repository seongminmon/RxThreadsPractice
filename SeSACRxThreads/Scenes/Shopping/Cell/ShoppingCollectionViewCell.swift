//
//  ShoppingCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/7/24.
//

import UIKit
import SnapKit

final class ShoppingCollectionViewCell: UICollectionViewCell {
    
    static let id = "ShoppingCollectionViewCell"
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        
        label.textAlignment = .center
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    func configureCell(_ text: String) {
        label.text = text
    }
}
