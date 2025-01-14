//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 05.09.2024.
//

import UIKit

//протокол для коммуникации между FollowersListVC и UserInfoVC
protocol FollowersListVCDelegate {
    func didRequestFollowers(for username: String) //действие - показать FollowersListVC по новому user
}

class FollowersListVC: UIViewController {
    
    //создаем секции для Collection View. У нас только одна секция, поэтому один кейс main
    //enum - Hashable по дефолту
    enum Section {
        case main
    }
    
    var username: String!
    var followersArray: [Follower] = []
    var filteredFollowers: [Follower] = []
    var collectionView: UICollectionView!
    //создаем объект, которые позволяет конфигурировать Collection View с данными Section and Follower
    //UICollectionViewDiffableDataSource позволяет создавать Collection View (и Table View)с динамически изменяемыми данными
    //параметры <Section, Follower> - должны быть Hashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    //конфиг VC
    func configureViewController() {
        view.backgroundColor = .systemBackground
        //хотим показывать navigation bar c title (title установили на пред VC при переходе)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //добавляем кнопку + на место rightBarButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        //ставим кнопку Done на место rightBarButtonItem
        navigationItem.rightBarButtonItem = addButton
    }
    
    //действие кнопки rightBarButtonItem
    @objc func addButtonTapped() {
        showLoadingView() //так как будем запускать NetworkManager, то нужно показать LoadingView, пока ждем результат
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in //хотим получить инфо по конкретному юзеру
            guard let self = self else { return }
            self.dismissLoadingView() //перестаем показывать LoadingView, так как уже есть результат
            
            switch result {
                
            case .success(let user): //кейс успешный и у нас есть объект user
                let favoriteUser = Follower(login: user.login, avatarUrl: user.avatarUrl) //создаем объект Follower с данными user
                //запускаем PersistanceManager с объектом favoriteUser и хотим сохранить (.add) его в UseDefaults
                PersistanceManager.updateWith(follower: favoriteUser, actionType: .add) { [weak self] error in
                    guard let self = self else { return } //штука нужная т.к. выше [weak self]
                    //error is optional, поэтому нужно баиндить
                    guard let error = error else {
                        //если нет ошибки, то показываем успешный Алерт
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You've succesfully favorited this user", buttonTitle: "Good!")
                        return //и выходим из функции
                    }
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok") //если есть ошибка, то показываем Alert с этой ошибкой
                    
                }
            case .failure(let error): //если кейс неудачный, то тоже показываем Алерт с ошибкой
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureCollectionView() {
        //сначала нам нужно инициализировать collectionView, а затем уже добавлять его на View. Если сделать наоборот, то collectionView = nil при добавлении на View
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        //нужно добавить клетку в collectionView
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    //создаем searchController, который позволяет искать среди Collection View. Бар от Эпл сверху экрана.
    func configureSearchController() {
        //инициализация
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        //текст, который указывается в search баре
        searchController.searchBar.placeholder = "Search for a username"
        //не затемнять фон
        searchController.obscuresBackgroundDuringPresentation = false
        //добавить сам search bar в navigation item
        navigationItem.searchController = searchController
    }
    
    func test() {
        print("test")
    }
    
    
    
    func getFollowers(username: String, page: Int) {
        //так запускали NetworkManager до изобретения result type
        /*NetworkManager.shared.getFollowers(for: userName, page: 1) { (followers, errorMessage) in
            guard let followers = followers else {
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: errorMessage?.rawValue ?? "Baaad things...", buttonTitle: "Ok")
                return
            }
        } */
        
        //теперь запускаем NetworkManager следующим образом с учётом result type
        //[weak self] - NetworkManager имеет строгую взаимосвязь с FollowersListVC, это может способствовать memory leaks (утечка памяти). Чтобы этого избежать нам нужно добавить [weak self] в result
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            //result - это либо success, либо failure. Поэтому теперь можем воспользоваться switch и написать результат для каждого кейса
            //из-за [weak self] self.followersArray теперь опциональное значение и его нужно unwrap, следующая строчка кода помогает это сделать
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                //если количество followers, которые загрузили, меньше, чем 100, то меняем значение hasMoreFollowers на false
                if followers.count < 100 { self.hasMoreFollowers = false }
                //добавляем новых followers в основной array
                self.followersArray.append(contentsOf: followers)
                if self.followersArray.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😀"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                        return
                    }
                }
                self.updateData(on: self.followersArray)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    //функция, которая конфигурирует dataSource для UICollectionViewDiffableDataSource. Мы ещё не передаем реальные данные в ячейку, а только говорим какие данные будут в ней и какой формат ячейки
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            //создаем ячейку и кастим её как FollowerCell (формат ячейки)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            //передаем follower информацию в ячейку. Тем самым в ячейке будет логин пользователя
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(followers)
        //вот в этой строчке мы тригирим UI обновить данные
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
    }
}

//экстеншн FollowersListVC для того, чтобы отследить когда мы проскролим весь ScrollView
extension FollowersListVC: UICollectionViewDelegate {
    
    //метод, который отследивает момент того, что мы закончили скролл. Не означает, что мы проскролили весь ScrollView
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //считаем сколько мы проскролили
        let offsetY = scrollView.contentOffset.y
        //сколько всего высота scrollView
        let contentHeight = scrollView.contentSize.height
        //высота экрана
        let height = scrollView.frame.size.height
        
        print("offsetY = \(offsetY)")
        print("contentHeight = \(contentHeight)")
        print("height = \(height)")
        
        //если то, сколько мы проскролили больше, чем высота scrollView минус высота экрана
        if offsetY > contentHeight - height {
            //если hasMoreFollowers = false, то ничего не делаем
            guard hasMoreFollowers else { return }
            //увеличиваем значение page, чтобы загружать следующую страницу
            page += 1
            //загружаем новых followers
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //создаем новый followersArray в зависимости от того, какой array сейчас показываается - фильтрованный или основной.
        // W ? T : F (What? ? True : False)
        let activeArray = isSearching ? filteredFollowers : followersArray
        //определяем, какой follower выбран
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.delegate = self //устанавливаем delegate для destVC, это означает, что FollowersListVC сидит и слушает, когда будет нажата кнопка на destVC (UserInfoVC)
        destVC.userName = follower.login
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

//здесь пишем код для логики того, как будет происходить поиск/фильтр в searchController
extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    //UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        // пусть filter это текст, который введен в searchBar, и он НЕ пустой. Если это не так = Текст не введен, то выходим из функции.
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        //в новый array добавляем followers по фильтру contains
        filteredFollowers = followersArray.filter { $0.login.lowercased().contains(filter.lowercased()) }
        //обновляем данные с новым array
        updateData(on: filteredFollowers)
    }
    
    //UISearchBarDelegate. Функция, которая позволяет написать код, который будет исполнен в момент нажатия кнопки Cancel в SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followersArray)
    }
}

// действие протокола FollowersListVCDelegate
extension FollowersListVC: FollowersListVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username //новый username, который мы получаем из UserInfoVC
        title = username //новый title, который равен новому username
        page = 1 //начинаем с первой страницы
        followersArray.removeAll() //удаляем объекты из arrays
        filteredFollowers.removeAll() //удаляем объекты из arrays
        collectionView.setContentOffset(.zero, animated: true) //сдвигаем collection view в начало
        getFollowers(username: username, page: page) //запускаем метод getFollowers для юзера из UserInvoVC
    }
    
    
}
