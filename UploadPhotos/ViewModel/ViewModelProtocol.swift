//
//  ViewModelPtocolos.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import Foundation

protocol ViewModelProtocol{
    
    var dataModel: [Model] { get set }
    var fio:String { get set }
    
    func fetchData(completions: @escaping (Welcome?) -> Void)
    
    func upload(imageData:Data,id:Int)
    
    func numberOfRows() -> Int
    
    func getCats(index: Int) -> Model
    
    func resetPageNum()
    
}
