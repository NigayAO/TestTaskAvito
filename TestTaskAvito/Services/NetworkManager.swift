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
    case descriptionError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let urlAddress = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    
    private init() {}
    
    func fetchData(completion: @escaping (Result<Avito, NetworkError>) -> Void) {
        guard let url = URL(string: urlAddress) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
                        
            do {
                let receivedData = try JSONDecoder().decode(Avito.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(receivedData))
                }
                
            } catch {
                completion(.failure(.descriptionError))
                print(error.localizedDescription)
            }
        }.resume()
    }
}
