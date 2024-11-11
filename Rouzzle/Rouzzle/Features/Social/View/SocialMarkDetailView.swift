//
//  SocialMarkDetailView.swift
//  Rouzzle
//
//  Created by 이다영 on 11/11/24.
//

import SwiftUI

struct SocialMarkDetailView: View {
    var userNickname: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack {
                    HStack {
                        Text(userNickname)
                            .font(.bold16)
                        Text("루즐러")
                            .font(.regular14)
                            .foregroundColor(.accent)
                    }
                }
                
                Spacer()
            }
            
        }
        .customNavigationBar(title: userNickname)
    }
}

#Preview {
    SocialMarkDetailView(userNickname: "기바오")
}
