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
    
    private let puzzleProductIDs: [String] = ["techit.Rouzzle.6", "techit.Rouzzle.12", "techit.Rouzzle.24", "techit.Rouzzle.48"]
    private let subsProductIDs: [String] = ["techit.Rouzzle.Monthly", "techit.Rouzzle.Yearly"]
    
    var toastMessage: String?
    var loadState: LoadState = . none

    // 정렬된 상품 리스트(가격 적은 순)
    var sortedProducts: [Product] {
        products.sorted { lhs, rhs in
            let lhsPrice = extractPrice(from: lhs.displayPrice)
            let rhsPrice = extractPrice(from: rhs.displayPrice)
            return lhsPrice < rhsPrice
        }
    }
    
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
    
    /// 퍼즐 상품 로드
    func loadPuzzleProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: puzzleProductIDs)
        self.productsLoaded = true
    }
    
    /// 구매 시작
    func purchase(_ product: Product) async throws {
        loadState = .loading
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            loadState = .completed
            print("퍼즐 조각 잘 샀음")
            toastMessage = "퍼즐 구매에 성공했습니다."
        case .success(.unverified):
            // 구매를 성공했으나, verified 실패
            loadState = .none
        case .pending:
            loadState = .none
        case .userCancelled:
            loadState = .none
        @unknown default:
            loadState = .none
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
    
    // 가격 추출 함수
    func extractPrice(from priceString: String) -> Double {
        // 숫자와 소수점만 남기고 나머지 제거
        let price = priceString.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined()
        return Double(price) ?? 0.0
    }
}
