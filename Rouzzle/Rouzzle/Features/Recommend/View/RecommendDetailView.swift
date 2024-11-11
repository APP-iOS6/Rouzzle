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
    let onTap: () -> Void
    @State private var selectedTasks: Set<String> = []
    
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
                
                Text(card.title)
                    .font(.bold30)
                    .bold()
                    .foregroundColor(.basic)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .matchedGeometryEffect(id: "title\(card.id)", in: animation)
                    .padding(.horizontal)
                
                Text(card.fullText)
                    .font(.light14)
                    .foregroundColor(.descriptioncolor)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                
                VStack(spacing: 8) {
                    ForEach(card.routines, id: \.title) { task in
                        RecommendTaskView(task: task, isSelected: selectedTasks.contains(task.title)) {
                            toggleTaskSelection(task.title)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 35)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: onTap) {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.graymedium)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .frame(width: 370, height: 757)
        .padding(.horizontal)
    }
    
    // 선택된 작업을 토글
    private func toggleTaskSelection(_ taskTitle: String) {
        if selectedTasks.contains(taskTitle) {
            selectedTasks.remove(taskTitle)
        } else {
            selectedTasks.insert(taskTitle)
        }
    }
}

#Preview {
    RecommendDetailView(
        card: DummyCardData.celebrityCards.first!,
        animation: Namespace().wrappedValue,
        onTap: {}
    )
}
