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
    var dataModel: [Model] = []
    var fio: String = "Александр Кузьминов"
    private var isLoading: Bool = false
    private var currentPage: Int = 1
    private var stopFetching: Bool = false
    func fetchData(completions: @escaping (Welcome?) -> Void) {
        if isLoading || stopFetching {
            return
        }
        isLoading = true
        getPhotoService.fetchCompany(page: currentPage) { [weak self] models in
            guard let self = self else { return }
            if let models = models {
                if models.content.isEmpty {
                    completions(nil)
                    self.isLoading = false
                    self.stopFetching = true
                } else {
                    let newModels = models.content.map { content in
                        return Model(id: content.id, name: content.name, image: content.image ?? "0")
                    }
                    if self.currentPage == 0 {
                        self.dataModel = newModels
                    } else {
                        self.dataModel.append(contentsOf: newModels)
                    }
                    completions(models)
                    self.currentPage += 1
                    self.isLoading = false
                }
            } else {
                completions(nil)
                self.isLoading = false
                self.stopFetching = true
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
