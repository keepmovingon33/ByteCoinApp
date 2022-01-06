//
//  CoinManager.swift
//  ByteCoin
//
//  Created by sky on 1/5/22.
//

import Foundation

protocol CoinManagerDelegate: AnyObject {
    func didUpdatePrice(rate: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "CCBB4914-6A5F-489E-B04C-C526E11E50BD"
    
    weak var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        // 1. Create a url
        if let url = URL(string: urlString) {
            // 2. create a session
            let session = URLSession(configuration: .default)
            
            // 3. Give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    delegate?.didFailWithError(error: error)
                    return
                }
                
                if let dat = data {
                    if let rate = parseJSON(dat) {
                        delegate?.didUpdatePrice(rate: rate, currency: currency)
                    }
                }
            }
            
            // 4. start the task
            task.resume()
        }
    }
    
    func performRequest(with urlString: String) {
        
    }
    
    func parseJSON(_ bitcoinData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: bitcoinData)
            let rate = decodedData.rate
            return String(format: "%.1f", rate)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
