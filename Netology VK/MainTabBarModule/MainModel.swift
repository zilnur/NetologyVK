import Foundation
import UIKit

struct MainModel {
    let name: String
    let secondName: String?
    let birthday: Int
    let avatar: String
    let city: String
    let genderIsMale: Bool
    let posts: [Post]
    let likedPost: [Post]
}
