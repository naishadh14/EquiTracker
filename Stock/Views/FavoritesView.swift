//
//  FavoritesView.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//

import SwiftUI

struct FavoritesView: View {
    var watchlist: [WatchlistItem]
    
    var body: some View {
        VStack {
            ForEach(watchlist.indices, id: \.self) { index in

                if index != 0 {
                    Divider()
                }
                
                NavigationLink(destination: StockDetailView()) {
                    let item = watchlist[index]
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(item.ticker)")
                                .bold()
                            
                            Text("\(item.name)")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("$\(item.currentPrice, specifier: "%.2f")")
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
        }
    }
}
