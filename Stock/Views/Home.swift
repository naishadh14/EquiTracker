//
//  Home.swift
//  Stock
//
//  Created by Naishadh Vora on 25/04/24.
//

import SwiftUI

struct Home: View {
    
    @StateObject var walletModel = WalletViewModel()
    @StateObject var portfolioModel = PortfolioViewModel()
    @State private var searchText = ""

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Stocks")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            
            if walletModel.isLoading || portfolioModel.isLoading {
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
                        VStack {
                            HStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Net Worth")
                                        Text("$\(walletModel.money, specifier: "%.2f")")
                                            .bold()
                                    }
                                }
                                
                                Spacer()
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Cash Balance")
                                        Text("$\(walletModel.money, specifier: "%.2f")")
                                            .bold()
                                    }
                                }
                            }
                            
                            ForEach(portfolioModel.portfolio, id: \.ticker) { item in
                                Divider()
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(item.ticker)")
                                            .bold()
                                        
                                        Text("\(item.quantity) shares")
                                            .foregroundStyle(.secondary)
                                            .font(.subheadline)
                                    }
                                    
                                    Spacer()
                                                                      
                                    VStack {
                                        Text("$\(Double(item.quantity) * item.currentPrice, specifier: "%.2f")")
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
                    }
                    
                    Section(header: Text("Favorites")) {
                        
                    }
                    
                    HStack {
                        Spacer()
                        Text("Powered by Finnhub.io")
                            .foregroundStyle(.secondary)
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
        }
    }
}

#Preview {
    Home()
}
