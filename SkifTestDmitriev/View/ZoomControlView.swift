//
//  ZoomControlView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct ZoomControlView: View {
    
    @Binding var zoom: Float
    
    private let minZoom: Float = 2.0
    private let maxZoom: Float = 21.0
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                zoom += 1
            } label: {
                buttonLabel(systemImage: "plus")
                    .opacity(isEnable(.in) ? 0 : 1)
            }
            .disabled(isEnable(.in))
            
            Button {
                zoom -= 1
            } label: {
                buttonLabel(systemImage: "minus")
                    .opacity(isEnable(.out) ? 0 : 1)
            }
            .disabled(isEnable(.out))
        }
    }
    
    private func buttonLabel(systemImage: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.placeholder, lineWidth: AppLayout.borderWidth)
                .background(
                    Color.clear
                        .background(
                            VisualEffectView(effect: UIBlurEffect(style: .prominent))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
                .frame(width: 44, height: 44)
            
            Image(systemName: systemImage)
                .foregroundColor(AppColors.iconSecondary)
                .font(AppFonts.icon)
        }
    }
    
    enum ZoomAction {
        case `in`, out
    }
    
    private func isEnable(_ zoomAction: ZoomAction) -> Bool {
        switch zoomAction {
        case .in:
            return zoom.rounded(.up) == maxZoom
        case .out:
            return zoom.rounded(.down) == minZoom
        }
    }
}

struct ZoomControlView_Previews: PreviewProvider {
    static var previews: some View {
        ZoomControlView(zoom: .constant(1))
    }
}
