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

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.graylight, lineWidth: 1)
                .matchedGeometryEffect(id: "background\(card.id)", in: animation)
            
            VStack(alignment: .leading, spacing: 14) {
                Spacer().frame(height: 20)
                
                Text(card.imageName)
                    .font(.system(size: 120))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .shadow(color: .black.opacity(0.2), radius: 5)
                    .matchedGeometryEffect(id: "image\(card.id)", in: animation)
                
                Text(card.title)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.basic)
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
                        .padding(.horizontal)
                }
                
                Text(card.fullText)
                    .font(.light16)
                    .foregroundColor(.descriptioncolor)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                
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
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(card.routines, id: \.title) { task in
                            RecommendTaskView(
                                task: task,
                                isSelected: selectedRecommendTask.contains(where: { $0.title == task.title }),
                                onTap: {
                                    let task = RecommendTodoTask(emoji: task.emoji, title: task.title, timer: task.timer)
                                    toggleTaskSelection(task)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .frame(height: 250)
                
                Spacer()
                
                RouzzleButton(
                    buttonType: .save,
                    disabled: selectedRecommendTask.isEmpty,
                    action: {
                        routineSheet.toggle()
                    }
                )
                .padding(.horizontal)
                .padding(.vertical)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(
                        action: onTap,
                        label: {
                            Image(systemName: "chevron.up")
                                .foregroundColor(.graymedium)
                                .font(.system(size: 20, weight: .bold))
                                .padding()
                        }
                    )
                }
                Spacer()
            }
        }
        .frame(maxWidth: 370)
        .frame(height: UIScreen.main.bounds.height * 0.8)
        .sheet(isPresented: $routineSheet) {
            RecommendSheet(tasks: selectedRecommendTask, saveRoutine: addRoutine)
                .presentationDetents(detents)
                .interactiveDismissDisabled()
        }
    }
    
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
