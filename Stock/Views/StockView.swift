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
        NavigationView {
            ScrollView {
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
                            
                            //                        HourlyChartView(ticker: ticker)
                            //                            .frame(height: 400)
                            
                            //                        PortfolioSection(stockModel: stockModel)
                            
                            StatsSection(stockModel: stockModel)
                            
                            AboutSection(stockModel: stockModel)
                            
                            InsightsSection(stockModel: stockModel)

                            Spacer()
                        }
                    }
                }
                .padding()
                .onAppear {
                    stockModel.fetchStock(ticker: ticker)
                }
            }
        }
    }
}

struct InsightsSection: View {
    @StateObject var stockModel = StockViewModel()
    
    var body : some View {
        VStack(alignment: .leading) {
            Text("Insights")
                .font(.title)
                .padding(.vertical)
            
            HStack {
                Spacer()
                Text("Insider Sentiments")
                    .font(.title)
                Spacer()
            }
            
            
        }
    }
}

struct AboutSection: View {
    @StateObject var stockModel = StockViewModel()
    
    var body : some View {
        VStack(alignment: .leading) {
            Text("About")
                .font(.title)
                .padding(.vertical)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("IPO Start Date:")
                    Text("Industry:")
                    Text("Webpage:")
                    Text("Company Peers:")
                        .padding(.top, 1)
                }
                .bold()
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("\(stockModel.stock.ipo)")
                    Text("\(stockModel.stock.finnhubIndustry)")
                    Button(action: {
                        if let url = URL(string: stockModel.stock.weburl) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        Text("\(stockModel.stock.weburl)")
                            .foregroundColor(.blue)
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(stockModel.stock.peers, id: \.self) { peer in
                                NavigationLink(destination: StockView(ticker: peer)) {
                                    Text("\(peer),")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .padding(0)
                }
                
                Spacer()
            }
        }
    }
}

struct StatsSection: View {
    @StateObject var stockModel = StockViewModel()
    
    var body : some View {
        VStack(alignment: .leading) {
            Text("Stats")
                .font(.title)
                .padding(.vertical)
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("High Price: ")
                            .bold()
                        Text("$\(stockModel.price.h, specifier: "%.2f")")
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Text("Low Price: ")
                            .bold()
                        Text("$\(stockModel.price.l, specifier: "%.2f")")
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Open Price: ")
                            .bold()
                        Text("$\(stockModel.price.l, specifier: "%.2f")")
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Text("Prev. Close: ")
                            .bold()
                        Text("$\(stockModel.price.h, specifier: "%.2f")")
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct PortfolioSection: View {
    @StateObject var stockModel = StockViewModel()

    var body : some View {
        VStack(alignment: .leading) {
            Text("Portfolio")
                .font(.title)
                .padding(.vertical)
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
                        Text("You have 0 shares of \(stockModel.stock.ticker).")
                        Text("Start trading!")
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Button action
                    print("Button tapped")
                }) {
                    Text("Trade")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical)
                        .background(Color.green)
                        .cornerRadius(30)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    StockView(ticker: "AAPL")
}
