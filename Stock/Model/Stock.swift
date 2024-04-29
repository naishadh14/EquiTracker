//
//  Stock.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//
import Foundation
import SwiftUI

struct Stock: Codable {
    let country: String
    let currency: String
    let estimateCurrency: String
    let exchange: String
    let finnhubIndustry: String
    let ipo: String
//    let logo: URL
    let marketCapitalization: Double
    let name: String
    let phone: String
    let shareOutstanding: Double
    let ticker: String
    let weburl: String
    let peers: [String]
    
    init(country: String = "",
         currency: String = "",
         estimateCurrency: String = "",
         exchange: String = "",
         finnhubIndustry: String = "",
         ipo: String = "",
//         logo: URL = URL(string: ""),
         marketCapitalization: Double = 0.0,
         name: String = "",
         phone: String = "",
         shareOutstanding: Double = 0.0,
         ticker: String = "",
         weburl: String = "",
         peers: [String] = []) {
        self.country = country
        self.currency = currency
        self.estimateCurrency = estimateCurrency
        self.exchange = exchange
        self.finnhubIndustry = finnhubIndustry
        self.ipo = ipo
//        self.logo = logo
        self.marketCapitalization = marketCapitalization
        self.name = name
        self.phone = phone
        self.shareOutstanding = shareOutstanding
        self.ticker = ticker
        self.weburl = weburl
        self.peers = peers
    }
}

struct Price: Codable {
    let c: Double
    let d: Double
    let dp: Double
    let h: Double
    let l: Double
    let o: Double
    let pc: Double
    let t: TimeInterval
    
    var symbol: String {
        if d > 0 {
            return "arrow.up.forward"
        } else if d < 0 {
            return "arrow.down.forward"
        } else {
            return "minus"
        }
    }

    var color: Color {
        if d > 0 {
            return .green
        } else if d < 0 {
            return .red
        } else {
            return .gray
        }
    }
    
    init(c: Double = 0.0,
         d: Double = 0.0,
         dp: Double = 0.0,
         h: Double = 0.0,
         l: Double = 0.0,
         o: Double = 0.0,
         pc: Double = 0.0,
         t: TimeInterval = 0.0) {
        self.c = c
        self.d = d
        self.dp = dp
        self.h = h
        self.l = l
        self.o = o
        self.pc = pc
        self.t = t
    }
}

struct Sentiment: Codable {
    var totalMspr: Double
    var totalChange: Double
    var positiveMspr: Double
    var positiveChange: Double
    var negativeMspr: Double
    var negativeChange: Double

    init(totalMspr: Double = 0, totalChange: Double = 0, positiveMspr: Double = 0, positiveChange: Double = 0, negativeMspr: Double = 0, negativeChange: Double = 0) {
        self.totalMspr = totalMspr
        self.totalChange = totalChange
        self.positiveMspr = positiveMspr
        self.positiveChange = positiveChange
        self.negativeMspr = negativeMspr
        self.negativeChange = negativeChange
    }
}

struct NewsItem: Codable {
    var category: String
    var datetime: Int
    var headline: String
    var id: Int
    var image: String
    var related: String
    var source: String
    var summary: String
    var url: String
    
    var timeDifference: Int {
        return Int(Date().timeIntervalSince1970) - datetime
    }
    
    var days: Int {
        return timeDifference / 86400
    }
    
    var hours: Int {
        return (timeDifference % 86400) / 3600
    }
    
    var minutes: Int {
        return (timeDifference % 3600) / 60
    }
    
    init(category: String = "", datetime: Int = 0, headline: String = "", id: Int = 0, image: String = "", related: String = "", source: String = "", summary: String = "", url: String = "") {
        self.category = category
        self.datetime = datetime
        self.headline = headline
        self.id = id
        self.image = image
        self.related = related
        self.source = source
        self.summary = summary
        self.url = url
    }
}
