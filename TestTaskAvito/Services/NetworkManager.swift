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
    
    private let baseURL = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        
    private init() {}
    
    func fetchingData(completion: @escaping (Avito) -> Void) {
        guard let url = URL(string: baseURL) else {
            print(NetworkError.invalidURL)
            return
        }
        
        if let validData = getDataFromCache(for: url) {
            completion(validData)
            return
        }
        
        getDataAndResponse(for: url, completion: completion)
    }
    
    private func getDataAndResponse(for url: URL, completion: @escaping (Avito) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error with data - \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let response = response else {
                print("Error with handling data - \(NetworkError.noData)")
                return
            }
            self.saveDataToCache(with: data, and: response)
            guard let decodingData = self.decodeData(Avito.self, data) else { return }
            DispatchQueue.main.async {
                completion(decodingData)
            }
        }.resume()
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getDataFromCache(for url: URL) -> Avito? {
        let request = URLRequest(url: url)
        
        guard
            let cacheResponse = URLCache.shared.cachedResponse(for: request),
            let decodingData = decodeData(Avito.self, cacheResponse.data)
        else  {
            return nil
        }
        return decodingData
    }
    
    func removeCache() {
        guard let url = URL(string: baseURL) else { return }
        let request = URLRequest(url: url)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3600) {
            URLCache.shared.removeCachedResponse(for: request)
        }
    }
    
    private func decodeData<T: Codable>(_ type: T.Type, _ data: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let descriptionData = try decoder.decode(type, from: data)
            return descriptionData
        } catch {
            print("Description Error - ", error.localizedDescription)
            return nil
        }
    }
}
