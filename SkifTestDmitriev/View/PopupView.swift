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
                    
                    VStack {
                        content()
                            .padding()
                        
                        Rectangle()
                            .fill(AppColors.placeholder)
                            .frame(height: 0.25)
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            isShowing.toggle()
                        } label: {
                            Text("Закрыть")
                                .frame(height: 48)
                                .fontWeight(.medium)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(AppColors.placeholder, lineWidth: 0.25)
                    )
                    .frame(width: geometry.size.width - 21 - 21)
                    .background(.background)
                    .cornerRadius(cornerRadius)
                }
            }
        }
    }
}
