//
//  FavoriteData.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//

import Foundation
import Alamofire

class WatchlistData {
    static let watchlist = WatchlistData()

    private init() {}

    func fetchWatchlist(completion: @escaping (Result<[WatchlistItem], Error>) -> Void) {
        if(Constants.testing) {
            let testData: [WatchlistItem] = [
                    WatchlistItem(ticker: "MSFT", name: "Microsoft Corp", currentPrice: 406.32, changeInPrice: 7.28, changeInPricePercentage: 1.8244),
                    WatchlistItem(ticker: "RIVN", name: "Rivian Automotive Inc", currentPrice: 9.04, changeInPrice: 0.52, changeInPricePercentage: 6.1033)
                ]
            completion(.success(testData))
            return
        }

        let url = Constants.baseURL + "/watchlist"
        AF.request(url).responseJSON { response in
            do {
                switch response.result {
                case .success(let value):
                    guard let data = (value as? [String: Any])?["result"] as? [[String: Any]] else {
                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected data"])
                    }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let watchlist = try JSONDecoder().decode([WatchlistItem].self, from: jsonData)
                    completion(.success(watchlist))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}

