//
//  PresenterManager.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit

class PresenterManager {
    
    static let shared = PresenterManager()
    
    private init() {}
    
    enum vc {
        case tabBar
        case login
        case signUp
    }
    
    func createNewsViewController(image: UIImage) -> UIViewController {
        let vc = NewsViewController()
        vc.presenter = NewsPresenter(view: vc, vcType: Constants.NewsVCType.feed)
        vc.viewControllerType = Constants.NewsVCType.feed
        return createNavController(for: vc, title: "Новости", image: image)
    }
    
    func createFavouritesViewController(image: UIImage) -> UIViewController {
        let vc = NewsViewController()
        vc.presenter = NewsPresenter(view: vc, vcType: Constants.NewsVCType.favourites)
        vc.viewControllerType = Constants.NewsVCType.favourites
        return createNavController(for: vc, title: "Избранное", image: image)
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        navController.title = title
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }

    func show(vc: vc) {
        
        var viewController: UIViewController
        
        switch vc {
        case .tabBar:
            viewController = TabBarController()
        case .login:
            let vc = LoginViewController()
            let presenter = LoginPresenter(view: vc)
            vc.presenter = presenter
            viewController = UINavigationController(rootViewController: vc)
            viewController.navigationController?.navigationBar.prefersLargeTitles = true
        case .signUp:
            let vc = SignUpViewController()
            viewController = UINavigationController(rootViewController: vc)
            viewController.navigationController?.navigationBar.prefersLargeTitles = true
        }
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = viewController
                UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
}
