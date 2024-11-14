//
//  StatsView.swift
//  Rouzzle
//
//  Created by 김정원 on 11/5/24.
//

import SwiftUI

struct StatisticView: View {
    @State var viewModel = StatisticViewModel()
    @State private var isShowingGuide = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("통계")
                            .font(.semibold18)
                            .foregroundStyle(.basic)
                        Spacer()
                        PieceCounter(count: 9)
                    }
                    .padding(.top, 20)
                    
                    // 카테고리 뷰
                    StatisticCategoryView(isShowingGuide: $isShowingGuide)
                        .padding(.top, 20)
                }
                .padding(.horizontal)
                .padding(.bottom, 200)
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea()
        .overlay {
            if isShowingGuide {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea(edges: .all)
                        .onTapGesture {
                            isShowingGuide = false
                        }
                    
                    // 팝업 뷰
                    VStack(spacing: 20) {
                        Spacer()
                        VStack(spacing: 8) {
                            Text("월간 요약 보는 법")
                                .font(.bold18)
                                .padding(.top, 20)
                            
                            Text("날짜 선택 시 요약을 볼 수 있습니다.")
                                .font(.medium11)
                                .foregroundStyle(.gray)
                                .padding(.bottom, 20)
                        }
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "puzzlepiece.extension.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.partiallyCompletePuzzle)
                                Text("할 일 일부만 완료")
                                    .font(.medium11)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "puzzlepiece.extension.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.accentColor)
                                Text("할 일 전부 완료")
                                    .font(.medium11)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            isShowingGuide = false
                        } label: {
                            Text("확인")
                                .font(.medium16)
                                .foregroundStyle(.white)
                                .frame(width: 209, height: 40)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.bottom, 20)
                    }
                    .frame(width: 250, height: 286)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 10)
                }
            }
        }
    }
}

#Preview {
    StatisticView()
}
