//
//  SceneDelegate.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let rootViewController = UINavigationController(rootViewController: SignInViewController())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
