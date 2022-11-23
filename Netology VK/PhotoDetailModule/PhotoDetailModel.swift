import Foundation

struct PhotosDetailModel {
    var albums: [Album]?
    var photos: [Photos]?
}

struct Album {
    let photo: String
}

struct Photos {
    let photo: String
}
