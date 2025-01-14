//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 16.09.2024.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

//создаем Extension для VC, чтобы каждый VC мог вызвать наш кастомный Alert
extension UIViewController {
    
    //добавляем кастомный метод для UIViewController
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        //добавляем в main thread чтобы не вызывать это каждый раз отдельно
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showLoadingView() {
        //создаем view и добавляем его на основной view
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        //устанавлиаем, что он изначально прозрачный
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        //анимацией меняем прозрачность и делаем слегка прозрачным
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        //создаем activityIndicator и добавляем его на containerView
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        //включаем activityIndicator
        activityIndicator.startAnimating()
    }
    
    //метод, которым убираем loading view
    func dismissLoadingView() {
        //обязательно это должно быть в main
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    //метод для показа SafariView
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
