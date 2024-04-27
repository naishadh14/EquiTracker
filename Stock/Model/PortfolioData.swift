//
//  PortfolioData.swift
//  Stock
//
//  Created by Naishadh Vora on 26/04/24.
//

import Foundation
import Alamofire

class PortfolioData {
    static let portfolio = PortfolioData()
    let testing = true

    private init() {}
    
    func fetchPortfolio(completion: @escaping (Result<[PortfolioItem], Error>) -> Void) {
        if(testing) {
            let testData: [PortfolioItem] = [
                            PortfolioItem(ticker: "TSLA", name: "Tesla Inc", quantity: 10, totalCost: 1657.65, currentPrice: 168.29),
                            PortfolioItem(ticker: "RIVN", name: "Rivian Automotive Inc", quantity: 1, totalCost: 10.44, currentPrice: 9.04)
                        ]
            completion(.success(testData))
            return
        }

        let url = Constants.baseURL + "/portfolio"
        AF.request(url).responseJSON { response in
            do {
                switch response.result {
                case .success(let value):
                    guard let data = (value as? [String: Any])?["result"] as? [[String: Any]] else {
                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected data"])
                    }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let portfolio = try JSONDecoder().decode([PortfolioItem].self, from: jsonData)
                    completion(.success(portfolio))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
