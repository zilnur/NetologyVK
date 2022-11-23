import Foundation
import VK_ios_sdk

protocol PostDetailViewInput {
    func setPostComments(completion: @escaping () -> Void)
    func getModel() -> PostDetailModel
    func createNewComment(message: String)
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
    
    func setPostComments(completion: @escaping () -> Void) {
        let ownerId = model.post.sourceId > 0 ? String(describing: model.post.sourceId) : String(describing: -model.post.sourceId)
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
                    let thread = [Comment]()
                    let comment = Comment(autorAvatar: user.photo50,
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
            }
        }
    }
    
    func getModel() -> PostDetailModel {
        model
    }
    
    func createNewComment(message: String) {
        let ownerId = model.post.sourceId > 0 ? model.post.sourceId : -model.post.sourceId
        let date = Date()
        let timeInterval = date.timeIntervalSince1970
        dataFetcher.feedDataFetcher.createComments(postId: String(describing: model.post.postId), ownerId: String(describing: ownerId), message: message) { [weak self] in
            guard let self else { return }
            self.dataFetcher.userDataFetcher.getUser(userid: VKSdk.accessToken().userId) { result in
                switch result {
                case .success(let user):
                    let comment = Comment(autorAvatar: user.response[0].photo50,
                                          autorName: user.response[0].name,
                                          text: message,
                                          date: Int(timeInterval),
                                          likes: 0,
                                          isLiked: false)
                    self.model.comments?.append(comment)
                    self.model.post.comments += 1
                    DispatchQueue.main.async {
                        self.view.reloadTable()
                    }
                    
                case .failure(_):
                    break
                }
            }
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
}
