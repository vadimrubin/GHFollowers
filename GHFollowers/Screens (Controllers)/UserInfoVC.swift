//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 09.10.2024.
//

import UIKit

//протокол для коммуникации между FollowersListVC и UserInfoVC
protocol UserInfoVCDelegate {
    func didRequestFollowers(for username: String) //действие - показать FollowersListVC по новому user
}

class UserInfoVC: GFDataLoadingVC {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    var userName: String!
    
    var delegate: UserInfoVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        layoutUI()
        getUserInfo()  
    }
    
    func showSafariViewwww() {
        print("Что-то теперь работает")
        view.backgroundColor = .yellow
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        //создаем UIBarButtonItem - дефолтная Эпл кнопка Done
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        //ставим кнопку Done на место rightBarButtonItem
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }

    // @objc метод для UIBarButtonItem - скрыть VC
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        
        for item in itemViews {
            contentView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                item.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func getUserInfo() {
        //загружаем информацию по Юзеру через NetworkManager
//        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
//            //штука, нужная для [weak self]
//            guard let self = self else { return }
//            
//            //результат запроса - это success или failure. Проходим по каждому варианту.
//            switch result {
//            case .success(let user):
//                DispatchQueue.main.async {
//                    self.configureUIElements(with: user)
//                }
//                
//            case .failure(let error):
//                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
//            }
//        }
        //т.к. func getUserInfo не отмечена, как async, то код ниже нужно вложить в Task
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: userName)
                configureUIElements(with: user)
            } catch {
                if let error = error as? ErrorMessages {
                    presentGFAlert(title: "Something went wrong here", message: error.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    func configureUIElements(with user: User) {
        //первый вариант добавить delegate в init
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        
        //второй вариант - delegate устанавливается отдельно
        let followersVC = GFFollowerItemVC(user: user)
        followersVC.delegate = self
        self.add(childVC: followersVC, to: self.itemViewTwo)
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

}

//действия протокола коммуникаций между UserInfoVC - GFRepoItemVC/FollowersItemVC
extension UserInfoVC: GFRepoItemVCDelegate {
    //действие, которое просит запустить GFRepoItemVC, при нажатии на кнопку
    func didTapGitHubProfile(for user: User) {
        //проверяем url
        guard let url = URL(string: user.htmlUrl) else {
            //если url не получился, то показываем Alert
            presentGFAlert(title: "Invalid URL", message: "The URL attached to the user is invalid", buttonTitle: "Ok")
            return // выходим из метода
        }
        presentSafariVC(with: url) //показываем SafariView с успешным url
    }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
    //действие, которое просит запустить GFFollowerItemVC, при нажатии на кнопку
    func didTapGetFollowers(for user: User) {
        //проверяем есть ли followers у юзера
        guard user.followers != 0 else {
            //если user.followers = 0, то показываем Alert
            presentGFAlert(title: "No followers", message: "This user has no followers", buttonTitle: "Ok")
            return //return здесь означает, что мы выходим из всей функции didTapGetFollowers и не переходим к delegate.didRequestFollowers(for: user.login)
        }
        //если user.followers != 0, то выполняем следующий код
        delegate.didRequestFollowers(for: user.login) //UserInfoVCDelegate - сообщаем FollowersListVC, что хотим выполнить func didRequestFollowers
        dismissVC() //скрываем текущий VC
    }
}



    
