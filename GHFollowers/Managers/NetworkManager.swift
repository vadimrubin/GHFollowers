//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 17.09.2024.
//

import UIKit

//ТАКИМ КОД БЫЛ ДО ИЗОБРЕТЕНИЯ ASYNC/AWAIT
//class NetworkManager {
//    //для того, чтобы создать Singleton, нужны следующие две строчки кода
//    static let shared = NetworkManager()
//    
//    private init() {}
//    //это основной URL, который необходим для всех запросов
//    private let baseURL = "https://api.github.com/users/"
//    //создаем объект Кэш
//    let cache = NSCache<NSString, UIImage>()
//    
//    //до изобретения result type результат нашей функции был optional - ([Follower]?, ErrorMessages?).
////    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessages?) -> Void) {
//    //после изобретения result type мы можем перписать нашу фукцию (+ErrorMessages) так, чтобы у нас всегда возврщался либо удачный кейс, либо ошибка: (Result<[Follower], ErrorMessages>
//    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], ErrorMessages>) -> Void) {
//        //формируем URL для поиска по любому юзеру
//        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
//        
//        //проверяем, что строка выше может быть использована как URL через guard
//        guard let url = URL(string: endpoint) else {
//            //если url не валиден, то мы возвращаем nil по array of Followers и сообщение для VC, который в свою очередь сможет это сообщение показать
//            //сначала мы возвращали nil и сообщение String, а потом эти сообщения убрали в enum ErrorMessages и уже возвращаем nil и errorMessage
////            completed(nil, "This username created an invalid request. Please try again")
//            //это ДО result type
////            completed(nil, .invalidUserName)
//            //после изобретения result type мы теперь просто говорим, что этот кейс неудачный и передаём ошибку
//            completed(.failure(.invalidUserName))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            //теперь нам нужно проверить data, response и error на nil, так как все они optional
//            
//            //если у нас вернулся error, то запускаем completed и Network Call возвращает пустой Array и ошибку
//            //используем _ здесь, так как не используем далее переменную, хотя в оригинале это пишется как if let error = error т.е. error существует (не nil)
//            //вообще если у нас возвращается error в запросе, то это скорее всего проблемы с интернетом. Т.к. если запрос отправлен и он неправильный, то по нему вернется response как минимум. А тут вообще всё плохо, раз возвращается error, network call вообще не происходит
//            if let _ = error {
////                completed(nil, "Unnable to complete your request. Please check your internet connection")
//                //это ДО result type
////                completed(nil, .unableToComplete)
//                //после изобретения result type
//                completed(.failure(.unableToComplete))
//                //return - означает, что дальше мы не будем выполнять функцию getFollowers
//                return
//            }
//            
//            //guard let response = response as? HTTPURLResponse - проверяем, что response не nil. если не nil, то создается новая константа с таким же названием response и ей присваивается значение и кастится, как HTTPURLResponse
//            //второй этап: response.statusCode == 200 - если response не nil, то проверить что его статус-код равен 200. Если он равен 200, то будет выполняться следующий блок кода, а если не равен, то мы уйдем в ветку else
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
////                completed(nil, "Invalid response from the server. Please try again")
////                completed(nil, .invalidResponse)
//                completed(.failure(.invalidResponse))
//                //return - означает, что дальше мы не будем выполнять функцию getFollowers
//                return
//            }
//            
//            //последним проверяем, что у нас data не равно nil (т.е. data существует)
//            guard let data = data else {
////                completed(nil, "The data received from the server was invalid. Please try again.")
////                completed(nil, .invalidData)
//                completed(.failure(.invalidData))
//                return
//            }
//            
//            //если у нас есть data, то используем do-catch блок
//            do {
//                //JSONDecoder() - это объект, который преобразует data в наши объекты
//                //JSONEncoder() - работает наоборот, преобразует наши объекты в data
//                let decoder = JSONDecoder()
//                //используем keyDecodingStrategy, которая конвертит url from snake_Case to camelCase
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                //здесь мы хотим чтобы создался array из объектов Followers используя decoder.decode из data. Data - это то, что выше получили из guard let data = data
//                let followers = try decoder.decode([Follower].self, from: data)
//                //УСПЕШНЫЙ РЕЗУЛЬТАТ ФУНКЦИИ getFollowers.
////                completed(followers, nil)
//                completed(.success(followers))
//            } catch {
//                //тк мы используем выше try, то если try не удался, то мы уходим в блок catch и завершаем функцию с пустым результатом и ошибкой
////                completed(nil, "The data received from the server was invalid. Please try again.")
////                completed(nil, .invalidData)
//                completed(.failure(.invalidData))
//                //второй вариант, как показать ошибку средствами Эппл (т.е. показать ошибку, которая формируется реально). Проблема в том, что эта ошибка может быть трудночитаема для юзера, но полезна для разработчика (поэтому её удобно в принт выводить)
////                completed(nil, error.localizedDescription)
//            }
//            
//        }
//        
//        //эта строчка кода действительно запускает Network Call, без неё ничего не выйдет, всё что выше - это просто настройка
//        task.resume()
//    }
//    
//    func getUserInfo(for username: String, completed: @escaping (Result<User, ErrorMessages>) -> Void) {
//        //формируем URL для поиска по любому юзеру
//        let endpoint = baseURL + "\(username)"
//        
//        //проверяем, что строка выше может быть использована как URL через guard
//        guard let url = URL(string: endpoint) else {
//            //если url не валиден, то мы возвращаем nil по array of Followers и сообщение для VC, который в свою очередь сможет это сообщение показать
//            //сначала мы возвращали nil и сообщение String, а потом эти сообщения убрали в enum ErrorMessages и уже возвращаем nil и errorMessage
////            completed(nil, "This username created an invalid request. Please try again")
//            //это ДО result type
////            completed(nil, .invalidUserName)
//            //после изобретения result type мы теперь просто говорим, что этот кейс неудачный и передаём ошибку
//            completed(.failure(.invalidUserName))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            //теперь нам нужно проверить data, response и error на nil, так как все они optional
//            
//            //если у нас вернулся error, то запускаем completed и Network Call возвращает пустой Array и ошибку
//            //используем _ здесь, так как не используем далее переменную, хотя в оригинале это пишется как if let error = error т.е. error существует (не nil)
//            //вообще если у нас возвращается error в запросе, то это скорее всего проблемы с интернетом. Т.к. если запрос отправлен и он неправильный, то по нему вернется response как минимум. А тут вообще всё плохо, раз возвращается error, network call вообще не происходит
//            if let _ = error {
////                completed(nil, "Unnable to complete your request. Please check your internet connection")
//                //это ДО result type
////                completed(nil, .unableToComplete)
//                //после изобретения result type
//                completed(.failure(.unableToComplete))
//                //return - означает, что дальше мы не будем выполнять функцию getFollowers
//                return
//            }
//            
//            //guard let response = response as? HTTPURLResponse - проверяем, что response не nil. если не nil, то создается новая константа с таким же названием response и ей присваивается значение и кастится, как HTTPURLResponse
//            //второй этап: response.statusCode == 200 - если response не nil, то проверить что его статус-код равен 200. Если он равен 200, то будет выполняться следующий блок кода, а если не равен, то мы уйдем в ветку else
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
////                completed(nil, "Invalid response from the server. Please try again")
////                completed(nil, .invalidResponse)
//                completed(.failure(.invalidResponse))
//                //return - означает, что дальше мы не будем выполнять функцию getFollowers
//                return
//            }
//            
//            //последним проверяем, что у нас data не равно nil (т.е. data существует)
//            guard let data = data else {
////                completed(nil, "The data received from the server was invalid. Please try again.")
////                completed(nil, .invalidData)
//                completed(.failure(.invalidData))
//                return
//            }
//            
//            //если у нас есть data, то используем do-catch блок
//            do {
//                //JSONDecoder() - это объект, который преобразует JSON-objects в наши объекты/data
//                //JSONEncoder() - работает наоборот, преобразует наши объекты/data в JSON-objects
//                let decoder = JSONDecoder()
//                //используем keyDecodingStrategy, которая конвертит url from snake_Case to camelCase
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                decoder.dateDecodingStrategy = .iso8601
//                //здесь мы хотим чтобы создался array из объектов Followers используя decoder.decode из data. Data - это то, что выше получили из guard let data = data
//                let user = try decoder.decode(User.self, from: data)
//                //УСПЕШНЫЙ РЕЗУЛЬТАТ ФУНКЦИИ getFollowers.
////                completed(followers, nil)
//                completed(.success(user))
//            } catch {
//                //тк мы используем выше try, то если try не удался, то мы уходим в блок catch и завершаем функцию с пустым результатом и ошибкой
////                completed(nil, "The data received from the server was invalid. Please try again.")
////                completed(nil, .invalidData)
//                completed(.failure(.invalidData))
//                //второй вариант, как показать ошибку средствами Эппл (т.е. показать ошибку, которая формируется реально). Проблема в том, что эта ошибка может быть трудночитаема для юзера, но полезна для разработчика (поэтому её удобно в принт выводить)
////                completed(nil, error.localizedDescription)
//            }
//            
//        }
//        
//        //эта строчка кода действительно запускает Network Call, без неё ничего не выйдет, всё что выше - это просто настройка
//        task.resume()
//    }
//    
//    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
//        //переводим urlString из String в NSString
//        let cacheKey = NSString(string: urlString)
//        
//        //проверяем, есть ли картинка уже в Кэше, если есть, то обновляем картинку в UI и уходим из функции. Если нет, то идём дальше по коду
//        if let image = cache.object(forKey: cacheKey) {
//            completed(image)
//            return
//        }
//        
//        //проверяем, что url, который мы передаем, это валидный url
//        guard let url = URL(string: urlString) else {
//            completed(nil)
//            return
//        }
//        
//        //создаем задачу по загрузке картинки и обновления UI в main thread
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            //из-за [weak self] self.image теперь опциональное значение и его нужно unwrap, следующая строчка кода помогает это сделать
//            guard let self = self, //записываем комплексный guard let вместо каждого отдельного кейса внизу
//                    error == nil,
//                    let response = response as? HTTPURLResponse, response.statusCode == 200,
//                    let data = data, let image = UIImage(data: data) else {
//                completed(nil)
//                return
//            }
////
////            // если ошибка не nil (т.е. она существует), то уходим в блок return
////            if error != nil { return }
////            //если repsonse валиден и его статус равен 200 (успешно), то идем дальше по коду. Если нет, то return
////            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
////            //если есть data, то идём дальше по коду. Если нет, то return
////            guard let data = data else { return }
////            //создаем картинку из успешной data
////            guard let image = UIImage(data: data) else { return }
////            //добавляем картинку в Кэш
//            self.cache.setObject(image, forKey: cacheKey)
//            //обновляем UI, добавляя картинку, в main thread
//            completed(image)
//        }
//        task.resume()
//    }
//}


