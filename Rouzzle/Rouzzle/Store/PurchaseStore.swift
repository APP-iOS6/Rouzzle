//
//  PurchaseStore.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/22/24.
//

import Foundation
import Observation
import StoreKit
import FirebaseAuth
import FirebaseFirestore

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
            
            if puzzleProductIDs.contains(product.id) {
                print("퍼즐 조각 구매 성공")
                toastMessage = "퍼즐 조각 구매에 성공했습니다."
                await updatePuzzleCount(for: product)
                toastMessage = nil // 초기화
            } else {
                print("구독 상품 구매 성공")
                toastMessage = "구독 상품 구매에 성공했습니다."
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.toastMessage = nil
                }
            }
            
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
    private func extractPrice(from priceString: String) -> Double {
        // 숫자와 소수점만 남기고 나머지 제거
        let price = priceString.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined()
        return Double(price) ?? 0.0
    }
    
    // 퍼즐 구매하면 파이어베이스에 업데이트
    private func updatePuzzleCount(for product: Product) async {
        let increment: Int
        switch product.displayName {
        case "6조각":
            increment = 6
        case "12조각":
            increment = 12
        case "24조각":
            increment = 24
        case "48조각":
            increment = 48
        default:
            return
        }
        
        let userUid = Auth.auth().currentUser?.uid ?? Utils.getDeviceUUID()
        let userRef = Firestore.firestore().collection("User").document(userUid)
        
        do {
            try await userRef.updateData(["puzzleCount": FieldValue.increment(Int64(increment))])
            print("✅ Puzzle count updated by \(increment)")
        } catch {
            print("⛔️ Failed to update puzzle count: \(error)")
        }
    }
}
