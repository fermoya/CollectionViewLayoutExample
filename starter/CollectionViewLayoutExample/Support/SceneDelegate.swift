//
//  SceneDelegate.swift
//  CollectionViewLayoutExample
//
//  Created by Fernando Moya de Rivas on 05/04/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = MainViewController()
            self.window = window
            window.makeKeyAndVisible()
        }

    }
    
}

