import Foundation

struct Profile {
    let id: Int
    let firstName: String
    let lastName: String
    let sexIsMale: Bool
    let photo: String
    let birthday: String
    var subscritionsCount: Int?
    var followersCount: Int?
    var photos: [String]?
    var posts: [Post]?
}
