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
    @State private var searchText = ""

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Stocks")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                
                if walletModel.isLoading || portfolioModel.isLoading || watchlistModel.isLoading {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView("Fetching Data...")
                        Spacer()
                    }
                    Spacer()
                } else {
                    TextField("       Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                            }
                        )
                    
                    List {
                        HStack {
                            Text("\(formattedDate)")
                                .font(.title)
                                .foregroundStyle(.secondary)
                                .bold()
                        }
                        .padding(.vertical, 10)
                        
                        Section(header: Text("Portfolio")) {
                            PortfolioView(cashBalance: walletModel.money, netWorth: walletModel.money, portfolio: $portfolioModel.portfolio)
                        }

                        Section(header: Text("Favorites")) {
                            FavoritesView(watchlist: watchlistModel.watchlist)
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
                }
                Spacer()
            }
            .background(Color.gray.opacity(0.2))
            .onAppear {
                walletModel.fetchWallet()
                portfolioModel.fetchPortfolio()
                watchlistModel.fetchWatchlist()
            }
            .navigationBarItems(leading: EditButton())
        }
    }
}

#Preview {
    Home()
}
