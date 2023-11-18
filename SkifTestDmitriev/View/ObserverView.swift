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
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.placeholder, lineWidth: AppLayout.borderWidth)
                .background(content: {
                    if isObserve {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.accentColor)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.regularMaterial)
                    }
                })
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "eye")
                        .foregroundColor(isObserve ? .white : AppColors.icon)
                }
                .opacity(isEnabled ? 1 : 0)
        }
    }
}

struct ObserverView_Previews: PreviewProvider {
    static var previews: some View {
        ObserverView(isObserve: .constant(false))
    }
}
