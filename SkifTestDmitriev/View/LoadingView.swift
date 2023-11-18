//
//  LoadingView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 15.11.2023.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var isShowing: Bool
    @Binding var text: String?
    @Binding var progress: LoadingProgress?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if isShowing {
                    Rectangle()
                        .fill(Color.black).opacity(isShowing ? 0.2 : 0)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        if let progress {
                            ProgressView(value: Double(progress.value), total: Double(progress.total)) {  }
                                .foregroundColor(AppColors.accentColor)
                        } else {
                            ProgressView()
                        }
                        
                        Text(text ?? "").font(.body)
                    }
                    .padding(24)
                    .background(.regularMaterial)
                    .foregroundColor(Color.primary)
                    .cornerRadius(16)
                    .frame(
                        minWidth: geometry.size.width / 3,
                        idealWidth: geometry.size.width / 2,
                        maxWidth: geometry.size.width - 64
                    )
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowing: .constant(true), text: .constant("Message"), progress: .constant(nil))
    }
}

