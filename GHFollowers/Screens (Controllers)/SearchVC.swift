//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 29.08.2024.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroudColor: .systemGreen, title: "Get Followers")
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    //создаем computed property
    var isUserNameEntered: Bool {
        //если usernameTextField пустой, то true, но мы заменяем это на false знаком ! перед стейтментом, для того, что логика функции isUserNameEntered не нарушалась
        return !usernameTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = "" //каждый раз при возврате на SearchVC предыдущий текст удаляется, если он был
        //этот код пишем в цикле viewWillAppear для того, чтобы navigation bar скрывался тогда, когда мы возвращаемся к начальному экрану
        //если это сделать во viewDidLoad, то navigation bar будет скрыт только при первом запуске экрана
        //navigationController?.isNavigationBarHidden = true - не совсем корректно работает, т.к. когда мы возвращаемся на половину предыдущего экрана свайпом, то viewWillAppear скрывает navigation bar, и если с половины экрана вернуться обратно, то на следующем экране viewDidLoad ещё не запускается и не меняет значение avigationController?.isNavigationBarHidden на false
        navigationController?.setNavigationBarHidden(true, animated: true) 
    }
    
    func configureLogoImageView() {
        //нужно обязательно не забывать добавлять Subview to View. Это как в Storyboard перетащить элемент на экран
        view.addSubview(logoImageView)
        //хотим использовать auto layout
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true
        
        //задаем constraints через метод .activate добавляя в array нужные нам constraints
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        view.addSubview(usernameTextField)
        //для UITextFieldDelegate
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            //c trailingAnchor и bottomAnchor нужно использовать отрицательные числа
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        //конфигурируем что делать, когда нажимаем на кнопку
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            //c trailingAnchor и bottomAnchor нужно использовать отрицательные числа
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //эта функция используется в двух случаях: 1) когда мы нажимаем кнопку callToActionButton 2) когда нажимаем return в textField (в этом помогает extension - UITextFieldDelegate)
    @objc func pushFollowerListVC() {
        
        // используем guard для того, чтобы проверить введен ли текст. Если текст не введен, то весь код в функции pushFollowerListVC после guard isUserNameEntered выполнятся не будет (не будем показывать следующий VC), покажем Alert
        guard isUserNameEntered else {
            //способ показать кастомный Alert
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 🕵️‍♀️", buttonTitle: "Ok")
            
            /* таким способом показывается обычный Apple Alert
            let message = "Please enter a username. We need to know who to look for... 🕵️‍♀️"
            let alertController = UIAlertController(title: "No username", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            */ 
            return
            }
        
        usernameTextField.resignFirstResponder() //хотим убрать клавиатуру при переходе на следующий экран, чтобы, когда пользователь свайпил обратно на пол экрана, там не было видно клавиатуру (EdgeCase)
        
        //создаем экземпляр класса
        let followerListVC = FollowersListVC(username: usernameTextField.text ?? "")
        //передаем значение, которое ввели в text field, на следущий VC в переменную userName
//        followerListVC.username = usernameTextField.text
//        //меняем title у Navigation Controller на то, что написано в text field
//        followerListVC.title = usernameTextField.text
        //показываем следующий VC
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    //функция для того чтобы убирать клавиатуру при тапе в любом месте на экране
    func createDismissKeyboardTapGesture() {
        //клавиатура убирается из-за того, что мы указали, что процесс ввода закончился методом endEditing
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension SearchVC: UITextFieldDelegate {
    //метод, который позволяет отследить, что мы нажали кнопку return в textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
