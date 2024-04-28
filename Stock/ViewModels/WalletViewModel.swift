//
//  WalletViewModel.swift
//  Stock
//
//  Created by Naishadh Vora on 26/04/24.
//

import Foundation

class WalletViewModel: ObservableObject {
    @Published var money: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchWallet() {
        isLoading = true
        
        WalletData.wallet.fetchWallet { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let money):
                    self.money = money
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

