//
//  PurchaseStore.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/22/24.
//

import Foundation
import Observation
import StoreKit

@Observable
class PurchaseStore {
    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs: Set<String> = []
    private var productsLoaded = false
    
    private let puzzleProductIDs: [String] = ["techit.Rouzzle.6x", "techit.Rouzzle.12x", "", "", "", ""]
    
    private let subsProductIDs: [String] = ["techit.Rouzzle.Monthly", "techit.Rouzzle.Yearly"]
    
    init() {
        Task {
            await listenForTransactions()
        }
    }
    
    /// 구독 상품 로드
    func loadSubsProducts() async throws {
           guard !self.productsLoaded else { return }
           self.products = try await Product.products(for: subsProductIDs)
           self.productsLoaded = true
       }
    
    /// 구매 시작
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
        case let .success(.unverified(_, error)):
            // 구매를 성공했으나, verified 실패
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }
    
    // Transaction 업데이트 청취
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            guard case .verified(let transaction) = result else { continue }
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
            await transaction.finish()
        }
    }
}
