//
//  DevInfoView.swift
//  Rouzzle
//
//  Created by Hyojeong on 11/23/24.
//

import SwiftUI

struct DevInfoView: View {
    @State private var showKHJGithub = false
    @State private var showDongbaoGithub = false
    @State private var showJeongbaoGithub = false
    @State private var showSimbaoGithub = false
    @State private var showYoshiGithub = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                InfoCard(imageName: "eagle", name: "김효정", assignedTask: "PM", action: { showKHJGithub.toggle() })
                InfoCard(imageName: "123", name: "김동경", assignedTask: "담당 업무", action: { showDongbaoGithub.toggle() })
                InfoCard(imageName: "123", name: "김정원", assignedTask: "담당 업무", action: { showJeongbaoGithub.toggle() })
                InfoCard(imageName: "123", name: "심현정", assignedTask: "담당 업무", action: { showSimbaoGithub.toggle() })
                InfoCard(imageName: "123", name: "이다영", assignedTask: "담당 업무", action: { showYoshiGithub.toggle() })
            }
            .padding(.vertical)
            .frame(maxHeight: .infinity, alignment: .top)
            .customNavigationBar(title: "개발자 정보")
            .sheet(isPresented: $showKHJGithub) {
                SafariView(url: URL(string: "https://github.com/71myo")!)
            }
            .sheet(isPresented: $showDongbaoGithub) {
                SafariView(url: URL(string: "https://github.com/dongykung")!)
            }
            .sheet(isPresented: $showJeongbaoGithub) {
                SafariView(url: URL(string: "https://github.com/gadisom")!)
            }
            .sheet(isPresented: $showSimbaoGithub) {
                SafariView(url: URL(string: "https://github.com/Hyeonjeong-Sim")!)
            }
            .sheet(isPresented: $showYoshiGithub) {
                SafariView(url: URL(string: "https://github.com/dardardardardar")!)
            }
        }
    }
}

struct InfoCard: View {
    let imageName: String
    let name: String
    let assignedTask: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: 24) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(name)
                        .font(.semibold16)
                    
                    Button {
                        action()
                    } label: {
                        Image(.github)
                            .resizable()
                            .frame(width: 17, height: 17)
                    }
                }
                
                Text(assignedTask)
                    .font(.regular14)
            }
            
            Spacer()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.graylight, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        DevInfoView()
    }
}
