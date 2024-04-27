//
//  PortfolioViewModel.swift
//  Stock
//
//  Created by Naishadh Vora on 26/04/24.
//

import Foundation

class PortfolioViewModel: ObservableObject {
    @Published var portfolio: [PortfolioItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchPortfolio() {
        isLoading = true

        PortfolioData.portfolio.fetchPortfolio { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let portfolio):
                    self.portfolio = portfolio
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


