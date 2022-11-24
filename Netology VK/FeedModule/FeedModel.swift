import Foundation
import UIKit

struct FeedModel {
    let posts: [Post]
}

struct Post {
    let sourceId: Int
    let postId: Int
    let autorName: String
    let postDate: Int
    let autorImage: String
    let postText: PostText
    var isLiked: Bool
    var likes: Int
    var comments: Int
    let attachements: PostAttachements?
    let copyHistory: History?
}

struct PostText {
    let text: String
}

struct History {
    let name: String
    let avatarImage: String
    let text: PostText
    var attachments: PostAttachements?
}

struct PostAttachements {
    let url: String
    let height: Int
    let width: Int
}
