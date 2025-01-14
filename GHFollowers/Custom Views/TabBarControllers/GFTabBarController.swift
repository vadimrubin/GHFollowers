//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 14.01.2025.
//

import UIKit

//данный класс используется в SceneDelegate. С его помощью мы создаем UITabBarController
class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen //делаем UITabBar зеленым
        viewControllers = [createSearchNC(), createFavoritesNC()] //добавляем VC
    }
    
    //создаем UINavigationController, который будет выполнять роль ViewController-а
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC() //rootViewController для UINavigationController
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    //создаем второй UINavigationController, который будет выполнять роль ViewController-а
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoritesListVC() //rootViewController для UINavigationController
        favoritesListVC.title = "Favorites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesListVC)
    }

}
