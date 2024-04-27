//
//  PortfolioItem.swift
//  Stock
//
//  Created by Naishadh Vora on 26/04/24.
//
import SwiftUI

struct PortfolioItem: Codable {
    let ticker: String
    let name: String
    let quantity: Int
    let totalCost: Double
    let currentPrice: Double
    
    var avgStockCost: Double { totalCost / Double(quantity) }
    var changeInPrice: Double { (currentPrice - avgStockCost) * Double(quantity) }
    var changeInPricePercentage: Double { changeInPrice * 100.0 / totalCost }
    
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
        case ticker, name, quantity, totalCost
        case currentPrice = "c"
    }
}
