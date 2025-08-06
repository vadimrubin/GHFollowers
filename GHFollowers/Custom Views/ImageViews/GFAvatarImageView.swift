//
//  GFImageView.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 19.09.2024.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholderImage = Images.placeholder
    
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        //устанавливаем закругленные края для ImageView
        layer.cornerRadius = 10
        //так как в ImageView будет прямоугольная картинка, то нам нужен след код, для того, чтобы эта картинка не торчала из-за закругленной ImageView
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromURL url: String) {
//        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
        
        Task {
            image = await NetworkManager.shared.downloadImage(from: url) ?? placeholderImage
        }
    }

    //создаем функцию, которая будет загружать картинку по url, если какая-то ошибка то мы просто уходим в { return } и загружаем стандартную картинку из Бандла
    //перенесли функцию в Network Manager
//    func downloadImage(from urlString: String) {
//        //переводим urlString из String в NSString
//        let cacheKey = NSString(string: urlString)
//
//        //проверяем, есть ли картинка уже в Кэше, если есть, то обновляем картинку в UI и уходим из функции. Если нет, то идём дальше по коду
//        if let image = cache.object(forKey: cacheKey) {
//            self.image = image
//            return
//        }
//
//        //проверяем, что url, который мы передаем, это валидный url
//        guard let url = URL(string: urlString) else { return }
//
//        //создаем задачу по загрузке картинки и обновления UI в main thread
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            //из-за [weak self] self.image теперь опциональное значение и его нужно unwrap, следующая строчка кода помогает это сделать
//            guard let self = self else { return }
//
//            // если ошибка не nil (т.е. она существует), то уходим в блок return
//            if error != nil { return }
//            //если repsonse валиден и его статус равен 200 (успешно), то идем дальше по коду. Если нет, то return
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
//            //если есть data, то идём дальше по коду. Если нет, то return
//            guard let data = data else { return }
//            //создаем картинку из успешной data
//            guard let image = UIImage(data: data) else { return }
//            //добавляем картинку в Кэш
//            self.cache.setObject(image, forKey: cacheKey)
//            //обновляем UI, добавляя картинку, в main thread
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
//        task.resume()
//    }
}
