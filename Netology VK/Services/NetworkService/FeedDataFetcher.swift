import Foundation

class FeedDataFetcher: DataFetcher {
    
    let network = NetworkService()
    
    func getNews(completion: @escaping (Result<FeedResponseWrapped, Error>) -> Void) {
        network.getData(path: "/method/newsfeed.get", items: ["filters":"post,photos"]) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
            completion(.failure(error!))
            }
            guard let data = data else {
            return
            }
            if let decoded = self.jsonDecoded(type: FeedResponseWrapped.self, data: data) {
            completion(.success(decoded))
            }
        }
    }
    
    func addLike(sourceId: String, itemId: String) {
        network.getData(path: "/method/likes.add", items: ["type" : "post", "item_id" : itemId, "owner_id": sourceId]) { data, error in
        }
    }
    
    func deleteLike(sourceId: String, itemId: String) {
        network.getData(path: "/method/likes.delete", items: ["type" : "post", "item_id" : itemId, "owner_id": sourceId]) { data, error in
        }
    }
    
}

/*
 if let url = URL(string: "https://api.vk.com/method/likes.add?type=post&access_token=vk1.a.bnCxKgnXNGizSqpx-0bN2MocWO-mn_PFEAQVUXMltivJ-10gQvysFNDPCQ9aVVsrzRNdAM4DjLoY07RyB8CJuu2ONXh-K-8J_wzxOMA76BgVHp4195WNWI7w4RNgbCe5bW00MCY6Dgk_Bv-8mfW6b7MHHngFaUd8eam9iwnQjBQsgYYH7khoEsz1rfacqPsO-RotmW5WsjIBDMiJs_-Pog&v=5.131&item_id=41") {
     let session = URLSession.shared.dataTask(with: url) { data, _, error in
         do {
         let json = try JSONSerialization.jsonObject(with: data!)
         print(json)
         } catch {
             print(error)
         }
     }
     session.resume()
 }
}
 */
