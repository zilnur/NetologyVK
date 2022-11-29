import Foundation

struct AlbumsResponseWrapped: Codable {
    let response: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Photo]
}

struct UserPhotos: Codable {
    let response: PhotoResponce
}

struct PhotoResponce: Codable {
    let count: Int
    let items: [AlbumPhoto]
}

struct AlbumPhoto: Codable {
    let sizes: [Size]
    var height: Int {return getUrl("q").height}
    var width: Int {return getUrl("q").width}
    var urlQ: String {return getUrl("q").url}
    var urlS: String {return getUrl("s").url}
    var urlM: String {return getUrl("m").url}
    private func getUrl(_ type: String) -> Size {
        if let sizeX = sizes.first(where: { $0.type == type }) {
                    return sizeX
                } else if let fallBackSize = sizes.last {
                     return fallBackSize
                } else {
                    return Size(url: "wrong image", type: "wrong image", height: 0, width: 0)
                }
    }
}
