//
//  FavoriteRepositoryCoordinator.swift
//  RepoSearcher
//
//  Created by Mohammed Rokon Uddin on 8/22/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import UIKit
import RxSwift

class FavoriteRepositoryCoordinator: BaseCoordinator<Void> {

    private let tabBarController: UITabBarController
    private let window: UIWindow
    init(window: UIWindow) {
        //swiftlint:disable force_cast
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        self.tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.window = window
    }

    override func start() -> Observable<Void> {
        let viewModel = RepositoryListViewModel(initialLanguage: "Swift")
        let viewController = RepositoryListViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.viewModel = viewModel

        tabBarController.viewControllers?.append(viewController)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        return Observable.never()
    }
}
