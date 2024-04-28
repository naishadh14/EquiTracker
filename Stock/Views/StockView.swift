//
//  StockView.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//

import SwiftUI

struct StockView: View {
    
    @StateObject var stockModel = StockViewModel()
    @State var ticker: String
    
    var body : some View {
        VStack(alignment: .leading) {
            if stockModel.isLoading {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView("Fetching Data")
                    Spacer()
                }
                Spacer()
            } else {
                VStack(alignment: .leading) {
                    Text("\(ticker)")
                        .font(.title)
                        .bold()
                        .padding(.bottom)
                    
                    Text("\(stockModel.stock.name)")
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                    
                    HStack {
                        Text("$\(stockModel.price.c, specifier: "%.2f")")
                            .font(.title)
                            .bold()
                        
                        HStack {
                            Image(systemName: stockModel.price.symbol)
                            Text("$\(stockModel.price.d, specifier: "%.2f")")
                            Text("(\(stockModel.price.dp, specifier: "%.2f")%)")
                        }
                        .foregroundColor(stockModel.price.color)
                    }
                    
                    HourlyChartView(ticker: ticker)
                    
                    VStack(alignment: .leading) {
                        Text("Portfolio")
                            .font(.title)
                        HStack {
                            VStack(alignment: .leading) {
                                if stockModel.quantity > 0 {
                                    HStack {
                                        Text("Shared Owned: ")
                                            .bold()
                                        Text("\(stockModel.quantity)")
                                    }
                                    .padding(.vertical, 3)
                                    
                                    HStack {
                                        Text("Avg. Cost / Share: ")
                                            .bold()
                                        Text("$\(stockModel.avgCost, specifier: "%.2f")")
                                    }
                                    .padding(.vertical, 3)
                                    
                                    HStack {
                                        Text("Total Cost: ")
                                            .bold()
                                        Text("$\(stockModel.totalCost, specifier: "%.2f")")
                                    }
                                    .padding(.vertical, 3)
                                    
                                    HStack {
                                        Text("Change: ")
                                            .bold()
                                        Text("$\((stockModel.price.c - stockModel.avgCost) * Double(stockModel.quantity), specifier: "%.2f")")
                                            .foregroundColor(stockModel.color)
                                    }
                                    .padding(.vertical, 3)
                                    
                                    HStack {
                                        Text("Market Value: ")
                                            .bold()
                                        Text("$\((stockModel.price.c) * Double(stockModel.quantity), specifier: "%.2f")")
                                            .foregroundColor(stockModel.color)
                                    }
                                    .padding(.vertical, 3)
                                } else {
                                    Text("You have 0 shares of \(ticker).")
                                    Text("Start trading!")
                                }
                            }
                            
                            Spacer()
                            
                            Text("Trade")
                            
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .onAppear {
            stockModel.fetchStock(ticker: ticker)
        }
    }
}

#Preview {
    StockView(ticker: "AAPL")
}
