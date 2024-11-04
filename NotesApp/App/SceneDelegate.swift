//
//  SceneDelegate.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let navigatioController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navigatioController
        window?.makeKeyAndVisible()
    }
}
