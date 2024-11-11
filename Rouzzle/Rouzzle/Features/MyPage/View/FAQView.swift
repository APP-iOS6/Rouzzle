//
//  FAQView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/11/24.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        ZStack {
            Color.backgroundLightGray
                .edgesIgnoringSafeArea(.bottom)
            
            ScrollView {
                ForEach(DummyFAQ.faqs) { faq in
                    LazyVStack(alignment: .leading) {
                        DisclosureGroup {
                            Divider()
                            Text(faq.answer)
                                .font(.regular16)
                                .lineSpacing(6)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                        } label: {
                            Text(faq.question)
                                .font(.semibold18)
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                        }
                        .padding(.horizontal)
                        .tint(Color.subHeadlineFontColor)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                        
                    )
                    .padding(.top)
                }
            }
            .customNavigationBar(title: "FAQ")
        }
    }
}

// MARK: - 테스트용 더미 데이터
struct DummyFAQ: Identifiable, Decodable {
    var id: UUID = UUID()
    let question: String
    let answer: String
    
    static var faqs = [
        DummyFAQ(question: "Q. 어쩌구 저쩌구", answer: "답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 "),
        DummyFAQ(question: "Q. 어쩌구 저쩌구2", answer: "답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 "),
        DummyFAQ(question: "Q. 어쩌구 저쩌구3", answer: "답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 "),
        DummyFAQ(question: "Q. 어쩌구 저쩌구4", answer: "답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 답변 텍스트 ")
    ]
}

#Preview {
    NavigationStack {
        FAQView()
    }
}
