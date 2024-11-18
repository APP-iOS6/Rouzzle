//
//  ShopView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/12/24.
//

import SwiftUI

struct ShopView: View {
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
                    ShopRow(quantity: 6, price: "₩ 1,500", buttonAction: {})
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    ShopRow(quantity: 12, price: "₩ 3,000", buttonAction: {})
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    ShopRow(quantity: 24, price: "₩ 4,000", buttonAction: {})
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    ShopRow(quantity: 48, price: "₩ 5,000", buttonAction: {})
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
        .padding(.horizontal, -16)
        .customNavigationBar(title: "SHOP")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                PieceCounter(count: 9, isButtonEnabled: false)
            }
        }
    }
}

struct ShopRow: View {
    let quantity: Int
    let price: String
    let buttonAction: () -> Void

    var body: some View {
        HStack(spacing: 7) {
            Image(.piece)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 2)
            
            Image(systemName: "xmark")
                .foregroundStyle(.accent)
                .font(.system(size: 14, weight: .regular))
            
            Text("\(quantity)")
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Button(action: buttonAction) {
                Text(price)
                    .frame(width: 70, height: 30)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.accent)
                    .background(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(Color.accent, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShopView()
    }
}
