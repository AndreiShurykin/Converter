//
//  DataManager.swift
//  converter
//
//  Created by Andrei Shurykin on 10.02.22.
//

import Foundation
import UIKit

final class DataManager {
    
    static var shared = DataManager()
    private init() {}
    
    func getCurrencyRate(_ firstCurrency: String?, _ secondCurrency: String?, complition: @escaping((Double?, Error?) -> Void)) {
        guard let firstCurrency = firstCurrency else { return }
        guard let secondCurrency = secondCurrency else { return }
        let urlString = urlBaseFirst + firstCurrency + urlBaseSecond + secondCurrency + urlBaseThird
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let data = data else { return }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Double]
                complition(dictionary?.first?.value, nil)
            } catch let error{
                complition(nil, error)
            }
        }
        task.resume()
    }
    
    func checkCurrencies(_ firstValue: String?, _ secondValue: String?) -> Bool {
        if currenciesSet.contains(firstValue ?? "Tap to choose a currency") && currenciesSet.contains(secondValue ?? "Tap to choose a currency") {
            return true
        } else {
            return false
        }
    }
    
    func convert(_ text: String?,_ rate: Double) -> String {
        guard let text = text else {
            return String()
        }
        guard let convertedValue = Double(text) else {
            return String()
        }
        return String(Double(round(100 * convertedValue * rate) / 100))
    }
    
    func isCurrencyChanged(_ firstButtonTitle: String?,_ secondButtonTitle: String?, _ firstCurrentCurrency: String, _ secondCurrentCurrency: String) -> Bool {
        if firstButtonTitle != firstCurrentCurrency {
            return true
        } else if secondButtonTitle != secondCurrentCurrency {
            return true
        } else {
            return false
        }
    }
    
    func getImageName(_ currency: String) -> String {
        switch currency {
        case byn:
            return "belarus.png"
        case eur:
            return "european-union.png"
        case rub:
            return "russia.png"
        case usd:
            return "united-states-of-america.png"
        default:
            return "flag.png"
        }
    }
}
