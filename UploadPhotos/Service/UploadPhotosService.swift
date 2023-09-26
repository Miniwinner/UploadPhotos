//
//  UploadPhotosService.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import Foundation

class UploadPhotosService{
    
    func sendImageToServer(imageData: Data, fio: String, id: Int) {
        print("sent")
        guard let url = URL(string: "https://junior.balinasoft.com/api/v2/photo") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = ["image": imageData.base64EncodedString(), "fio": fio, "id": id]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let jsonResponse = jsonResponse {
                        if let message = jsonResponse["message"] as? String {
                            print("Server response: \(message)")
                        }
                        
                    }
                } catch {
                    print("\(error)")
                }
            }
            
        }
        
        task.resume()
    }
}
