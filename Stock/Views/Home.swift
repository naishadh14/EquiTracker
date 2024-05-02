//
//  Home.swift
//  Stock
//
//  Created by Naishadh Vora on 25/04/24.
//

import SwiftUI
import UIKit

struct Home: View {
    
    @StateObject var walletModel = WalletViewModel()
    @StateObject var portfolioModel = PortfolioViewModel()
    @StateObject var watchlistModel = WatchlistViewModel()
    @State private var searchResults: [SearchResult] = []
    @StateObject private var searchText = DebouncedState(initialValue: "")
    @State private var searchIsActive = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if walletModel.isLoading || portfolioModel.isLoading || watchlistModel.isLoading {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView("Fetching Data...")
                        Spacer()
                    }
                    Spacer()
                } else {
                    List {
                        if searchText.currentValue == "" {
                            HomeListView(walletModel: walletModel, portfolioModel: portfolioModel, watchlistModel: watchlistModel)
                        } else {
                            if !searchResults.isEmpty {
                                SearchListView(searchResults: searchResults)
                            }
                        }
                    }
                }

                Spacer()
            }
            .searchable(text: $searchText.currentValue, isPresented: $searchIsActive)
            .navigationTitle("Stocks")
            .navigationBarItems(trailing: EditButton())
            .onChange(of: searchText.debouncedValue) { newValue in
                fetchAutocompleteData(for: newValue)
            }
            .onAppear {
                walletModel.fetchWallet()
                portfolioModel.fetchPortfolio()
                watchlistModel.fetchWatchlist()
            }
        }
    }
    
    func fetchAutocompleteData(for ticker: String) {
        guard !ticker.isEmpty, let url = URL(string: "\(Constants.baseURL)/autocomplete?stock_ticker=\(ticker)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode([SearchResult].self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = results
                }
            } catch {
                print("Error decoding search results: \(error)")
            }
        }
        task.resume()
    }
}

struct SearchListView : View {
    var searchResults: [SearchResult] = []
    
    var body : some View {
        ForEach(searchResults.indices, id: \.self) { index in
            let item = searchResults[index]
            
            NavigationLink(destination: StockView(ticker: item.symbol)) {
                
                VStack(alignment: .leading) {
                    Text("\(item.symbol)")
                        .bold()
                        .font(.title2)
                    Text("\(item.description)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
            }
        }
    }
}

#Preview {
    Home()
}
