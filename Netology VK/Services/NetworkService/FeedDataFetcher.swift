import Foundation

class FeedDataFetcher: DataFetcher {
    
    //Получает ленту новостей текущего пользователя
    func getNews(completion: @escaping (Result<FeedResponseWrapped, Error>) -> Void) {
        network.makeRequest(path: "/method/newsfeed.get", items: ["filters":"post,photos"]) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
            completion(.failure(error!))
            }
            guard let data = data else {
            return
            }
            if let decoded = self.jsonDecoded(type: FeedResponseWrapped.self, data: data) {
            completion(.success(decoded))
            } else {
                completion(.failure(MyErrors.jsonFailed))
            }
        }
    }
    
    //Ставит лайк
    func addLike(sourceId: String, itemId: String, type: String) {
        network.makeRequest(path: "/method/likes.add", items: ["type" : type, "item_id" : itemId, "owner_id": sourceId]) { data, error in
        }
    }
    
    //Удаляет лайк
    func deleteLike(sourceId: String, itemId: String, type: String) {
        network.makeRequest(path: "/method/likes.delete", items: ["type" : type, "item_id" : itemId, "owner_id": sourceId]) { data, error in
        }
    }
    
    //Получает комментарии
    func getComments(postId: String, ownerid: String, completion: @escaping (Result<CommentsWrapped,Error>) -> Void) {
        network.makeRequest(path: "/method/wall.getComments", items: ["post_id":postId, "owner_id":ownerid, "need_likes":"1", "extended":"1","fields":"photo_50"]) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
            completion(.failure(error!))
            }
            guard let data = data else {
            return
            }
            if let decoded = self.jsonDecoded(type: CommentsWrapped.self, data: data) {
            completion(.success(decoded))
            } else {
                completion(.failure(MyErrors.jsonFailed))
            }
        }
    }
    
    //Создает комментарий
    func createComments(postId: String, ownerId: String, message: String, completion: @escaping () -> Void) {
        network.makeRequest(path: "/method/wall.createComment", items: ["owner_id":ownerId,"post_id":postId,"message":message]) { data, error in
            if error == nil {
                completion()
            } else {
                print(error!)
            }
        }
    }
    
}