class NetworkManager {
    //для того, чтобы создать Singleton, нужны следующие две строчки кода
    static let shared = NetworkManager()
    
    private init() {
        //используем keyDecodingStrategy, которая конвертит url from snake_Case to camelCase
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    //это основной URL, который необходим для всех запросов
    private let baseURL = "https://api.github.com/users/"
    //создаем объект Кэш
    let cache = NSCache<NSString, UIImage>()
    //JSONDecoder() - это объект, который преобразует data в наши объекты
    let decoder = JSONDecoder()
    
    //до изобретения result type результат нашей функции был optional - ([Follower]?, ErrorMessages?).
//    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessages?) -> Void) {
    //после изобретения result type мы можем перписать нашу фукцию (+ErrorMessages) так, чтобы у нас всегда возврщался либо удачный кейс, либо ошибка: (Result<[Follower], ErrorMessages>
    /*func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], ErrorMessages>) -> Void)*/
    //после изобретения async/await мы удаляем весь блок complition handler и теперь код выглядит так, где async указывает, что это async/await-function и throws - что эта функция возвращает ошибки. Так же throws говорит нам, что в этой функции обязательно должен быть "выход" из каждой ситуации.
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        //формируем URL для поиска по любому юзеру
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        //проверяем, что строка выше может быть использована как URL через guard
        guard let url = URL(string: endpoint) else {
            //если url не валиден, то мы возвращаем nil по array of Followers и сообщение для VC, который в свою очередь сможет это сообщение показать
            //тепеь вместо того, чтобы вызывать блок complition handler, мы пишем throw
            throw ErrorMessages.invalidUserName
            //            return //нам не нужен return теперь
        }
        
        //СЛЕДУЮЩИЙ КОД ВМЕСТО БЛОКА let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        //у нас появляется новый синтаксис для этой задачи
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //guard let response = response as? HTTPURLResponse - проверяем, что response не nil. если не nil, то создается новая константа с таким же названием response и ей присваивается значение и кастится, как HTTPURLResponse
        //второй этап: response.statusCode == 200 - если response не nil, то проверить что его статус-код равен 200. Если он равен 200, то будет выполняться следующий блок кода, а если не равен, то мы уйдем в ветку else
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ErrorMessages.invalidResponse
        }
        
