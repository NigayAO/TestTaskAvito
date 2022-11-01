//
//  NetworkManager.swift
//  TestTaskAvito
//
//  Created by Alik Nigay on 26.10.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let cacheManager = CacheManager.shared
    
    private let baseURL = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    
    private let decoder = JSONDecoder()
        
    private init() {}
    
    func fetchingData(completion: @escaping (Result<Avito, Error>) -> Void) {
        let date = Date()
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        cacheManager.countdownBeforeRemoveCache(date, url)
        
        if let validData = cacheManager.getDataFromCache(for: url) {
            decodeData(validData, type: Avito.self, completion: completion)
        }
        
        getDataAndResponse(for: url, completion: completion)
    }
    
    private func getDataAndResponse(for url: URL, completion: @escaping (Result<Avito, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data, let response = response else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            self.cacheManager.saveDataToCache(with: data, and: response)
            
            self.decodeData(data, type: Avito.self, completion: completion)

        }.resume()
    }
    
    private func decodeData<T: Decodable>(_ data: Data, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let descriptionData = try decoder.decode(type, from: data)
            DispatchQueue.main.async {
                completion(.success(descriptionData))
            }
        } catch {
            completion(.failure(NetworkError.decodingError))
        }
    }
}
