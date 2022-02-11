//
//  FirstViewControllerViewModel.swift
//  converter
//
//  Created by Andrei Shurykin on 10.02.22.
//

import Foundation

protocol FirstViewControllerViewModelProtocol {
    func checkCurrencies(_ firstValue: String?, _ secondValue: String?) -> Bool
    func convert(_ text: String?,_ rate: Double) -> String
    func isCurrencyChanged(_ firstButtonTitle: String?,_ secondButtonTitle: String?,_ firstCurrentCurrency: String,_ secondCurrentCurrency: String,_ isFirstChanged: @escaping(Bool) -> Void,_ isSecondChanged: @escaping(Bool) -> Void) -> Bool
}

final class FirstViewControllerViewModel {
    
}

extension FirstViewControllerViewModel: FirstViewControllerViewModelProtocol {

    func checkCurrencies(_ firstValue: String?, _ secondValue: String?) -> Bool {
        if currenciesSet.contains(firstValue ?? "Choose a currency") && currenciesSet.contains(secondValue ?? "Choose a currency") {
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
    
    func isCurrencyChanged(_ firstButtonTitle: String?,_ secondButtonTitle: String?, _ firstCurrentCurrency: String, _ secondCurrentCurrency: String,_ isFirstChanged: @escaping(Bool) -> Void,_ isSecondChanged: @escaping(Bool) -> Void) -> Bool {
        if firstButtonTitle != firstCurrentCurrency {
            isFirstChanged(true)
            return true
        } else if secondButtonTitle != secondCurrentCurrency {
            isSecondChanged(true)
            return true
        } else {
            return false
        }
    }
}
