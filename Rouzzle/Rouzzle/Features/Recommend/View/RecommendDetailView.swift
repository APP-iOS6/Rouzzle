//
//  RecommendDetailView.swift
//  Rouzzle
//
//  Created by Hyeonjeong Sim on 11/11/24.
//

import SwiftUI

struct RecommendDetailView: View {
    let card: Card
    let animation: Namespace.ID
    @Binding var selectedRecommendTask: [RecommendTodoTask]
    @Binding var allCheckBtn: Bool
    let onTap: () -> Void
    let addRoutine: (RoutineItem?) -> Void
    @State private var routineSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.3)]
    @State private var toast: ToastModel?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.graylight, lineWidth: 1)
                .matchedGeometryEffect(id: "background\(card.id)", in: animation)
                .frame(width: 370, height: 757)
            
            VStack(alignment: .leading, spacing: 14) {
                Spacer().frame(height: 20)
                
                Text(card.imageName)
                    .font(.system(size: 120))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .shadow(color: .black.opacity(0.2), radius: 5)
                    .matchedGeometryEffect(id: "image\(card.id)", in: animation)
                
                HStack {
                    Text(card.title)
                        .font(.bold30)
                        .bold()
                        .foregroundStyle(.basic)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "title\(card.id)", in: animation)
                        .padding(.horizontal)
                    
                    if let subTitle = card.subTitle {
                        Text(subTitle)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .font(.semibold14)
                            .background(.secondcolor)
                            .clipShape(.rect(cornerRadius: 18))
                            .padding(.leading, 8)
                    }
                }
                
                Text(card.fullText)
                    .font(.light16)
                    .foregroundStyle(.descriptioncolor)
                    .lineSpacing(5)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                
                HStack {
                    Image(systemName: allCheckBtn ? "checkmark.square" : "square")
                    Text("전체선택")
                        .font(.regular18)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(allCheckBtn ? .black : .gray)
                .onTapGesture {
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
                }
                
                VStack(spacing: 8) {
                    ForEach(card.routines, id: \.title) { task in
                        RecommendTaskView(task: task, isSelected: selectedRecommendTask.contains(where: { $0.title == task.title })) {
                            let task = RecommendTodoTask(emoji: task.emoji, title: task.title, timer: task.timer)
                            toggleTaskSelection(task)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 24)
                
                RouzzleButton(buttonType: .save, disabled: selectedRecommendTask.isEmpty) {
                    routineSheet.toggle()
                }
                .disabled(selectedRecommendTask.isEmpty)
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: onTap) {
                        Image(systemName: "chevron.up")
                            .foregroundStyle(.graymedium)
                            .padding()
                            .padding(.top, 20)
                    }
                }
                Spacer()
            }
        }
        .animation(.smooth, value: selectedRecommendTask)
        .frame(width: 370, height: 757)
        .padding(.horizontal)
        .sheet(isPresented: $routineSheet) {
            RecommendSheet(tasks: selectedRecommendTask) { routineItem in
                addRoutine(routineItem)
            }
            .presentationDetents(detents)
            .interactiveDismissDisabled()
        }
    }
    
    // 선택된 작업을 토글
    private func toggleTaskSelection(_ task: RecommendTodoTask) {
        if selectedRecommendTask.contains(task) {
            selectedRecommendTask.removeAll { $0.title == task.title }
            allCheckBtn = selectedRecommendTask.count == card.routines.count
        } else {
            selectedRecommendTask.append(task)
            allCheckBtn = selectedRecommendTask.count == card.routines.count
        }
    }
}

#Preview {
    RecommendDetailView(
        card: DummyCardData.celebrityCards.first!,
        animation: Namespace().wrappedValue,
        selectedRecommendTask: .constant([]),
        allCheckBtn: .constant(false),
        onTap: {},
        addRoutine: { _ in }
    )
}
