import Foundation
import UIKit

struct FeedModel {
    let posts: [Post]
}

struct Comment {
    let autorAvatar: String
    let autorName: String
    let date: Int
    let likes: Int
    let isLiked: Bool
}

struct Post {
    let shorts: [String]?
    let sourceId: Int
    let postId: Int
    let autorName: String
    let postDate: Int
    let autorImage: String
    let postDescription: String
    let postImage: String?
    let imageHeight: Int?
    let isLiked: Bool
    let likes: Int
    let comments: Int
    let attachements: PostAttachements?
    let copyHistory: History?
}

struct History {
    let name: String
    let avatarImage: String
    let text: String
    let attachments: PostAttachements?
}

struct PostAttachements {
    let url: String
    let height: Int
    let width: Int
}
