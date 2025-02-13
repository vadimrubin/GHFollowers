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
    
    
    //метод для показа SafariView
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
