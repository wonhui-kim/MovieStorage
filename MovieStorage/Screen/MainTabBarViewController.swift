//
//  MainTabBarViewController.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/23.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    private let searchTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: ViewController()) //TODO: searchTab으로 연결
        controller.tabBarItem = UITabBarItem.init(tabBarSystemItem: .search, tag: 0)
        return controller
    }()
    
    private let bookmarkTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: ViewController()) //TODO: storeTab으로 연결
        controller.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 1)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBar()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureTabBar() {
        tabBar.tintColor = .black
        setViewControllers([searchTab, bookmarkTab], animated: true)
    }

}
