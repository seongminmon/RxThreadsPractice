//
//  UIViewController+.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/2/24.
//

import UIKit

extension UIViewController {
    
    func showAlert(
        title: String?,
        completionHandler: ((UIAlertAction) -> Void)?
    ) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "확인", style: .default, handler: completionHandler)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}
