//
//  GetModel.swift
//  UploadPhotos
//
//  Created by Александр Кузьминов on 24.09.23.
//

import Foundation

struct Welcome: Codable {
    let totalPages: Int
    let totalElements: Int
    let content: [Content]
    let page: Int
    let pageSize: Int
}
struct Content: Codable {
    let id: Int
    let name: String
    let image: String?
}
