import Foundation

protocol PhotoDetailViewInput {
    func setModel(completion: @escaping () -> Void)
    func getModel() -> PhotosDetailModel
    func numberOfRows() -> Int
}

class PhotosDetailPresenter: PhotoDetailViewInput {
    
    var model = PhotosDetailModel()
    let dataFetcher: GeneralDataFetcher
    let coordinator: CoordinatorProtocol
    let id: Int
    
    init(dataFetcher: GeneralDataFetcher, coordinator: CoordinatorProtocol, id: Int) {
        self.dataFetcher = dataFetcher
        self.coordinator = coordinator
        self.id = id
    }
    
    //Получает данные для модели
    func setModel(completion: @escaping () -> Void) {
        dataFetcher.userDataFetcher.getUserAlbums(userId: String(describing: id)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                let albums = success.response.items.map { item in
                    Album(photo: item.urlM)
                }
                self.model.albums = albums
            case .failure(let failure):
                print(failure)
            }
        }
        dataFetcher.userDataFetcher.getUserPhotos(userId: String(describing: id)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let photos):
                let photos = photos.response.items.map({Photos(photo: $0.urlM)})
                self.model.photos = photos
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Возвращает модель
    func getModel() -> PhotosDetailModel {
        model
    }
    
    func numberOfRows() -> Int {
        guard model.photos != nil else { return 0 }
        return 1
    }
}
