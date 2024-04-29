//
//  StockView.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//

import SwiftUI
import Kingfisher

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
                            
//                            HourlyChartView(ticker: ticker)
//                                .frame(height: 400)
//                            
                            PortfolioSection(stockModel: stockModel)
//                            
//                            StatsSection(stockModel: stockModel)
//                            
//                            AboutSection(stockModel: stockModel)
//                            
//                            InsightsSection(stockModel: stockModel)
                            
//                            NewsSection(stockModel: stockModel)

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

struct NewsSection: View {
    @StateObject var stockModel = StockViewModel()
    @State private var selectedNewsIndex: Int?
    @State private var showingSheet = false
    
    var body : some View {
        VStack(alignment: .leading) {
            Text("News")
                .font(.title)
                .padding(.vertical)

            ForEach(stockModel.news.indices, id: \.self) { index in
                let item = stockModel.news[index]
                Button(action: {
                    selectedNewsIndex = index
                    showingSheet.toggle()
                }) {
                    if index == 0 {
                        FirstNewsRow(item: item)
                    } else {
                        NewsRow(item: item)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingSheet) {
                    NewsSheetView(item: stockModel.news[selectedNewsIndex ?? 0])
                }
            }
        }
    }
}

struct NewsSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State var item = NewsItem()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "multiply")
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(item.source)")
                        .font(.title)
                        .bold()
                    Text("\(formatDate(from: item.datetime))")
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            Divider()
                .padding(.vertical)
            
            Text("\(item.headline)")
                .font(.title2)
                .bold()
            Text("\(item.summary)")
            
            HStack {
                Text("For more details, click ")
                    .foregroundStyle(.secondary)
                Button(action: {
                    if let url = URL(string: item.url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("here")
                }
                .padding(.leading, -5)
            }
            
            HStack {
                Image("twitter-logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        if let url = URL(string: "https://twitter.com/intent/tweet?text=\(item.headline + " " + item.url)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                
                Image("fb-logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        if let url = URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(item.url)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
            }
            
            Spacer()
        }
        .padding()
    }
    
    func formatDate(from timestamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return dateFormatter.string(from: date)
    }
}

struct FirstNewsRow : View {
    var item = NewsItem()
    
    var body : some View {
        VStack(alignment: .leading) {
            KFImage.url(URL(string: item.image))
                .resizable()
                .scaledToFill()
                .frame(width: .infinity, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)

            HStack {
                Text("\(item.source)")
                    .bold()
                Text("\(item.hours) hrs, \(item.minutes) min")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            Text("\(item.headline)")
                .font(.headline)
                .bold()
        }
        
        Spacer()
        
        Divider()
            .padding(.vertical, 5)
    }
}

struct NewsRow : View {
    var item = NewsItem()

    var body : some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(item.source)")
                        .bold()
                    Text("\(item.hours) hrs, \(item.minutes) min")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Text("\(item.headline)")
                    .font(.headline)
                    .bold()
            }
            
            Spacer()

            KFImage.url(URL(string: item.image))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
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
            .padding(.bottom, 20)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(stockModel.stock.name)")
                        .bold()
                    Divider()
                    Text("Total")
                        .bold()
                    Divider()
                    Text("Positive")
                        .bold()
                    Divider()
                    Text("Negative")
                        .bold()
                    Divider()
                }
                
                VStack {
                    Text("MSPR")
                        .bold()
                    Divider()
                    Text("\(stockModel.sentiment.totalMspr, specifier: "%.2f")")
                    Divider()
                    Text("\(stockModel.sentiment.positiveMspr, specifier: "%.2f")")
                    Divider()
                    Text("\(stockModel.sentiment.negativeMspr, specifier: "%.2f")")
                    Divider()
                }
                
                VStack {
                    Text("Change")
                        .bold()
                    Divider()
                    Text("\(stockModel.sentiment.totalMspr, specifier: "%.2f")")
                    Divider()
                    Text("\(stockModel.sentiment.positiveMspr, specifier: "%.2f")")
                    Divider()
                    Text("\(stockModel.sentiment.negativeMspr, specifier: "%.2f")")
                    Divider()
                }
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
