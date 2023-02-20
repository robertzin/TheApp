//
//  NetworkManager.swift
//  theApp
//
//  Created by Robert Zinyatullin on 18.02.2023.
//

import Foundation
import UIKit
import Network

protocol NetworkManagerProtocol: AnyObject {
    func getNews(url: String, completion: @escaping (Result<[ArticleResponseObject]?, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    enum NetworkError: Error {
        case wrongURL
        case responseStatus
    }
    
    static var shared = NetworkManager()
    
    private init() {}
    
    func getNews(url: String, completion: @escaping (Result<[ArticleResponseObject]?, Error>) -> Void) {
        
        var components = URLComponents(string: url)
        let apiKey = Constants.apiKey
        components?.queryItems = []
        components?.queryItems?.append(URLQueryItem(name: "country", value: "us"))
        components?.queryItems?.append(URLQueryItem(name: "apiKey", value: apiKey))
        
        guard let url = components?.url else {
            completion(.failure(NetworkError.wrongURL))
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    do {
                        let newsResponse = try JSONDecoder().decode(NewsResponseObject.self, from: data)
                        completion(.success(newsResponse.articles))
                    } catch {
                        completion(.failure(error))
                        debugPrint("parisng error!")
                    }
                default:
                    debugPrint("response status: \(response.statusCode)")
                    completion(.failure(NetworkError.responseStatus))
                }
            }
        }.resume()
    }
}
