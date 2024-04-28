//
//  WatchlistViewModel.swift
//  Stock
//
//  Created by Naishadh Vora on 27/04/24.
//

import Foundation

class WatchlistViewModel: ObservableObject {
    @Published var watchlist: [WatchlistItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchWatchlist() {
        isLoading = true

        WatchlistData.watchlist.fetchWatchlist { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let watchlist):
                    self.watchlist = watchlist
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


