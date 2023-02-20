//
//  TabBarController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let presenterManager = PresenterManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        delegate = self
        tabBar.tintColor = Constants.Colors.selectedColor
        tabBar.unselectedItemTintColor = Constants.Colors.greyColor
        self.selectedIndex = 0
    }

    func setupViews() {
        viewControllers = [
            presenterManager.createNewsViewController(image: UIImage(named: "newsLogo")!),
            createNavController(for: MapViewController(), title: "Карта", image: UIImage(named: "mapLogo")!),
            presenterManager.createFavouritesViewController(image: UIImage(named: "heartLogo")!),
            createNavController(for: ProfileViewController(), title: "Профиль", image: UIImage(named: "profileLogo")!)
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        navController.title = title
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}

extension TabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
}
