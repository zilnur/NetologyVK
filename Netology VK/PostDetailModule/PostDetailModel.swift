import Foundation

struct PostDetailModel {
    var post: Post
    var comments: [Comment]?
}

struct Comment {
    let id: Int
    let autorId: Int
    let autorAvatar: String
    let autorName: String
    let text: String
    let date: Int
    let likes: Int
    let isLiked: Bool
    var thread: [Comment]?
}
