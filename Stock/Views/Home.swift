//
//  Home.swift
//  Stock
//
//  Created by Naishadh Vora on 25/04/24.
//

import SwiftUI

struct Home: View {
    
    @StateObject var walletModel = WalletViewModel()
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
            
            if walletModel.isLoading {
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
                        HStack {
                            HStack {
                                VStack {
                                    Text("Net Worth")
                                    Text("$\(walletModel.money, specifier: "%.2f")")
                                        .bold()
                                }
                            }

                            Spacer()

                            HStack {
                                VStack {
                                    Text("Cash Balance")
                                    Text("$\(walletModel.money, specifier: "%.2f")")
                                        .bold()
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Favorites")) {
                        
                    }
                }
            }
            Spacer()
        }
        .background(Color.gray.opacity(0.2))
        .onAppear {
            walletModel.fetchWallet()
        }
    }
}

#Preview {
    Home()
}
