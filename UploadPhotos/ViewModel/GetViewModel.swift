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
    private var isLoading = false
    private var currentPage = 1
    private var stopFetching = false
    var dataModel = [Model]()

    func fetchData(completion: @escaping (Result<[Model], Error>) -> Void) {
        guard !isLoading && !stopFetching else { return }
        isLoading = true
        getPhotoService.fetchPhotos(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            defer { self.isLoading = false }
            switch result {
            case .success(let welcome):
                guard !welcome.content.isEmpty else {
                    self.stopFetching = true
                    completion(.failure(URLError(.dataNotAllowed)))
                    return
                }
                let newModels = welcome.content.map { Model(id: $0.id, name: $0.name, image: $0.image ?? "0") }
                if self.currentPage == 1 {
                    self.dataModel = newModels
                } else {
                    self.dataModel.append(contentsOf: newModels)
                }
                completion(.success(self.dataModel))
                self.currentPage += 1

            case .failure(let error):
                self.stopFetching = true
                completion(.failure(error))
            }
        }
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
