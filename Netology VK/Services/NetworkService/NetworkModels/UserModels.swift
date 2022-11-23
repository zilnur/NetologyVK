import Foundation

struct UserResponse: Codable {
    let response: [User]
}

struct User: Codable, UserInfo {
    var id: Int
    var name: String { return firstName + " " + lastName}
    var photo50: String
    let firstName: String
    let lastName: String
    let sex: Int?
    let activities: String?
    let bdate: String
}

struct UserSubscriptions: Codable {
    let response: Responce
}

struct Responce: Codable {
    let count: Int
}

struct WallResponce: Codable {
    let count: Int
    let items: [WallItem]
    let profiles: [Profiles]
    let groups: [Groups]
}

struct UserFollowers: Codable {
    let response: Responce
}

struct UserPosts: Codable {
    let response: WallResponce
}

struct WallItem: Codable {
    let fromId: Int
    let id: Int
    let text: String
    let date: Int
    let copyHistory: [CopyHistory]?
    let attachments: [Attachmentes]?
    let likes: Likes
    let comments: Comments
}

