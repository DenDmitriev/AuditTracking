//
//  ObserverView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct ObserverView: View {
    
    @Binding var isObserve: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
        Button {
            isObserve.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.placeholder, lineWidth: AppLayout.borderWidth)
                    .background(
                        buttonLabel(isObserve: isObserve)
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: "eye")
                    .foregroundColor(isObserve ? .white : AppColors.icon)
            }
            .opacity(isEnabled ? 1 : 0)
        }
    }
    
    private func buttonLabel(isObserve: Bool) -> some View {
        VStack {
            if isObserve {
                Color.clear
                    .background(
                        AppColors.accentColor
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Color.clear
                    .background(
                        VisualEffectView(effect: UIBlurEffect(style: .prominent))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

struct ObserverView_Previews: PreviewProvider {
    static var previews: some View {
        ObserverView(isObserve: .constant(false))
    }
}
