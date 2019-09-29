//
//  SceneDelegate.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 16/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import UIKit

struct CombineWorkshopColor {
    static let red = UIColor(named: "red")
    static let yellow = UIColor(named: "yellow")
    static let orange = UIColor(named: "orange")
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let window = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController(rootViewController: StepOneViewController.initFromStoryboard())

        if UserDefaults.standard.currentStep.rawValue > 0 {
            (1...UserDefaults.standard.currentStep.rawValue).compactMap { WorkshopStep(rawValue: $0) }.forEach { step in
                navigationController.pushViewController(step.viewController!.initFromStoryboard(), animated: false)
            }
        }

        self.window = UIWindow(windowScene: window)
        self.window?.rootViewController = navigationController
        self.window?.tintColor = CombineWorkshopColor.red
        self.window?.makeKeyAndVisible()

        navigationController.navigationBar.barTintColor = CombineWorkshopColor.yellow
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        UISwitch.appearance().onTintColor = CombineWorkshopColor.yellow
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension UIStoryboard {
    /// Main storyboard
    public static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}
extension UIViewController: StoryboardIdentifiable { }

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }

    static func initFromStoryboard<T>() -> T {
        return UIStoryboard.main.instantiateViewController(withIdentifier: storyboardIdentifier) as! T
    }
}
