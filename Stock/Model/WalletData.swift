//
//  WalletData.swift
//  Stock
//
//  Created by Naishadh Vora on 25/04/24.
//

import Foundation
import Alamofire

class WalletData {
    static let wallet = WalletData()
    
    private init() {}
    
    func fetchWallet(completion: @escaping (Result<Double, Error>) -> Void) {
        if(Constants.testing) {
            completion(.success(25000.00))
            return
        }

        let url = Constants.baseURL + "/wallet"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let money = (value as? [String: Any])?["money"] as? Double {
                    completion(.success(money))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected data"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
