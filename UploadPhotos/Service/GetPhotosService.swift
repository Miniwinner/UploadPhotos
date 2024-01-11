//
//  GetPhotosService.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import Foundation


class GetPhotosService {
    // MARK: - Public Methods
    public func fetchPhotos(page: Int, completion: @escaping (Result<Welcome, Error>) -> Void) {
        guard let url = URL(string: "https://junior.balinasoft.com/api/v2/photo/type?page=\(page)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.dataNotAllowed)))
                }
                return
            }
            DispatchQueue.main.async {
                self?.decodeJSON(data: data, completion: completion)
            }
        }.resume()
    }
    private func decodeJSON<T: Codable>(data: Data, completion: @escaping (Result<T, Error>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(T.self, from: data)
            completion(.success(model))
        } catch {
            completion(.failure(error))
        }
    }
}
