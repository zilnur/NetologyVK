import Foundation
import VK_ios_sdk

protocol PostDetailViewInput {
    func setPostComments(completion: @escaping () -> Void)
    func getModel() -> PostDetailModel
    func createNewComment(message: String)
    func addLike(sourceId: String, itemId: String, type: String)
    func deleteLike(sourceId: String, itemId: String, type: String)
}

protocol PostDetailViewOutput {
    func reloadTable()
}

class PostDetailPresenter: PostDetailViewInput {
    
    var model: PostDetailModel
    let dataFetcher: GeneralDataFetcher
    let view: PostDetailViewOutput
    
    init(post: Post, dataFetcher: GeneralDataFetcher, view: PostDetailViewOutput) {
        let _model = PostDetailModel(post: post)
        self.model = _model
        self.dataFetcher = dataFetcher
        self.view = view
    }
    
    //Получает из сети данные для модели
    func setPostComments(completion: @escaping () -> Void) {
        let ownerId = String(describing: model.post.sourceId)
        dataFetcher.feedDataFetcher.getComments(postId: String(describing: model.post.postId), ownerid: ownerId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                let profiles = response.response.profiles
                let groups = response.response.groups
                let items = response.response.items
                var _comments = [Comment]()
                items.forEach { item in
                    let user = self.profile(for: item.fromId, profiles: profiles, groups: groups)
                    let comment = Comment(id: item.id,
                                          autorId: item.fromId,
                                          autorAvatar: user.photo50,
                                          autorName: user.name,
                                          text: item.text,
                                          date: item.date,
                                          likes: item.likes.count,
                                          isLiked: item.likes.userLikes == 1 ? true : false)
                    _comments.append(comment)
                }
                self.model.comments = _comments
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    //Передает модель
    func getModel() -> PostDetailModel {
        model
    }
    
    //поставить лайе
    func addLike(sourceId: String, itemId: String, type: String) {
        dataFetcher.feedDataFetcher.addLike(sourceId: sourceId, itemId: itemId, type: type)
    }
    
    //Удалить лайк
    func deleteLike(sourceId: String, itemId: String, type: String) {
        dataFetcher.feedDataFetcher.deleteLike(sourceId: sourceId, itemId: itemId,type: type)
    }
    
    //Создать комментарий
    func createNewComment(message: String) {
        let ownerId = model.post.sourceId > 0 ? model.post.sourceId : -model.post.sourceId
        let date = Date()
        dataFetcher.feedDataFetcher.createComments(postId: String(describing: model.post.postId), ownerId: String(describing: ownerId), message: message) { [weak self] in
            guard let self else { return }
            self.setPostComments {
                DispatchQueue.main.async {
                    self.view.reloadTable()
                    self.model.post.comments += 1
                }
            }
        }
        
    }
    
    //Возвращает информацию об авторе комментария
    private func profile(for sourseId: Int, profiles: [Profiles], groups: [Groups]) -> UserInfo {
        
        let profilesOrGroups: [UserInfo] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresenatable = profilesOrGroups.first { (myProfileRepresenatable) -> Bool in
            myProfileRepresenatable.id == normalSourseId
        }
        return profileRepresenatable!
    }
}