        //если у нас есть data, то используем do-catch блок
        do {
            //здесь мы хотим чтобы создался array из объектов Followers используя decoder.decode из data. Data - это то, что выше получили из let (data, response) = try await URLSession.shared.data(from: url)
            return try decoder.decode([Follower].self, from: data)
        } catch {
            //тк мы используем выше try, то если try не удался, то мы уходим в блок catch и завершаем функцию с пустым результатом и ошибкой
            throw ErrorMessages.invalidData
        }
    }
    
    func getUserInfo(for username: String) async throws -> User {
        //формируем URL для поиска по любому юзеру
        let endpoint = baseURL + "\(username)"
        
        //проверяем, что строка выше может быть использована как URL через guard
        guard let url = URL(string: endpoint) else {
            throw ErrorMessages.invalidUserName
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ErrorMessages.invalidResponse
        }
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw ErrorMessages.invalidData
        }
    }
    
    //эту функцию мы маркируем только async т.к. в данном случае мы не заботимся об ошибке, если возникает ошибка, то мы показываем дефолтную картинку, и соответственно возвращаем опциональный UIImage, т.к. может быть картинка, а может быть nil
    
    func downloadImage(from urlString: String) async -> UIImage? {
        //переводим urlString из String в NSString
        let cacheKey = NSString(string: urlString)
        
        //проверяем, есть ли картинка уже в Кэше, если есть, то обновляем картинку в UI и уходим из функции. Если нет, то идём дальше по коду
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        
        //проверяем, что url, который мы передаем, это валидный url
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            //получаем данные через URLSession, т.к. нас не заботит response, то пишем (data, _)
            let (data, _) = try await URLSession.shared.data(from: url)
            //проверяем, можем ли мы из данных создать картинку
            guard let image = UIImage(data: data) else {
                return nil
            }
            //если картинка получилась, то добавляем её в кэш и отдаем картинку
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}

