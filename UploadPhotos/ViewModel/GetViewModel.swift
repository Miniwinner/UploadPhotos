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
    
    var dataModel:[Model] = []
   
    private let fio:String = "Александр Кузьминов"

    
    func fetchData(complition: @escaping (Welcome) -> Void) {
        getPhotoService.fetchCompany { [weak self] models in
            guard let self = self else { return }

            for content in models.content {
                let model = Model(id: content.id, name: content.name, image: content.image ?? "0")
                self.dataModel.append(model)
            }

            complition(models)
        }
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
