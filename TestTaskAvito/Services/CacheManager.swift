//
//  CacheManager.swift
//  TestTaskAvito
//
//  Created by Alik Nigay on 29.10.2022.
//

import Foundation

class CacheManager {
    
    static let shared = CacheManager()
    
    private let key = "time"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func saveDataToCache(with data: Data, and response: URLResponse) {
        let date = Date()
        saveDate(date)
        guard let url = response.url else { return }
        
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    func getDataFromCache(for url: URL) -> Data? {
        let request = URLRequest(url: url)
        
        guard let cacheResponse = URLCache.shared.cachedResponse(for: request) else { return nil }
        
        return cacheResponse.data
    }
    
    func countdownBeforeRemoveCache(_ secondDate: Date, _ url: URL) {
        guard let firstDate = getData() else { return }

        let calendar = Calendar.current
        let hoursBetweenDates = calendar.dateComponents([.second], from: firstDate, to: secondDate)
        
        guard let value = hoursBetweenDates.second else { return }
        
        if value >= 3600 {
            removeCache(url)
        }
    }
    
    private func saveDate(_ date: Date) {
        userDefaults.set(date, forKey: key)
    }
    
    private func getData() -> Date? {
        userDefaults.object(forKey: key) as? Date
    }
    
    private func removeCache(_ url: URL) {
        let request = URLRequest(url: url)
        URLCache.shared.removeCachedResponse(for: request)
        userDefaults.removeObject(forKey: key)
    }
}
