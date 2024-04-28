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
                            PortfolioView(cashBalance: walletModel.money, netWorth: walletModel.money)
                            
                            ForEach($portfolioModel.portfolio, id: \.ticker) { $item in
                                NavigationLink(destination: StockDetailView()) {
                                    PortfolioStockRow(item: $item)
                                }
                            }
                            .onDelete(perform: deletePortfolioItems)
                            .onMove(perform: movePortfolioItems)
                        }

                        Section(header: Text("Favorites")) {
                            ForEach(watchlistModel.watchlist.indices, id: \.self) { index in
                                
                                NavigationLink(destination: StockDetailView()) {
                                    let item = watchlistModel.watchlist[index]
                                    
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
    
    func deletePortfolioItems(at offsets: IndexSet) {
        portfolioModel.portfolio.remove(atOffsets: offsets)
    }

    func movePortfolioItems(from source: IndexSet, to destination: Int) {
        portfolioModel.portfolio.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteWatchlistItems(at offsets: IndexSet) {
        watchlistModel.watchlist.remove(atOffsets: offsets)
    }

    func moveWatchlistItems(from source: IndexSet, to destination: Int) {
        watchlistModel.watchlist.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    Home()
}
