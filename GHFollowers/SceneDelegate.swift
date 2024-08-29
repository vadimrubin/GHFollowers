//
//  SceneDelegate.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 29.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

// так как мы удалили Storyboard, то настраиваем начальный запуск приложения через Scene.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        //проверяем, что опциональное windowScene - это UIWindowScene. UIWindowScene это объект, который менеджерит одно или несколько окон в приложении.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        //(2 этап) - после создания SearchVC и FavoritesListVC нам нужно создать Navigation Controllers для них. rootViewControllers выступают сами SearchVC и FavoritesListVC
        let searchNC = UINavigationController(rootViewController: SearchVC())
        let favoritesNC = UINavigationController(rootViewController: FavoritesListVC())
        
        //(3 этап) - теперь создаем tabbar (UITabBarController()), tabbar содержить array (массив) viewControllers, поэтому добавляем туда наши Navigation VC
//        let tabbar = UITabBarController()
//        tabbar.viewControllers = [searchNC, favoritesNC]
        
        //Здесь говорим, что окно будет занимать полностью всю Сцену
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        //у window есть windowScene, соответственно указываем что у нашего window windowScene та, которая сверху создана
        window?.windowScene = windowScene
        //у window должен быть самый основной View Conroller, соответственно мы говорим, что rootViewController - это ViewController() (самый первый View Conroller, который создается автоматически при создании приложения). rootViewController можно будет поменять в дальнейшем на какой-то другой, но для начального запуска нужно сделать так.
        //window?.rootViewController = ViewController()
        //поменяли ViewController() на UITabBarController()
        window?.rootViewController = createTabbar() //изначально здесь можно было указать просто UITabBarController() до момента, пока не создали tabbar
        // теперь делаем наш window KeyAndVisible
        window?.makeKeyAndVisible()
    }
    
    //(4 этап) - перенесли в функции создание UINavigationControllers, плюс там сразу добавили значки и заголовки для tabBar
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoritesListVC()
        favoritesListVC.title = "Favorites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesListVC)
    }
    
    //(5) - создадим функцию, которая создаст UITabBarController(), внутри которого наши Navigation Controllers
    func createTabbar() -> UITabBarController {
        let tabbar = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        //в массив viewControllers можно добавть функции, которые создают Navigation Controllers
        tabbar.viewControllers = [createSearchNC(), createFavoritesNC()]
        
        return tabbar
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

