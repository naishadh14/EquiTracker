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

