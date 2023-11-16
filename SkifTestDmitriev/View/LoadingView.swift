//
//  LoadingView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 15.11.2023.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var isShowing: Bool
    var text: String?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if isShowing {
                    Rectangle()
                        .fill(Color.black).opacity(isShowing ? 0.2 : 0)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        ProgressView()
                        Text(text ?? "").font(.body)
                    }
                    .padding(24)
                    .progressViewStyle(.automatic)
                    .background(.regularMaterial)
                    .foregroundColor(Color.primary)
                    .cornerRadius(16)
                }
            }
        }
    }
}
