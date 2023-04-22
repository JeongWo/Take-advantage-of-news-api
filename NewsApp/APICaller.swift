//
//  APICaller.swift
//  NewsApp
//
//  Created by 김정우 on 2023/04/22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        
    static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2023-03-22&sortBy=publishedAt&apiKey=2fcd3d65e7ff450a80ccb3699acec01b")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    
                    do{
                        let result = try JSONDecoder().decode(APIResponse.self, from: data)
                        
                        print("Articles: \(result.articles.count)")
                        completion(.success(result.articles))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
            }
    task.resume()
    }
}

// Models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    
}

struct Source: Codable {
    let name: String
}
