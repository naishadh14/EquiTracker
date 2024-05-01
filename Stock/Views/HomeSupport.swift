//
//  HomeSupport.swift
//  Stock
//
//  Created by Naishadh Vora on 30/04/24.
//

import Foundation
import SwiftUI
import UIKit

struct SearchResult: Decodable {
    var description: String
    var symbol: String
}

class DebouncedState: ObservableObject {
    @Published var currentValue: String
    @Published var debouncedValue: String
    
    init(initialValue: String, delay: Double = 0.3) {
        _currentValue = Published(initialValue: initialValue)
        _debouncedValue = Published(initialValue: initialValue)
        $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .assign(to: &$debouncedValue)
    }
}

struct HomeListView: View {
    @StateObject var walletModel = WalletViewModel()
    @StateObject var portfolioModel = PortfolioViewModel()
    @StateObject var watchlistModel = WatchlistViewModel()
    
    var body : some View {
        HStack {
            Text("\(formattedDate)")
                .font(.title)
                .foregroundStyle(.secondary)
                .bold()
        }
        .padding(.vertical, 10)
        
        Section(header: Text("Portfolio")) {
            PortfolioView(cashBalance: walletModel.money, netWorth: walletModel.money + portfolioModel.portfolioValue)
            
            ForEach($portfolioModel.portfolio, id: \.ticker) { $item in
                NavigationLink(destination: StockView(ticker: item.ticker)) {
                    PortfolioStockRow(item: $item)
                }
            }
            .onMove(perform: movePortfolioItems)
        }
        
        Section(header: Text("Favorites")) {
            ForEach(watchlistModel.watchlist.indices, id: \.self) { index in
                
                let item = watchlistModel.watchlist[index]
                NavigationLink(destination: StockView(ticker: item.ticker)) {
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(item.ticker)")
                                .bold()
                            
                            Text("\(item.name)")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("$\(item.currentPrice, specifier: "%.2f")")
                                .bold()
                            
                            HStack {
                                Image(systemName: item.symbol)
                                Text("$\(item.changeInPrice, specifier: "%.2f")")
                                Text("(\(item.changeInPricePercentage, specifier: "%.2f")%)")
                            }
                            .foregroundColor(item.color)
                        }
                        .font(.subheadline)
                    }
                }
            }
            .onDelete(perform: deleteWatchlistItems)
            .onMove(perform: moveWatchlistItems)
        }
        
        HStack {
            Spacer()
            Button(action: {
                if let url = URL(string: "https://www.finnhub.io") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("Powered by Finnhub.io")
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }

    func movePortfolioItems(from source: IndexSet, to destination: Int) {
        portfolioModel.portfolio.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteWatchlistItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let stockTicker = watchlistModel.watchlist[index].ticker
            deleteStockTickerFromAPI(stockTicker: stockTicker) { success in
                if success {
                    DispatchQueue.main.async {
                        watchlistModel.watchlist.remove(at: index)
                    }
                } else {
                    print("Error deleting \(stockTicker) from the server.")
                }
            }
        }
    }
    
    func deleteStockTickerFromAPI(stockTicker: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/deleteWatchlist?stock_ticker=\(stockTicker)") else {
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let success = jsonResponse["success"] as? Bool {
                    completion(success)
                } else {
                    completion(false)
                }
            } catch {
                completion(false)
            }
        }
        task.resume()
    }

    func moveWatchlistItems(from source: IndexSet, to destination: Int) {
        watchlistModel.watchlist.move(fromOffsets: source, toOffset: destination)
    }
}
