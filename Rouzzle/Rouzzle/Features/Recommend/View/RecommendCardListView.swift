//
//  RecommendCardListView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI

struct RecommendCardListView: View {
    @Namespace private var animationNamespace
    @Binding var cards: [Card]
    @Binding var selectedRecommendTask: [RecommendTodoTask]
    @Binding var allCheckBtn: Bool
    @State private var selectedCardID: UUID?
    let addRoutine: (String, String, RoutineItem?) -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(cards) { card in
                        if selectedCardID == card.id {
                            expandedCard(card)
                                .id(card.id)
                                .transition(.opacity)
                        } else {
                            collapsedCard(card)
                                .id(card.id)
                        }
                    }
                }
                .padding(.top, 2)
                .padding(.bottom, 50)
            }
            .scrollIndicators(.hidden)
            .onChange(of: selectedCardID) { _, newValue in
                if let newValue {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo(newValue, anchor: .top)
                    }
                }
                allCheckBtn = false
                selectedRecommendTask.removeAll()
            }
            .onChange(of: cards) { _, _ in
                allCheckBtn = false
                selectedRecommendTask.removeAll()
            }
        }
    }
    
    private func collapsedCard(_ card: Card) -> some View {
        HStack(spacing: 15) {
            Text(card.imageName)
                .font(.system(size: 50))
                .frame(width: 60, height: 60)
                .matchedGeometryEffect(id: "image\(card.id)", in: animationNamespace)
            
            Text(card.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.basic)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .matchedGeometryEffect(id: "title\(card.id)", in: animationNamespace)
            
            if let subTitle = card.subTitle {
                Text(subTitle)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .font(.semibold14)
                    .background(.secondcolor)
                    .clipShape(.rect(cornerRadius: 12))
            }
            
            Image(systemName: "chevron.down")
                .foregroundStyle(.graymedium)
                .font(.system(size: 20, weight: .bold))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.graylight, lineWidth: 1)
                .matchedGeometryEffect(id: "background\(card.id)", in: animationNamespace)
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)) {
                selectedCardID = card.id
            }
        }
        .padding(.horizontal)
    }
    
    private func expandedCard(_ card: Card) -> some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.graylight, lineWidth: 1)
                    .padding(.top, 2)
                    .matchedGeometryEffect(id: "background\(card.id)", in: animationNamespace)
                
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)) {
                                    selectedCardID = nil
                                }
                            },
                            label: {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(.graymedium)
                                    .font(.system(size: 20, weight: .bold))
                                    .padding()
                            }
                        )
                    }
                    
                    Text(card.imageName)
                        .font(.system(size: 120))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .shadow(color: .black.opacity(0.2), radius: 5)
                        .matchedGeometryEffect(id: "image\(card.id)", in: animationNamespace)
                    
                    Text(card.title)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.basic)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "title\(card.id)", in: animationNamespace)
                        .padding(.horizontal)
                    
                    if let subTitle = card.subTitle {
                        Text(subTitle)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .font(.semibold14)
                            .background(.secondcolor)
                            .clipShape(.rect(cornerRadius: 18))
                            .padding(.horizontal)
                    }
                    
                    Text(card.fullText)
                        .font(.light16)
                        .foregroundColor(.descriptioncolor)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    
                    selectionSection(card)
                    
                    VStack(spacing: 8) {
                        ForEach(card.routines, id: \.title) { task in
                            RecommendTaskView(
                                task: task,
                                isSelected: selectedRecommendTask.contains(where: { $0.title == task.title }),
                                onTap: {
                                    let task = RecommendTodoTask(emoji: task.emoji, title: task.title, timer: task.timer)
                                    if selectedRecommendTask.contains(task) {
                                        selectedRecommendTask.removeAll { $0.title == task.title }
                                        allCheckBtn = selectedRecommendTask.count == card.routines.count
                                    } else {
                                        selectedRecommendTask.append(task)
                                        allCheckBtn = selectedRecommendTask.count == card.routines.count
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    RouzzleButton(
                        buttonType: .save,
                        disabled: selectedRecommendTask.isEmpty,
                        action: {
                            addRoutine(cards[0].title, cards[0].imageName, nil)
                        }
                    )
                    .padding(.horizontal)
                    .padding(.vertical)
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }
    
    private func selectionSection(_ card: Card) -> some View {
        HStack {
            Spacer()
            Button(
                action: {
                    if allCheckBtn {
                        allCheckBtn.toggle()
                        selectedRecommendTask.removeAll()
                    } else {
                        allCheckBtn.toggle()
                        selectedRecommendTask.removeAll()
                        for task in card.routines {
                            let task = RecommendTodoTask(emoji: task.emoji, title: task.title, timer: task.timer)
                            selectedRecommendTask.append(task)
                        }
                    }
                },
                label: {
                    HStack {
                        Image(systemName: allCheckBtn ? "checkmark.square" : "square")
                        Text("전체선택")
                            .font(.regular18)
                    }
                    .foregroundColor(allCheckBtn ? .black : .gray)
                }
            )
        }
        .padding(.horizontal)
    }
}
