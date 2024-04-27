//
//  WatchlistItem.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//

import SwiftUI

struct WatchlistItem: Codable {
    let ticker: String
    let name: String
    let currentPrice: Double
    let changeInPrice: Double
    let changeInPricePercentage: Double
    
    var symbol: String {
        if changeInPrice > 0 {
            return "arrow.up.forward"
        } else if changeInPrice < 0 {
            return "arrow.down.forward"
        } else {
            return "minus"
        }
    }

    var color: Color {
        if changeInPrice > 0 {
            return .green
        } else if changeInPrice < 0 {
            return .red
        } else {
            return .gray
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case ticker, name
        case currentPrice = "c"
        case changeInPrice = "d"
        case changeInPricePercentage = "dp"
    }
}
