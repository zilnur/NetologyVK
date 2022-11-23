import Foundation
import UIKit

protocol ProfileViewInput {
    func setModel(completion:  @escaping () -> Void)
    func getModel() -> Profile?
    func numberOfCells() -> Int
    func addlike(sourceId: String, itemId: String)
    func toPostModule(index: Int)
    func toPhotosModule()
    func toProfileModule(id: Int)
    func goBack()
    func deleteLike(sourceId: String, itemId: String)
    func isCurrentUserAccount() -> Bool
}

class ProfilePresenter: ProfileViewInput {
    
    let dataFetcher: GeneralDataFetcher
    var id: Int
    var model: Profile?
    let coordinator: Coordinator
    let authService: VkAuthService
    
    init(id: Int, dataFentcher: GeneralDataFetcher, coordinator: Coordinator, authService: VkAuthService) {
        self.id = id
        self.dataFetcher = dataFentcher
        self.coordinator = coordinator
        self.authService = authService
    }
    
    func setModel(completion:  @escaping () -> Void) {
        if model?.photos != nil {
            model!.photos!.removeAll()
        }
        dataFetcher.userDataFetcher.getUser(userid: String(describing: id)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let users):
                print(users)
                if let user = users.response.first {
                    let model = Profile(id: user.id,
                                        firstName: user.firstName,
                                        lastName: user.lastName,
                                        sexIsMale: user.sex == 1 ? true : false,
                                        photo: user.photo50,
                                        birthday: user.bdate)
                    self.model = model
                }
            case .failure(let error):
                print(error)
            }
        }
        dataFetcher.userDataFetcher.getUserSubscriptions(userId: String(describing: id)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let subs):
                let subsCount = subs.response.count
                self.model?.subscritionsCount = subsCount
            case .failure(let error):
                print(error)
            }
        }
        dataFetcher.userDataFetcher.getUserFollowers(userId: String(describing: id)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let followers):
                let follCount = followers.response.count
                self.model?.followersCount = follCount
            case .failure(let error):
                print(error)
            }
        }
        dataFetcher.userDataFetcher.getUserPhotos(userId: String(describing: id)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let photos):
                let photo = photos.response.items.map({$0.urlS})
                self.model?.photos = photo
            case .failure(let error):
                print(error)
            }
            self.dataFetcher.userDataFetcher.getUserPosts(userId: String(describing: self.id)) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let posts):
                    var _posts: [Post] = []
                    let profiles = posts.response.profiles
                    let groups = posts.response.groups
                    posts.response.items.forEach { item in
                        let user = self.profile(for: item.fromId, profiles: profiles, groups: groups)
                        let post = Post(sourceId: item.fromId,
                                        postId: item.id,
                                        autorName: user.name,
                                        postDate: item.date,
                                        autorImage: user.photo50,
                                        postText: PostText(text: item.text),
                                        isLiked: item.likes.userLikes == 1 ? true : false,
                                        likes: item.likes.count,
                                        comments: item.comments.count,
                                        attachements: self.getPhotoForPost(item: item),
                                        copyHistory: self.getHistory(item: item, groups: groups, profiles: profiles))
                        _posts.append(post)
                    }
                    self.model?.posts = _posts
                    
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    func getModel() -> Profile? {
        model
    }
    
    func numberOfCells() -> Int {
        var count = 0
        if model?.photos != nil {
            count += 1
        }
        if model?.posts != nil {
            count += model!.posts!.count
        }
        return count
    }
    
    func toPostModule(index: Int) {
        guard let posts = model?.posts else { return }
        coordinator.openPostDetailmodule(post: posts[index], from: .profile)
    }
    
    func toPhotosModule() {
        if isCurrentUserAccount() {
            coordinator.openPhotosModule(id: id, from: .profile)
        } else {
            coordinator.openPhotosModule(id: id, from: .feed)
        }
    }
    
    func goBack() {
        if isCurrentUserAccount() {
            coordinator.goToBack(from: .profile)
        } else {
            coordinator.goToBack(from: .feed)
        }
    }
    
    func toProfileModule(id: Int) {
        let _id = id > 0 ? id : -id
        if _id != self.id {
            coordinator.openProfileModule(id: _id, from: .profile)
        }
    }
    
    func addlike(sourceId: String, itemId: String) {
        dataFetcher.feedDataFetcher.addLike(sourceId: sourceId, itemId: itemId, type: "post")
    }
    
    func deleteLike(sourceId: String, itemId: String) {
        dataFetcher.feedDataFetcher.deleteLike(sourceId: sourceId, itemId: itemId, type: "post")
    }
    
    func isCurrentUserAccount() -> Bool {
        id == Int(authService.token!)
    }
}

extension ProfilePresenter {
    
    private func profile(for sourseId: Int, profiles: [Profiles], groups: [Groups]) -> UserInfo {
        
        let profilesOrGroups: [UserInfo] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresenatable = profilesOrGroups.first { (myProfileRepresenatable) -> Bool in
            myProfileRepresenatable.id == normalSourseId
        }
        return profileRepresenatable!
    }
    
    private func getPhotoForPost(item: WallItem) -> PostAttachements? {
        guard let photos = item.attachments?.compactMap({ attachmentes in
            return attachmentes.photo
        }), let firstPhoto = photos.first else { return nil }
        return PostAttachements(url: firstPhoto.urlQ, height: firstPhoto.height, width: 0)
    }
    
    private func getHistory(item: WallItem, groups: [Groups], profiles: [Profiles]) -> History? {
        guard let histories = item.copyHistory,
              let history = histories.first else { return nil }
        if let photos = history.attachments?.compactMap({ attachments in
            return attachments.photo
        }),
           let firstPhoto = photos.first {
            let attachments = PostAttachements(url: firstPhoto.urlQ, height: firstPhoto.height, width: firstPhoto.width)
            let user = profile(for: history.fromId, profiles: profiles, groups: groups)
            return History(name: user.name,
                           avatarImage: user.photo50,
                           text: PostText(text: history.text),
                           attachments: attachments)
            
        } else {
            let user = profile(for: history.fromId, profiles: profiles, groups: groups)
            return History(name: user.name,
                           avatarImage: user.photo50,
                           text: PostText(text: history.text),
                           attachments: nil)
        }
    }
}
