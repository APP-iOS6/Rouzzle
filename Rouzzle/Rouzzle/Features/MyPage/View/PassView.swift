//
//  PassView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/11/24.
//

import SwiftUI
import StoreKit

struct PassView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var purchaseStore = PurchaseStore()
    @State private var selectedProduct: Product? // 선택된 상품

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [.white, Color.fromRGB(r: 252, g: 255, b: 240)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.bold30)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
                
                Text("당신의 일상에 작은 변화,\n루즐 패스로 시작하세요!")
                    .font(.bold18)
                    .lineSpacing(4)
                    .padding(.vertical, 40)
                
                if purchaseStore.products.isEmpty {
                    VStack(alignment: .center) {
                        ProgressView()
                            .font(.medium18)
                        
                        Text("상품을 불러오는 중입니다...")
                            .font(.regular14)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
                } else {
                    ForEach(purchaseStore.sortedProducts, id: \.id) { product in
                        Button {
                            selectedProduct = product // 선택된 상품 업데이트
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(product.displayName)
                                        .font(.semibold16)
                                        .foregroundStyle(.black)
                                    
                                    Text(product.description)
                                        .font(.regular14)
                                        .foregroundStyle(.black)
                                }
                                
                                Spacer()
                                
                                Text(product.displayPrice)
                                    .font(.bold16)
                                    .foregroundStyle(.accent)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white)
                            )
                            .overlay(
                                // 선택된 상품에 스트로크 표시
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedProduct == product ? Color.accent : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .padding(.horizontal, 2)
                            .shadow(color: .black.opacity(0.1), radius: 2)
                        }
                    }
                    .padding(.top)
                }
                
                Text("구독 혜택")
                    .font(.bold16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 33)
                
                VStack(alignment: .leading) {
                    HStack {
                        Circle()
                            .frame(width: 46)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("어쩌구 혜택")
                                .font(.semibold14)
                            
                            Text("어쩌구 혜택 효과 어쩌구 혜택 효과 어쩌구")
                                .font(.regular14)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    HStack {
                        Circle()
                            .frame(width: 46)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("어쩌구 혜택")
                                .font(.semibold14)
                            
                            Text("어쩌구 혜택 효과 어쩌구 혜택 효과 어쩌구")
                                .font(.regular14)
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                .shadow(color: .black.opacity(0.1), radius: 2)
                .padding(.horizontal, 2)
            }
            .padding(.horizontal)
            
            VStack {
                Spacer()
                
                VStack(spacing: 18) {
                    Text("언제든지 걱정없이 취소할 수 있어요.")
                        .font(.regular14)
                        .foregroundStyle(.accent)
                        .padding(.top)

                    Button {
                        if let product = selectedProduct {
                            Task {
                                do {
                                    try await purchaseStore.purchase(product) // 선택된 상품 구매
                                }
                            }
                        }
                    } label: {
                        if purchaseStore.loadState == .loading {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 45)
                                .font(.bold20)
                        } else {
                            Text(selectedProduct != nil ? "\(selectedProduct!.displayName)하기" : "상품을 선택해 주세요")
                                .frame(maxWidth: .infinity, minHeight: 45)
                                .font(.bold20)
                        }
                        
                    }
                    .disabled(selectedProduct == nil || purchaseStore.loadState == .loading) // 선택된 상품이 없거나 로딩 중일 때 비활성화
                    .padding(.horizontal)
                    .padding(.bottom, 18)
                    .buttonStyle(.borderedProminent)
                }
                .background(
                    Rectangle()
                        .fill(.white)
                        .ignoresSafeArea(edges: .bottom)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -2)
                )
            }
        }
        .onAppear {
            Task {
                do {
                    try await purchaseStore.loadSubsProducts()
                }
            }
        }
    }
}

#Preview {
    PassView()
}
