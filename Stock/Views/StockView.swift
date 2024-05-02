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
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body : some View {
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
                        let color: String = {
                            if stockModel.price.d > 0 {
                                return "green"
                            } else {
                                return "red"
                            }
                        }()

                        VStack(alignment: .leading) {
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
                            
                            TabView {
                                HourlyChartView(ticker: ticker, color: color)
                                    .frame(height: 450)
                                    .tabItem {
                                        Label("Hourly", systemImage: "chart.xyaxis.line")
                                }
                                HistoricalChartView(ticker: ticker)
                                    .frame(height: 450)
                                    .tabItem {
                                        Label("Historical", systemImage: "clock")
                                }
                            }
                            .frame(height: 500)
                            
                            PortfolioSection(stockModel: stockModel)
                            
                            StatsSection(stockModel: stockModel)
                            
                            AboutSection(stockModel: stockModel)
                            
                            InsightsSection(stockModel: stockModel)
                            
                            NewsSection(stockModel: stockModel)

                            Spacer()
                        }
                    }
                }
                .padding()
                .onAppear {
                    stockModel.fetchStock(ticker: ticker)
                }
            }
        .overlay(ToastMessage(message: toastMessage, isShowing: $showToast).padding(.vertical, 80), alignment: .bottom)
        .onChange(of: showToast) {
            newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
        }
        .navigationTitle("\(stockModel.stock.ticker)")
        .navigationBarItems(trailing: Button(action: {
            toggleFavorite()
        }) {
            if stockModel.isFavorite {
                Image(systemName: "plus.circle.fill")
            } else {
                Image(systemName: "plus.circle")
            }
        })
    }
    
    func toggleFavorite() {
        if stockModel.isFavorite {
            removeStockFromFavorite(stockTicker: stockModel.stock.ticker) { success in
                if success {
                    stockModel.isFavorite = false
                    showToast = true
                    toastMessage = "Removing \(stockModel.stock.ticker) from Favorites"
                }
            }
        } else {
            addStockToFavorite(stockTicker: stockModel.stock.ticker, name: stockModel.stock.name) { success in
                if success {
                    stockModel.isFavorite = true
                    showToast = true
                    toastMessage = "Adding \(stockModel.stock.ticker) to Favorites"
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
                .frame(height: 200)
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
        
        RecommendationChartView(ticker: stockModel.stock.ticker) 
            .frame(width: .infinity, height: 400)
            .padding()
        
        EpsChartView(ticker: stockModel.stock.ticker)
            .frame(width: .infinity, height: 400)
            .padding()
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
    @State private var showingSheet = false

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
                    showingSheet.toggle()
                }) {
                    Text("Trade")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical)
                        .background(Color.green)
                        .cornerRadius(30)
                }
                .sheet(isPresented: $showingSheet) {
                    TradeSheetView(stockModel: stockModel)
                        .ignoresSafeArea()
                }
                
                Spacer()
            }
        }
    }
}

struct TradeSheetView : View {
    @StateObject var stockModel = StockViewModel()
    @State private var quantityString = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showCongrats = false
    @State private var backgroundColor = Color.white
    @State private var transactionFinished = false
    @State private var operation = ""
    @Environment(\.dismiss) var dismiss
    
