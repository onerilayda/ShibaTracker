//
//  CoinManager.swift
//  ShibaTracker
//
//  Created by Mac on 29.09.2022.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency:String)
    func didFailWithError(error: Error)
        
    }


struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/SHIB"
    let apiKey = "EC74C69A-B541-4820-B6CF-86B2C1250C83"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let shibaPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.6f", shibaPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
func parseJSON(_ data: Data) -> Double? {
    
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(CoinData.self, from: data)
        let lastPrice = decodedData.rate
        print(lastPrice)
        return lastPrice
        
    } catch {
        delegate?.didFailWithError(error: error)
        return nil
    }
}

}

