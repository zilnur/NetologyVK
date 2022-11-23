import Foundation

struct FeedResponseWrapped: Codable {
    let response: FeedResponse
}

struct FeedResponse: Codable {
    var items: [FeedItem]
    var groups: [Groups]
    var profiles: [Profiles]
}

struct FeedItem: Codable {
    let sourceId: Int
    let postId: Int
    let text: String
    let date: Int
    let copyHistory: [CopyHistory]?
    let attachments: [Attachmentes]?
    let likes: Likes
    let comments: Comments
}

struct CopyHistory: Codable {
    let fromId: Int
    let text: String
    let attachments: [Attachmentes]?
}

struct Likes: Codable {
    let userLikes: Int
    let count: Int
}

struct Comments: Codable {
    let count: Int
}

struct Attachmentes: Codable {
    let type: String
    let photo: Photo?
}

struct Photo: Codable {
    let sizes: [Size]
    var height: Int {return getUrl().height}
    var width: Int {return getUrl().width}
    var url: String {return getUrl().url}
    private func getUrl() -> Size {
        if let sizeX = sizes.first(where: { $0.type == "q" }) {
                    return sizeX
                } else if let fallBackSize = sizes.last {
                     return fallBackSize
                } else {
                    return Size(url: "wrong image", type: "wrong image", height: 0, width: 0)
                }
    }
}

struct Size: Codable {
    let url: String
    let type: String
    let height: Int
    let width: Int
}

protocol UserInfo {
    var id: Int { get }
    var name: String { get }
    var photo50: String { get }
}

struct Groups: Codable, UserInfo {
    let id: Int
    let name: String
    let photo50: String
}

struct Profiles: Codable, UserInfo {
    let id: Int
    let photo50: String
    let firstName: String
    let lastName: String
    var name: String  {return firstName + " " + lastName}
}
