//
//  StockViewModel.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//

import Foundation
import SwiftUI

class StockViewModel: ObservableObject {
    @Published var money: Double = 0.0
    @Published var stock: Stock = Stock()
    @Published var price: Price = Price()
    @Published var quantity: Int = 0
    @Published var totalCost: Double = 0.0
    @Published var avgCost: Double = 0.0
    @Published var color: Color = .gray
    @Published var sentiment: Sentiment = Sentiment()
    @Published var news: [NewsItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite: Bool = false
    
    func fetchPortfolioStock(ticker: String) {
        StockData.stock.fetchPortfolioStock(ticker: ticker) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.quantity = data.0
                    self.totalCost = data.1
                    if self.quantity > 0 {
                        self.avgCost = self.totalCost / Double(self.quantity)
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchStock(ticker: String) {
        isLoading = true
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        StockData.stock.fetchStock(ticker: ticker) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stock):
                    self.stock = stock
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        StockData.stock.fetchPrice(ticker: ticker) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let price):
                    self.price = price
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        StockData.stock.fetchPortfolioStock(ticker: ticker) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.quantity = data.0
                    self.totalCost = data.1
                    self.avgCost = self.totalCost / Double(self.quantity)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        StockData.stock.fetchSentiment(ticker: ticker) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.sentiment = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        StockData.stock.fetchNews(ticker: ticker) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.news = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        WalletData.wallet.fetchWallet { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let money):
                    self.money = money
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        StockData.stock.checkFavorite(ticker: ticker) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isFavorite):
                    self.isFavorite = isFavorite
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            if self.price.c > self.avgCost {
                self.color = .green
            } else if self.price.c < self.avgCost {
                self.color = .red
            }
        }
    }
}
