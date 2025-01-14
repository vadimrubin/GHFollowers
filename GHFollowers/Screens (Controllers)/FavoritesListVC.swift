//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 29.08.2024.
//

import UIKit

//VC для показа Favorites
class FavoritesListVC: UIViewController {
    
    let favoritesTableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureFavoritesTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites() //getFavorites вызывваем во viewWillAppear, чтобы при возвращении на экран изменить данные в таблице, если добавили пользователей в Favorites на других экранах
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //метод, с помощью которого загружаем объекты Favorites из UserDefaults
    func getFavorites() {
        PersistanceManager.retrieveFavorites { [weak self] result in //вызываем метод retrieveFavorites у PersistanceManager
            guard let self = self else { return } //для [weak self]
            //два варианта результата: success и failure
            switch result {
            case .success(let favorites): //при success у нас есть какие-то объекты Favorites или nil
                //проверяем на nil
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No favorites?\nAdd one the follower screen", in: self.view)
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.favoritesTableView.reloadData() //обновляем таблицу в main thread
                        self.view.bringSubviewToFront(self.favoritesTableView) //это необходимо для того,чтобы favoritesTableView был вынесен вперед, в случае если он "затерялся" среди view
                    }
                }
                
            case .failure(let error): //при failure у нас есть error
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok") //показываем alert
            }
        }
    }
    
    //конфиг tableview
    func configureFavoritesTableView() {
        view.addSubview(favoritesTableView)
        favoritesTableView.frame = view.bounds
        favoritesTableView.rowHeight = 80
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
}

extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
    //колтчество строк
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    //формируем ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    //показываем destVC при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowersListVC()
        destVC.username = favorite.login
        destVC.title = favorite.login
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    //удаляем ячейку
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        favoritesTableView.deleteRows(at: [indexPath], with: .left)
        
        PersistanceManager.updateWith(follower: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
