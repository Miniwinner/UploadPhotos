//
//  GetViewModel.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import Foundation

final class GetViewModel:ViewModelProtocol{
    private let getPhotoService = GetPhotosService()
    private let uploadPhotoService = UploadPhotosService()
    var fio: String = "Александр Кузьминов"
    
    var isLoading = false
    var hasMoreData = true
    private var itemsPerPage = 0
    private var currentPage = 1
    var dataModel = [Model]()
    
    func fetchData(completion: @escaping (Result<[Model], Error>) -> Void) {
        guard !isLoading && hasMoreData else { return }
        isLoading = true
        getPhotoService.fetchPhotos(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            defer { self.isLoading = false }
            switch result {
            case .success(let welcome):
                guard !welcome.content.isEmpty else {
                    self.hasMoreData = false
                    completion(.failure(URLError(.dataNotAllowed)))
                    return
                }
                self.itemsPerPage = welcome.content.count
                let newModels = welcome.content.map { Model(id: $0.id, name: $0.name, image: $0.image ?? "0") }
                self.dataModel.append(contentsOf: newModels)
                completion(.success(self.dataModel))
                self.currentPage += 1
            case .failure(let error):
                self.hasMoreData = false
                completion(.failure(error))
            }
        }
    }
    func countOFitems() -> Int {
        return itemsPerPage
    }
    func resetPageNum(){
        currentPage = 1
    }
    func upload(imageData:Data,id:Int){
        uploadPhotoService.sendImageToServer(imageData: imageData, fio: fio, id: id)
    }
    func numberOfRows() -> Int {
        return dataModel.count
    }
    func getCats(index: Int) -> Model {
        return dataModel[index]
    }
}
