//
//  ShopView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/12/24.
//

import SwiftUI
import StoreKit

struct ShopView: View {
    
    @Environment(RoutineStore.self) private var routineStore
    @State private var purchaseStore = PurchaseStore()
    @State private var toast: ToastModel?

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [.white, Color.fromRGB(r: 252, g: 255, b: 240)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("퍼즐 조각 구매")
                    .font(.semibold16)
                    .padding(.top, 27)
                
                VStack {
                    if purchaseStore.products.isEmpty {
                        VStack(alignment: .center) {
                            ProgressView()
                                .font(.medium18)
                            
                            Text("상품을 불러오는 중입니다...")
                                .font(.regular14)
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(Array(purchaseStore.sortedProducts.enumerated()), id: \.element.id) { index, product in
                            ShopRow(purchaseStore: purchaseStore,
                                    quantity: product.displayName,
                                    price: product.displayPrice,
                                    buttonAction: { completion in
                                Task {
                                    do {
                                        try await purchaseStore.purchase(product)
                                        completion() // 구매 완료 시 로딩 상태 해제
                                    }
                                }
                            })
                            
                            if index < purchaseStore.products.count - 1 {
                                Divider()
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .stroke(Color.fromRGB(r: 217, g: 217, b: 217), lineWidth: 0.8)
                )
            }
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                do {
                    try await purchaseStore.loadPuzzleProducts()
                }
            }
        }
        .padding(.horizontal, -16)
        .toastView(toast: $toast)
        .onChange(of: purchaseStore.toastMessage, { _, new in
            guard let msg = new else {
                return
            }
            toast = ToastModel(type: .success, message: msg)
            routineStore.fetchMyData()
        })
        .customNavigationBar(title: "SHOP")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                PieceCounter(
                    count: routineStore.myPuzzle,
                    phase: routineStore.puzzlePhase
                ) {
                    routineStore.fetchMyData()
                }
            }
        }
    }
}

struct ShopRow: View {
    @State var purchaseStore: PurchaseStore
    let quantity: String
    let price: String
    let buttonAction: (@escaping () -> Void) -> Void
    @State private var isLoading: Bool = false

    var body: some View {
        HStack(spacing: 7) {
            Image(.piece)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 2)
            
            Image(systemName: "xmark")
                .foregroundStyle(.accent)
                .font(.system(size: 14, weight: .regular))
            
            Text(quantity)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Button {
                isLoading = true
                buttonAction {
                    isLoading = false
                }
            } label: {
                if isLoading {
                    ProgressView()
                        .frame(width: 70, height: 30)
                        .font(.semibold12)
                        .foregroundStyle(.accent)
                        .background(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(Color.accent, lineWidth: 1)
                        )
                } else {
                    Text(price)
                        .frame(width: 70, height: 30)
                        .font(.semibold12)
                        .foregroundStyle(.accent)
                        .background(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(Color.accent, lineWidth: 1)
                        )
                }
            }
            .disabled(isLoading)
        }
    }
}

#Preview {
    NavigationStack {
        ShopView()
    }
}
