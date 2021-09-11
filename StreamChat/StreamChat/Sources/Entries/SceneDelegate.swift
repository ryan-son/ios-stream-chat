//
//  StreamChat - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)

        let entryViewController = JoinChatRoomViewController()
        window?.rootViewController = UINavigationController(rootViewController: entryViewController)
        window?.makeKeyAndVisible()
    }
}
