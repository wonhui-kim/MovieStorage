//
//  APICaller.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/24.
//

import Foundation

struct Constants {
    static let apiKey = "92e32667"
    static let baseURL = "https://www.omdbapi.com"
}

class APICaller {
    
    static let shared = APICaller()

    func search(with query: String, completion: @escaping (Result<MovieResponse, Error>) -> Void) {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        // http://www.omdbapi.com/?apikey=92e32667&s=iron%20man&page=2
        //TODO: page 추가 필요 default: page=1
        guard let url = URL(string: "\(Constants.baseURL)/?apikey=\(Constants.apiKey)&s=\(query)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

