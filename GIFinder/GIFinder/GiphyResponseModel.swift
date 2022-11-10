//
//  GiphyResponseModel.swift
//  GIFinder
//
//  Created by Sam Finston on 7/11/22.
//

import Foundation

struct GiphyResponse: Decodable {
    let data: [Gif]
}

struct Gif: Decodable {
    let title: String
    let url: String
    let images: Images
}

struct Images: Decodable {
    let original: Image
    let downsized: Image
}

struct Image: Decodable {
    let height: String
    let width: String
    let url: String
}
