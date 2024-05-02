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
    
    func checkFavorite(ticker: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if Constants.testing {
            completion(.success(true))
            return
        }
        
        let url = Constants.baseURL + "/checkWatchlist?stock_ticker=\(ticker)"
        AF.request(url).responseJSON { response in
            do {
                switch response.result {
                    case .success(let value):
                        if let success = (value as? [String: Any])?["success"] as? Bool {
                            completion(.success(success))
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
    
    func fetchNews(ticker: String, completion:  @escaping (Result<[NewsItem], Error>) -> Void) {
        if Constants.testing {
            let testData: [NewsItem] = [
                NewsItem(category: "company",
                         datetime: 1714320013,
                         headline: "The AI trade is back, as confidence in Big Tech surges",
                         id: 127285415,
                         image: "https://s.yimg.com/ny/api/res/1.2/X9ywrnGW8MC.RseK.gOaXA--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD03OTg-/https://s.yimg.com/os/creatr-uploaded-images/2024-04/b4f595c0-0072-11ef-9d9f-af5281fd82db",
                         related: "AAPL",
                         source: "Yahoo",
                         summary: "Standout earnings results from Microsoft and Alphabet are drawing investors' attention back to AI.",
                         url: "https://finnhub.io/api/news?id=dcf88d95a2517a2867e8c2d6c4eb0e1e071475dc3b18f87d5d6f63751dba1b48"),
                NewsItem(category: "company",
                         datetime: 1714313700,
                         headline: "3 Reasons to Buy Apple Stock Like There's No Tomorrow",
                         id: 127286682,
                         image: "https://g.foolcdn.com/editorial/images/774349/investor-reviewing-a-stock-portfolio.jpg",
                         related: "AAPL",
                         source: "Yahoo",
                         summary: "The market's pricing in all of the bad and none of the good.",
                         url: "https://finnhub.io/api/news?id=669014988cc3236cf6e8b4a3d381d44aeb0730f2160fb6e88fca316a7a99ffa0"),
                NewsItem(category: "company",
                         datetime: 1714311840,
                         headline: "Wall Street Brunch: Fed, Payrolls, Apple, Amazon",
                         id: 127285662,
                         image: "https://static.seekingalpha.com/cdn/s3/uploads/getty_images/160487655/image_160487655.jpg?io=getty-c-w1536",
                         related: "AAPL",
                         source: "SeekingAlpha",
                         summary: "Traders will be looking for any hints to the timing of rate cuts. Apple and Amazon lead the earnings parade. Elon Musk makes surprise visit to China.",
                         url: "https://finnhub.io/api/news?id=698744b31b5d7168173fe63c14b97ada362dd3cd4953845759fd4a1159ef49fb")
            ]
            completion(.success(testData))
            return
        }

        let url = Constants.baseURL + "/news?stock_ticker=\(ticker)&from=2024-04-21&to=2024-05-02"
        AF.request(url).responseJSON { response in
            do {
                switch response.result {
                    case .success(let value):
                        if let data = value as? [[String: Any]] {
                            let jsonData = try JSONSerialization.data(withJSONObject: data)
                            let news = try JSONDecoder().decode([NewsItem].self, from: jsonData)
                            completion(.success(news))
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
    
    func fetchSentiment(ticker: String, completion: @escaping (Result<Sentiment, Error>) -> Void) {
        if(Constants.testing) {
            let testData = Sentiment(
                totalMspr: -654.26,
                totalChange: -654.26,
                positiveMspr: 200.00,
                positiveChange: 200.00,
                negativeMspr: -854.26,
                negativeChange: -854.26
            )
            completion(.success(testData))
            return
        }
        
        let url = Constants.baseURL + "/sentiment?stock_ticker=\(ticker)&from=2022-01-01&to=2024-05-02"
        AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let result = (value as? [String: Any])?["data"] as? [[String: Any]] {
                        var totalMspr: Double = 0
                        var totalChange: Double = 0
                        var positiveMspr: Double = 0
                        var negativeMspr: Double = 0
                        var positiveChange: Double = 0
                        var negativeChange: Double = 0
                        
                        for entry in result {
                            if let mspr = entry["mspr"] as? Double, let change = entry["change"] as? Double {
                                totalMspr += mspr
                                totalChange += change

                                if mspr > 0 {
                                    positiveMspr += mspr
                                } else {
                                    negativeMspr += mspr
                                }

                                if change > 0 {
                                    positiveChange += change
                                } else {
                                    negativeChange += change
                                }
                            }
                        }
                        
                        completion(.success(Sentiment(totalMspr: totalMspr, totalChange: totalChange, positiveMspr: positiveMspr, positiveChange: positiveChange, negativeMspr: negativeMspr, negativeChange: negativeChange)))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected data"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    
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
                        completion(.success((0, 0.0)))
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
                weburl: "https://www.apple.com/",
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

