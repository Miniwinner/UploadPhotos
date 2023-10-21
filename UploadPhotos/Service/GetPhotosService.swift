//
//  GetPhotosService.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import Foundation


class GetPhotosService{
    
    func fetchCompany(page:Int,complitions: @escaping (Welcome) -> Void) {
        guard let urlCompany = URL(string: "https://junior.balinasoft.com/api/v2/photo/type?page=\(page)") else { return }
        
        let requestCompany = URLRequest(url: urlCompany)
        
        URLSession.shared.dataTask(with: requestCompany) { data, respone, error in
            guard let data = data else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let company = self.parseJson(type: Welcome.self, data: data) else { return }
            complitions(company)
        }.resume()
    }
    
    func parseJson<T: Codable>(type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(T.self, from: data)
        return model
    }
}
