//
//  GetViewModel.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import Foundation

class GetViewModel:ViewModelProtocol{
    
    private let getPhotoService = GetPhotosService()
    private let uploadPhotoService = UploadPhotosService()
    
    private var isLoading: Bool = false
    
    var dataModel:[Model] = []
    var fio:String = "Александр Кузьминов"
    
    private var currentPage:Int = 1


    
    func fetchData(completions: @escaping (Welcome) -> Void) {
        
        guard !isLoading, currentPage <= 6 else { return }
           isLoading = true
        
        getPhotoService.fetchCompany(page: currentPage) { [weak self] models in
            guard let self = self else { return }

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
