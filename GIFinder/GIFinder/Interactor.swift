//
//  Interactor.swift
//  GIFinder
//
//  Created by Sam Finston on 7/11/22.
//

import Foundation

// handles all interactions with the server
final class Interactor {
    struct Constants {
        static func url(limit: Int, query: String) -> URL? {
            URL(string: "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=\(limit)&offset=0&rating=G&lang=en&q=\(query)")
        }
    }
    
    public init() {}
    
    // Grabs search results from the Giphy endpoint
    public func fetchGifs(query: String, limit: Int = 25, completion: @escaping (Result<GiphyResponse, Error>) -> Void) {
        // Format url
        let validCharacters = NSMutableCharacterSet.alphanumeric() as CharacterSet
        var updatedQuery = query.addingPercentEncoding(withAllowedCharacters: validCharacters) ?? query
        updatedQuery = updatedQuery.replacingOccurrences(of: " ", with: "-")
        
        guard let url = Constants.url(limit: limit, query: updatedQuery) else {
            return
        }
        
        // Make server request
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(GiphyResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
