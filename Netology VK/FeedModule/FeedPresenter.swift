import Foundation
import UIKit

protocol FeedPresenterOutput {
    func setModel()
    func setTable(for cell: PostTableViewCell, in indexPath: IndexPath)
    func numberOfCells() -> Int
}

class FeedPresenter {
    
    let network = NetworkDataFetcher()
    
    var model = [Post]()
    //    let coordinator: Coordinator
    
    init() {
        //        self.coordinator = coordinator
    }
    
    func setModel(compl: @escaping () -> ()) {
        network.getNews { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let feed):
                self.model.removeAll()
                let posts = feed.response.items
                let profiles = feed.response.profiles
                let groups = feed.response.groups
                posts.forEach { item in
                    let user = self.profile(for: item.sourceId, profiles: profiles, groups: groups)
                    
                    let post = Post(shorts: nil,
                                    sourceId: item.sourceId.signum() == 1 ? item.sourceId : -item.sourceId,
                                    postId: item.postId,
                                    autorName: user.name,
                                    postDate: item.date,
                                    autorImage: user.photo50,
                                    postDescription: item.text,
                                    postImage: self.getPhotoForPost(item: item)?.url,
                                    imageHeight: self.getPhotoForPost(item: item)?.height,
                                    isLiked: item.likes.userLikes == 1 ? true : false,
                                    likes: item.likes.count,
                                    comments: item.comments.count,
                                    attachements: self.getPhotoForPost(item: item),
                                    copyHistory: self.getHistory(item: item, groups: groups, profiles: profiles))
                    self.model.append(post)
                }
            case .failure(let error):
                print(error)
            }
            compl()
        }
    }
    
    private func profile(for sourseId: Int, profiles: [Profiles], groups: [Groups]) -> UserInfo {
        
        let profilesOrGroups: [UserInfo] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresenatable = profilesOrGroups.first { (myProfileRepresenatable) -> Bool in
            myProfileRepresenatable.id == normalSourseId
        }
        return profileRepresenatable!
    }
    
    private func getPhotoForPost(item: FeedItem) -> PostAttachements? {
        guard let photos = item.attachments?.compactMap({ attachmentes in
                return attachmentes.photo
        }), let firstPhoto = photos.first else { return nil }
        return PostAttachements(url: firstPhoto.url, height: firstPhoto.height, width: 0)
    }
    
    private func getHistory(item: FeedItem, groups: [Groups], profiles: [Profiles]) -> History? {
        guard let histories = item.copyHistory,
              let history = histories.first else { return nil }
        if let photos = history.attachments?.compactMap({ attachments in
            return attachments.photo
        }),
           let firstPhoto = photos.first {
            let attachments = PostAttachements(url: firstPhoto.url, height: firstPhoto.height, width: firstPhoto.width)
            let user = profile(for: history.fromId, profiles: profiles, groups: groups)
            return History(name: user.name,
                           avatarImage: user.photo50,
                           text: history.text,
                           attachments: attachments)
            
        } else {
        let user = profile(for: history.fromId, profiles: profiles, groups: groups)
        return History(name: user.name,
                       avatarImage: user.photo50,
                       text: history.text,
                       attachments: nil)
        }
    }
    
    //Предает модель
    func getModel() -> (posts: [Post], attachments: [PostAttachements?], copyHistory: [History?],attachentsImageHeight:[Int?], historyImageHeight: [Int?]) {
        var attachments = [PostAttachements?]()
        var copyHistory = [History?]()
        var attachmentsHeight = [Int?]()
        var historyAttachmentsHeight = [Int?]()
        model.forEach { post in
            attachments.append(post.attachements)
            copyHistory.append(post.copyHistory)
            attachmentsHeight.append(post.attachements?.height)
            historyAttachmentsHeight.append(post.copyHistory?.attachments?.height)
        }
        print(attachmentsHeight)
        return (model, attachments, copyHistory,attachmentsHeight, historyAttachmentsHeight )
    }
    
    func addLike(sourceId: Int, itemId: Int) {
        let itemId = String(itemId)
        let sourceId = String(sourceId)
        network.addLike(sourceId: sourceId, itemId: itemId)
    }
    
    func deleteLike(sourceId: Int, itemId: Int) {
        let itemId = String(itemId)
        let sourceId = String(sourceId)
        network.deleteLike(sourceId: sourceId, itemId: itemId)
    }
    
    func numberOfCells() -> Int {
        model.count
    }
}
