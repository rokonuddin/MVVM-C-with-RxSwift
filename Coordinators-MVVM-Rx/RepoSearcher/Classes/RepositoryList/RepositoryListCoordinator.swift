//
//  RepositoryListCoordinator.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 6/30/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class RepositoryListCoordinator: BaseCoordinator<Void> {

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
        var viewController = RepositoryListViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.bindViewModel(to: viewModel)

        viewModel.showRepository
            .subscribe(onNext: { [weak self] in self?.showRepository(by: $0, in: navigationController) })
            .disposed(by: disposeBag)

        viewModel.showLanguageList
            .flatMap { [weak self] _ -> Observable<String?> in
                guard let `self` = self else { return .empty() }
                return self.showLanguageList(on: viewController)
            }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: viewModel.setCurrentLanguage)
            .disposed(by: disposeBag)
        tabBarController.viewControllers = [navigationController]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        return Observable.never()
    }

    private func showRepository(by url: URL, in navigationController: UINavigationController) {
        let safariViewController = SFSafariViewController(url: url)
        navigationController.pushViewController(safariViewController, animated: true)
    }

    private func showLanguageList(on rootViewController: UIViewController) -> Observable<String?> {
        let languageListCoordinator = LanguageListCoordinator(rootViewController: rootViewController)
        return coordinate(to: languageListCoordinator)
            .map { result in
                switch result {
                case .language(let language): return language
                case .cancel: return nil
                }
            }
    }
}
