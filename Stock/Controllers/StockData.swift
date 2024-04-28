//
//  StockData.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//

import Foundation
import Alamofire

class StockData {
    static let stock = StockData()
    
    private init() {}
    
    func fetchPortfolioStock(ticker: String, completion: @escaping (Result<(Int, Double), Error>) -> Void) {
        if(Constants.testing) {
            let testData: (Int, Double) = (3, 513.69)
            completion(.success(testData))
            return
        }

        let url = Constants.baseURL + "/getPortfolioItem?stock_ticker=\(ticker)"
        AF.request(url).responseJSON { response in
            do {
                switch response.result {
                case .success(let value):
                    if let result = (value as? [String: Any])?["result"] as? [String: Any] {
                        guard let quantity = result["quantity"] as? Int else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected data"])
                        }
                        
                        guard let totalCost = result["totalCost"] as? Double else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected data"])
                        }
                        
                        completion(.success((quantity, totalCost)))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected data"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchPrice(ticker: String, completion: @escaping (Result<Price, Error>) -> Void) {
        if(Constants.testing) {
            let testData = Price(
                      c: 169.3,
                      d: -0.59,
                      dp: -0.3473,
                      h: 171.34,
                      l: 169.19,
                      o: 169.87,
                      pc: 169.89,
                      t: 1714161601
                  )
            completion(.success(testData))
            return
        }

        let url = Constants.baseURL + "/stock?stock_ticker=\(ticker)"
        AF.request(url).responseJSON { response in
            do {
                switch response.result {
                case .success(let value):
                    guard let data = value as? [String: Any] else {
                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected data"])
                    }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let price = try JSONDecoder().decode(Price.self, from: jsonData)
                    completion(.success(price))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchStock(ticker: String, completion: @escaping (Result<Stock, Error>) -> Void) {
        if(Constants.testing) {
            let testData = Stock(
                country: "US",
                currency: "USD",
                estimateCurrency: "USD",
                exchange: "NASDAQ NMS - GLOBAL MARKET",
                finnhubIndustry: "Technology",
                ipo: "1980-12-12",
//                logo: URL(string: "https://static2.finnhub.io/file/publicdatany/finnhubimage/stock_logo/AAPL.png")!,
                marketCapitalization: 2614310.4200997017,
                name: "Apple Inc",
                phone: "14089961010",
                shareOutstanding: 15441.88,
                ticker: "AAPL",
                peers: ["AAPL", "DELL", "SMCI", "HPQ", "WDC", "HPE", "NTAP", "PSTG", "IONQ"]
            )
            completion(.success(testData))
            return
        }

        let url = Constants.baseURL + "/company?stock_ticker=\(ticker)"
        AF.request(url).responseJSON { response in
            do {
                switch response.result {
                case .success(let value):
                    guard let data = value as? [String: Any] else {
                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected data"])
                    }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let stock = try JSONDecoder().decode(Stock.self, from: jsonData)
                    completion(.success(stock))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}

