//
//  RecommendCardListView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI

struct RecommendCardListView: View {
    @Binding var cards: [Card]
    @Binding var selectedRecommendTask: [RecommendTodoTask]
    @Binding var allCheckBtn: Bool
    @State private var selectedCardID: UUID?
    @State private var showingRoutineSheet = false
    let addRoutine: (String, String, RoutineItem?) -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(cards) { card in
                        Group {
                            if selectedCardID == card.id {
                                expandedCard(card)
                                    .id("\(card.id)-expanded")
                            } else {
                                collapsedCard(card)
                                    .id("\(card.id)-collapsed")
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: selectedCardID)
                    }
                }
                .padding(.top, 2)
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .scrollIndicators(.hidden)
            .onChange(of: selectedCardID) { _, _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    allCheckBtn = false
                    selectedRecommendTask.removeAll()
                    
                    if let selectedID = selectedCardID {
                        proxy.scrollTo("\(selectedID)-expanded", anchor: .top)
                    }
                }
            }
        }
    }
    private func cardContainer<Content: View>(_ content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.graylight, lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
    }
    
    private func collapsedCard(_ card: Card) -> some View {
        cardContainer(
            HStack(spacing: 16) {
                Text(card.imageName)
                    .font(.system(size: 35))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 6) {
                    if let subTitle = card.subTitle {
                        Text(subTitle)
                            .font(.medium11)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .frame(height: 16)
                            .background(
                                Capsule()
                                    .fill(Color.themeColor)
                            )
                            .padding(.top, 5)
                    }
                    
                    Text(card.title)
                        .font(.bold16)
                        .foregroundStyle(Color.subBlack)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(.graymedium)
                    .font(.system(size: 20, weight: .regular))
                    .padding(.trailing, 8)
            }
            .padding(.vertical, 12)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedCardID = card.id
            }
        }
    }
    
    private func expandedCard(_ card: Card) -> some View {
        cardContainer(
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Text(card.imageName)
                        .font(.system(size: 35))
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        if let subTitle = card.subTitle {
                            Text(subTitle)
                                .font(.medium11)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .frame(height: 16)
                                .background(
                                    Capsule()
                                        .fill(Color.themeColor)
                                )
                                .padding(.top, 5)
                        }
                        
                        Text(card.title)
                            .font(.bold16)
                            .foregroundStyle(Color.subBlack)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.up")
                        .foregroundStyle(.graymedium)
                        .font(.system(size: 20, weight: .regular))
                        .padding(.trailing, 8)
                        .rotationEffect(.degrees(selectedCardID == card.id ? 180 : 0))
                        .animation(.easeInOut, value: selectedCardID)
                }
                .padding(.vertical, 12)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedCardID = nil
                    }
                }
                
                Text(card.fullText)
                    .font(.light16)
                    .foregroundStyle(.descriptioncolor)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                HStack {
                    Spacer()
                    Button(action: {
                        if allCheckBtn {
                            allCheckBtn.toggle()
                            selectedRecommendTask.removeAll()
                        } else {
                            allCheckBtn.toggle()
                            selectedRecommendTask = card.routines.map {
                                RecommendTodoTask(emoji: $0.emoji, title: $0.title, timer: $0.timer)
                            }
                        }
                    }, label: {
                        HStack {
                            Image(systemName: allCheckBtn ? "checkmark.square" : "square")
                            Text("전체선택")
                                .font(.regular12)
                        }
                        .foregroundStyle(allCheckBtn ? .black : .gray)
                    })
                }
                .padding(.vertical, 12)
                
                VStack(spacing: 8) {
                    ForEach(card.routines, id: \.title) { task in
                        RecommendTaskView(
                            task: task,
                            isSelected: selectedRecommendTask.contains(where: { $0.title == task.title }),
                            onTap: {
                                let task = RecommendTodoTask(emoji: task.emoji, title: task.title, timer: task.timer)
                                if selectedRecommendTask.contains(task) {
                                    selectedRecommendTask.removeAll { $0.title == task.title }
                                } else {
                                    selectedRecommendTask.append(task)
                                }
                                allCheckBtn = selectedRecommendTask.count == card.routines.count
                            }
                        )
                    }
                }
                .padding(.vertical, 8)
                
                RouzzleButton(
                    buttonType: .addtoroutine,
                    disabled: selectedRecommendTask.isEmpty,
                    action: {
                        showingRoutineSheet = true
                    }
                )
                .padding(.vertical)
            }
        )
        .sheet(isPresented: $showingRoutineSheet) {
            RecommendSheet(tasks: selectedRecommendTask) { routine in
                addRoutine(card.title, card.imageName, routine)
            }
            .presentationDetents([.fraction(0.3)])
            .interactiveDismissDisabled()
        }
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
                            .font(.regular14)
                    }
                    .foregroundStyle(allCheckBtn ? .black : .gray)
                }
            )
        }
        .padding(.horizontal)
    }
}
