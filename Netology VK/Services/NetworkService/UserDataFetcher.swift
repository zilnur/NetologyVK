import Foundation

class UserDataFetcher: DataFetcher {
    
    //Получает информацию по пользователю
    func getUser(userid: String,completion: @escaping (Result<UserResponse, Error>) -> Void) {
        network.makeRequest(path: "/method/users.get", items: ["fields": "photo_50,bdate,sex,activities,city", "user_ids": userid]) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
                completion(.failure(error!))
            }
            guard let data else { return }
            if let user = self.jsonDecoded(type: UserResponse.self, data: data) {
                completion(.success(user))
            }
        }
    }
    
    //Получает количество подписок пользователя
    func getUserSubscriptions(userId: String, completion: @escaping (Result<UserSubscriptions, Error>) -> Void) {
        network.makeRequest(path: "/method/users.getSubscriptions", items: ["userId": userId, "extended":"1"]) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
                completion(.failure(error!))
            }
            guard let data else { return }
            if let subscriptions = self.jsonDecoded(type: UserSubscriptions.self, data: data) {
                completion(.success(subscriptions))
            }
        }
    }
    
    //Получает количество подписчиков пользователя
    func getUserFollowers(userId: String, completion: @escaping (Result<UserFollowers, Error>) -> Void) {
        network.makeRequest(path: "/method/users.getFollowers", items: ["userId": userId]) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
                completion(.failure(error!))
            }
            guard let data else { return }
            if let followers = self.jsonDecoded(type: UserFollowers.self, data: data) {
                completion(.success(followers))
            }
        }
    }
    
    //Получает фотографии пользователя
    func getUserPhotos(userId: String, completion: @escaping (Result<UserPhotos, Error>) -> Void) {
        print(userId)
        network.makeRequest(path: "/method/photos.getAll", items: ["owner_id": userId]) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
                completion(.failure(error!))
            }
            guard let data else { return }
            if let photos = self.jsonDecoded(type: UserPhotos.self, data: data) {
                print(photos)
                completion(.success(photos))
            }
        }
    }
    
    //Получает альбомы пользователя
    func getUserAlbums(userId: String, completion: @escaping (Result<AlbumsResponseWrapped, Error>) -> Void) {
        network.makeRequest(path: "/method/photos.getAlbums", items: ["owner_id":userId, "need_system":"1", "need_covers":"1", "photo_sizes":"1"]) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
                completion(.failure(error!))
            }
            guard let data else { return }
            if let albums = self.jsonDecoded(type: AlbumsResponseWrapped.self, data: data) {
                completion(.success(albums))
            }
        }
    }
    
    //Получает посты на стене пользователя
    func getUserPosts(userId: String, completion: @escaping (Result<UserPosts, Error>) -> Void) {
        network.makeRequest(path: "/method/wall.get", items: ["owner_id": userId, "extended":"1"]) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
                completion(.failure(error!))
            }
            guard let data else { return }
            if let followers = self.jsonDecoded(type: UserPosts.self, data: data) {
                completion(.success(followers))
            }
        }
    }
}
