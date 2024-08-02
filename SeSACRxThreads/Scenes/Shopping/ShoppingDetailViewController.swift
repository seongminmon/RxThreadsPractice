//
//  ShoppingDetailViewController.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/2/24.
//

import UIKit

final class ShoppingDetailViewController: UIViewController {

    var naviTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        navigationItem.title = naviTitle
    }
}
