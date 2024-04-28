//
//  PortfolioView.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//

import SwiftUI

struct PortfolioView: View {
    var cashBalance: Double
    var netWorth: Double
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Net Worth")
                        Text("$\(netWorth, specifier: "%.2f")")
                            .bold()
                    }
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Cash Balance")
                        Text("$\(cashBalance, specifier: "%.2f")")
                            .bold()
                    }
                }
            }
        }
    }
}

struct PortfolioStockRow: View {
    @Binding var item: PortfolioItem
    
    var body: some View {
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
