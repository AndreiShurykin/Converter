//
//  DataManager.swift
//  converter
//
//  Created by Andrei Shurykin on 10.02.22.
//

import Foundation

final class DataManager {
    
    static var shared = DataManager()
    private init() {}
    
    func getCurrencyRate(_ firstCurrency: String?, _ secondCurrency: String?, complition: @escaping((Result<Double,Error>) -> Void)) {
        guard let firstCurrency = firstCurrency else {
            return
        }
        guard let secondCurrency = secondCurrency else {
            return
        }
        let urlString = urlBaseFirst + firstCurrency + urlBaseSecond + secondCurrency + urlBaseThird
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let data = data else {
                      return
                  }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Double]
                guard let rate = dictionary?.first?.value else {
                    return
                }
                complition(.success(rate))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
