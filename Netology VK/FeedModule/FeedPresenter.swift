import Foundation
import UIKit
import VK_ios_sdk

protocol FeedPresenterOutput {
    func setModel(compl: @escaping () -> ())
    func getModel() -> (posts: [Post], attachments: [PostAttachements?], copyHistory: [History?],attachentsImageHeight:[Int?], historyImageHeight: [Int?])
    func addLike(sourceId: Int, itemId: Int)
    func deleteLike(sourceId: Int, itemId: Int)
    func numberOfCells() -> Int
    func toProfileModule(id: Int, from controller: String)
    func isLikedToggle(index: Int)
    func toPostModule(index: Int, register: String)
}

class FeedPresenter: FeedPresenterOutput {
    
    let dataFetcher: GeneralDataFetcher
    var model = [Post]()
    let coordinator: CoordinatorProtocol
    
    init(dataFetcher: GeneralDataFetcher, coordinator: CoordinatorProtocol) {
        self.dataFetcher = dataFetcher
        self.coordinator = coordinator
    }
    
    //Получение модели для модуля. Вызывается во время загрузки модуля и обновления.
    func setModel(compl: @escaping () -> ()) {
        dataFetcher.feedDataFetcher.getNews { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let feed):
                self.model.removeAll()
                let posts = feed.response.items
                let profiles = feed.response.profiles
                let groups = feed.response.groups
                posts.forEach { item in
                    let user = self.profile(for: item.sourceId, profiles: profiles, groups: groups)
                    
                    let post = Post(sourceId: item.sourceId,
                                    postId: item.postId,
                                    autorName: user.name,
                                    postDate: item.date,
                                    autorImage: user.photo50,
                                    postText: PostText(text: item.text),
                                    isLiked: item.likes.userLikes == 1 ? true : false,
                                    likes: item.likes.count,
                                    comments: item.comments.count,
                                    attachements: self.getPhotoForPost(item: item),
                                    copyHistory: self.getHistory(item: item, groups: groups, profiles: profiles))
                    self.model.append(post)
                    compl()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Получение информации об авторе поста/комментария
    private func profile(for sourseId: Int, profiles: [Profiles], groups: [Groups]) -> UserInfo {
        
        let profilesOrGroups: [UserInfo] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresenatable = profilesOrGroups.first { (myProfileRepresenatable) -> Bool in
            myProfileRepresenatable.id == normalSourseId
        }
        return profileRepresenatable!
    }
    
    //Получение фото во вложениях поста
    private func getPhotoForPost(item: FeedItem) -> PostAttachements? {
        guard let photos = item.attachments?.compactMap({ attachmentes in
                return attachmentes.photo
        }), let firstPhoto = photos.first else { return nil }
        return PostAttachements(url: firstPhoto.urlQ, height: firstPhoto.height, width: 0)
    }
    
    //Получение репоста в посте
    private func getHistory(item: FeedItem, groups: [Groups], profiles: [Profiles]) -> History? {
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
        return (model, attachments, copyHistory,attachmentsHeight, historyAttachmentsHeight )
    }
    
    //Поставить лайк
    func addLike(sourceId: Int, itemId: Int) {
        let itemId = String(itemId)
        let sourceId = String(sourceId)
        dataFetcher.feedDataFetcher.addLike(sourceId: sourceId, itemId: itemId, type: "post")
    }
    
    //Удалить лайк
    func deleteLike(sourceId: Int, itemId: Int) {
        let itemId = String(itemId)
        let sourceId = String(sourceId)
        dataFetcher.feedDataFetcher.deleteLike(sourceId: sourceId, itemId: itemId, type: "post")
    }
    
    //Количество ячеек в таблице
    func numberOfCells() -> Int {
        model.count
    }
    
    //Переход на экран выбранного поста
    func toPostModule(index: Int, register: String) {
        print(model[index].sourceId)
        coordinator.openPostDetailModule(from: register, post: model[index])
    }
    
    //Переход на экран профиля пользователя
    func toProfileModule(id: Int, from controller: String) {
        if id > 0 && id != Int(VKSdk.accessToken().userId) {
            coordinator.openProfileModule(id: id, from: controller)
        }
    }
    
    func isLikedToggle(index: Int) {
        switch model[index].isLiked {
        case true:
            model[index].likes -= 1
        case false:
            model[index].likes += 1
        }
        model[index].isLiked.toggle()
    }
}