    var body : some View {
        if !transactionFinished {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "multiply")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text("Trade \(stockModel.stock.name) shares")
                    .bold()
                
                Spacer()
                
                HStack {
                    TextField("0", text: $quantityString)
                        .padding()
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .padding(.horizontal)
                        .font(.system(size: 60))
                        .background(Color.clear)
                        .focusEffectDisabled()
                    
                    Text("Shares")
                        .font(.system(size: 24))
                }
                
                HStack {
                    Spacer()
                    Text("x $\(stockModel.price.c, specifier: "%.2f")/share = $\(stockModel.price.c * (Double(quantityString) ?? 0.00), specifier: "%.2f")")
                }
                
                Spacer()
                
                Text("$\(stockModel.money, specifier: "%.2f") available to buy \(stockModel.stock.ticker)")
                    .foregroundStyle(.secondary)
                
                HStack {
                    Spacer()
                    Button(action: {
                        let quantity = Int(quantityString) ?? 0
                        if quantity <= 0 {
                            showToast = true
                            toastMessage = "Cannot buy non-positive shares"
                        } else if Double(quantity) * stockModel.price.c > stockModel.money {
                            showToast = true
                            toastMessage = "Not enough money to buy"
                        } else {
                            operation = "bought"
                            buyShares(ticker: stockModel.stock.ticker, name: stockModel.stock.name, quantity: quantity, price: stockModel.price.c) { result in
                                    switch result {
                                    case .success:
                                        transactionFinished = true
                                    case .failure(let error):
                                        print("Error buying shares: \(error)")
                                    }
                            }
                        }
                    }) {
                        Text("Buy")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 60)
                            .padding(.vertical)
                            .background(Color.green)
                            .cornerRadius(30)
                    }
                    Spacer()
                    Button(action: {
                        let quantity = Int(quantityString) ?? 0
                        if quantity <= 0 {
                            showToast = true
                            toastMessage = "Cannot sell non-positive shares"
                        } else if quantity > stockModel.quantity {
                            showToast = true
                            toastMessage = "Not enough shares to sell"
                        } else {
                            operation = "sold"
                            sellShares(ticker: stockModel.stock.ticker, quantity: quantity, price: stockModel.price.c) { result in
                                    switch result {
                                    case .success:
                                        transactionFinished = true
                                    case .failure(let error):
                                        print("Error selling shares: \(error)")
                                    }
                            }
                        }
                    }) {
                        Text("Sell")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 60)
                            .padding(.vertical)
                            .background(Color.green)
                            .cornerRadius(30)
                    }
                    Spacer()
                }
            }
            .padding()
            .overlay(
                ToastMessage(message: toastMessage, isShowing: $showToast)
                    .padding(.vertical, 60),
                alignment: .bottom
            )
            .onChange(of: showToast) { newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showToast = false
                    }
                }
            }
        } else {
            VStack {
                Spacer()
                Text("Congratulations!")
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .padding(.vertical)
                Text("You have successfully \(operation) \(quantityString) \((Int(quantityString) ?? 0) > 1 ? "shares" : "share") of \(stockModel.stock.ticker)")
                    .foregroundColor(.white)
                    
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .frame(width: 300)
                        .padding(.vertical)
                        .background(Color.white)
                        .cornerRadius(30)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.green.edgesIgnoringSafeArea(.all))
        }
    }
    
    func buyShares(ticker: String, name: String, quantity: Int, price: Double, completion: @escaping (Result<Void, Error>) -> Void) {

        let urlString = Constants.baseURL +  "/addPortfolio?stock_ticker=\(ticker)&name=\(name)&quantity=\(quantity)&price=\(price)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                stockModel.fetchPortfolioStock(ticker: stockModel.stock.ticker)
                completion(.success(()))
            }
        }

        task.resume()
    }

    
    func sellShares(ticker: String, quantity: Int, price: Double, completion: @escaping (Result<Void, Error>) -> Void) {

        let urlString = Constants.baseURL +  "/sellPortfolio?stock_ticker=\(ticker)&quantity=\(quantity)&price=\(price)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                stockModel.fetchPortfolioStock(ticker: stockModel.stock.ticker)
                completion(.success(()))
            }
        }

        task.resume()
    }

}

struct ToastMessage: View {
    var message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.gray)
            .cornerRadius(30)
            .padding(.horizontal, 50)
            .opacity(isShowing ? 1 : 0)
            .animation(.easeInOut(duration: 0.5))
    }
}

#Preview {
    StockView(ticker: "AAPL")
}
