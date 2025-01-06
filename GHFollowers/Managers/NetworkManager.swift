//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 17.09.2024.
//

import UIKit

class NetworkManager {
    //для того, чтобы создать Singleton, нужны следующие две строчки кода
    static let shared = NetworkManager()
    
    private init() {}
    //это основной URL, который необходим для всех запросов
    private let baseURL = "https://api.github.com/users/"
    //создаем объект Кэш
    let cache = NSCache<NSString, UIImage>()
    
    //до изобретения result type результат нашей функции был optional - ([Follower]?, ErrorMessages?).
//    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessages?) -> Void) {
    //после изобретения result type мы можем перписать нашу фукцию (+ErrorMessages) так, чтобы у нас всегда возврщался либо удачный кейс, либо ошибка: (Result<[Follower], ErrorMessages>
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], ErrorMessages>) -> Void) {
        //формируем URL для поиска по любому юзеру
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        //проверяем, что строка выше может быть использована как URL через guard
        guard let url = URL(string: endpoint) else {
            //если url не валиден, то мы возвращаем nil по array of Followers и сообщение для VC, который в свою очередь сможет это сообщение показать
            //сначала мы возвращали nil и сообщение String, а потом эти сообщения убрали в enum ErrorMessages и уже возвращаем nil и errorMessage
//            completed(nil, "This username created an invalid request. Please try again")
            //это ДО result type
//            completed(nil, .invalidUserName)
            //после изобретения result type мы теперь просто говорим, что этот кейс неудачный и передаём ошибку
            completed(.failure(.invalidUserName))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //теперь нам нужно проверить data, response и error на nil, так как все они optional
            
            //если у нас вернулся error, то запускаем completed и Network Call возвращает пустой Array и ошибку
            //используем _ здесь, так как не используем далее переменную, хотя в оригинале это пишется как if let error = error т.е. error существует (не nil)
            //вообще если у нас возвращается error в запросе, то это скорее всего проблемы с интернетом. Т.к. если запрос отправлен и он неправильный, то по нему вернется response как минимум. А тут вообще всё плохо, раз возвращается error, network call вообще не происходит
            if let _ = error {
//                completed(nil, "Unnable to complete your request. Please check your internet connection")
                //это ДО result type
//                completed(nil, .unableToComplete)
                //после изобретения result type
                completed(.failure(.unableToComplete))
                //return - означает, что дальше мы не будем выполнять функцию getFollowers
                return
            }
            
            //guard let response = response as? HTTPURLResponse - проверяем, что response не nil. если не nil, то создается новая константа с таким же названием response и ей присваивается значение и кастится, как HTTPURLResponse
            //второй этап: response.statusCode == 200 - если response не nil, то проверить что его статус-код равен 200. Если он равен 200, то будет выполняться следующий блок кода, а если не равен, то мы уйдем в ветку else
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(nil, "Invalid response from the server. Please try again")
//                completed(nil, .invalidResponse)
                completed(.failure(.invalidResponse))
                //return - означает, что дальше мы не будем выполнять функцию getFollowers
                return
            }
            
            //последним проверяем, что у нас data не равно nil (т.е. data существует)
            guard let data = data else {
//                completed(nil, "The data received from the server was invalid. Please try again.")
//                completed(nil, .invalidData)
                completed(.failure(.invalidData))
                return
            }
            
            //если у нас есть data, то используем do-catch блок
            do {
                //JSONDecoder() - это объект, который преобразует data в наши объекты
                //JSONDecoder() - работает наоборот, преобразует наши объекты в data
                let decoder = JSONDecoder()
                //используем keyDecodingStrategy, которая конвертит url from snake_Case to camelCase
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                //здесь мы хотим чтобы создался array из объектов Followers используя decoder.decode из data. Data - это то, что выше получили из guard let data = data
                let followers = try decoder.decode([Follower].self, from: data)
                //УСПЕШНЫЙ РЕЗУЛЬТАТ ФУНКЦИИ getFollowers.
//                completed(followers, nil)
                completed(.success(followers))
            } catch {
                //тк мы используем выше try, то если try не удался, то мы уходим в блок catch и завершаем функцию с пустым результатом и ошибкой
//                completed(nil, "The data received from the server was invalid. Please try again.")
//                completed(nil, .invalidData)
                completed(.failure(.invalidData))
                //второй вариант, как показать ошибку средствами Эппл (т.е. показать ошибку, которая формируется реально). Проблема в том, что эта ошибка может быть трудночитаема для юзера, но полезна для разработчика (поэтому её удобно в принт выводить)
//                completed(nil, error.localizedDescription)
            }
            
        }
        
        //эта строчка кода действительно запускает Network Call, без неё ничего не выйдет, всё что выше - это просто настройка
        task.resume()
    }
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, ErrorMessages>) -> Void) {
        //формируем URL для поиска по любому юзеру
        let endpoint = baseURL + "\(username)"
        
        //проверяем, что строка выше может быть использована как URL через guard
        guard let url = URL(string: endpoint) else {
            //если url не валиден, то мы возвращаем nil по array of Followers и сообщение для VC, который в свою очередь сможет это сообщение показать
            //сначала мы возвращали nil и сообщение String, а потом эти сообщения убрали в enum ErrorMessages и уже возвращаем nil и errorMessage
//            completed(nil, "This username created an invalid request. Please try again")
            //это ДО result type
//            completed(nil, .invalidUserName)
            //после изобретения result type мы теперь просто говорим, что этот кейс неудачный и передаём ошибку
            completed(.failure(.invalidUserName))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //теперь нам нужно проверить data, response и error на nil, так как все они optional
            
            //если у нас вернулся error, то запускаем completed и Network Call возвращает пустой Array и ошибку
            //используем _ здесь, так как не используем далее переменную, хотя в оригинале это пишется как if let error = error т.е. error существует (не nil)
            //вообще если у нас возвращается error в запросе, то это скорее всего проблемы с интернетом. Т.к. если запрос отправлен и он неправильный, то по нему вернется response как минимум. А тут вообще всё плохо, раз возвращается error, network call вообще не происходит
            if let _ = error {
//                completed(nil, "Unnable to complete your request. Please check your internet connection")
                //это ДО result type
//                completed(nil, .unableToComplete)
                //после изобретения result type
                completed(.failure(.unableToComplete))
                //return - означает, что дальше мы не будем выполнять функцию getFollowers
                return
            }
            
            //guard let response = response as? HTTPURLResponse - проверяем, что response не nil. если не nil, то создается новая константа с таким же названием response и ей присваивается значение и кастится, как HTTPURLResponse
            //второй этап: response.statusCode == 200 - если response не nil, то проверить что его статус-код равен 200. Если он равен 200, то будет выполняться следующий блок кода, а если не равен, то мы уйдем в ветку else
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(nil, "Invalid response from the server. Please try again")
//                completed(nil, .invalidResponse)
                completed(.failure(.invalidResponse))
                //return - означает, что дальше мы не будем выполнять функцию getFollowers
                return
            }
            
            //последним проверяем, что у нас data не равно nil (т.е. data существует)
            guard let data = data else {
//                completed(nil, "The data received from the server was invalid. Please try again.")
//                completed(nil, .invalidData)
                completed(.failure(.invalidData))
                return
            }
            
            //если у нас есть data, то используем do-catch блок
            do {
                //JSONDecoder() - это объект, который преобразует data в наши объекты
                //JSONDecoder() - работает наоборот, преобразует наши объекты в data
                let decoder = JSONDecoder()
                //используем keyDecodingStrategy, которая конвертит url from snake_Case to camelCase
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                //здесь мы хотим чтобы создался array из объектов Followers используя decoder.decode из data. Data - это то, что выше получили из guard let data = data
                let user = try decoder.decode(User.self, from: data)
                //УСПЕШНЫЙ РЕЗУЛЬТАТ ФУНКЦИИ getFollowers.
//                completed(followers, nil)
                completed(.success(user))
            } catch {
                //тк мы используем выше try, то если try не удался, то мы уходим в блок catch и завершаем функцию с пустым результатом и ошибкой
//                completed(nil, "The data received from the server was invalid. Please try again.")
//                completed(nil, .invalidData)
                completed(.failure(.invalidData))
                //второй вариант, как показать ошибку средствами Эппл (т.е. показать ошибку, которая формируется реально). Проблема в том, что эта ошибка может быть трудночитаема для юзера, но полезна для разработчика (поэтому её удобно в принт выводить)
//                completed(nil, error.localizedDescription)
            }
            
        }
        
        //эта строчка кода действительно запускает Network Call, без неё ничего не выйдет, всё что выше - это просто настройка
        task.resume()
    }
}
