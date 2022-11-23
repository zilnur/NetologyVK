import Foundation
import VK_ios_sdk

final class NetworkService {
    
    //Запрос в сеть
    func makeRequest(path: String, items: [String: String],completion: @escaping (Data?, Error?) -> Void) {
        let task = self.sessionDataTask(path: path, queryItems: items, completion: completion)
        task.resume()
    }
    
    //Сбор URL
    func url(path: String, queryItems: [String:String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = path
        components.queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    //Возвращает sessionDataTask с нужным url
    func sessionDataTask(path: String, queryItems: [String: String], completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        
        var items = queryItems
        items["access_token"] = VKSdk.accessToken().accessToken
        print(VKSdk.accessToken().accessToken as String)
        items["v"] = "5.131"
        let url = url(path: path, queryItems: items)
        print(url.description)
        let request = URLRequest(url: url)
        return URLSession.shared.dataTask(with: request) { data, _, error in
            completion(data, error)
        }
    }
}


