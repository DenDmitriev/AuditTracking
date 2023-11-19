//
//  PopupView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 15.11.2023.
//

import SwiftUI

struct PopupView<Content>: View where Content: View {
    
    @Binding var isShowing: Bool
    var content: () -> Content
    
    let cornerRadius: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if isShowing {
                    Rectangle()
                        .fill(Color.black).opacity(isShowing ? 0.2 : 0)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        content()
                            .padding()
                            .border(width: AppLayout.borderWidth, edges: [.bottom], color: AppColors.placeholder)
                        
                        Button {
                            isShowing.toggle()
                        } label: {
                            Text("Закрыть")
                                .frame(height: 48)
                                .font(AppFonts.titleTwo)
                        }
                    }
                    .frame(width: geometry.size.width - 21 - 21)
                    .background(
                        VisualEffectView(effect: UIBlurEffect(style: .prominent))
                    )
                    .cornerRadius(cornerRadius)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(AppColors.placeholder, lineWidth: AppLayout.borderWidth)
                }
            }
        }
    }
}
