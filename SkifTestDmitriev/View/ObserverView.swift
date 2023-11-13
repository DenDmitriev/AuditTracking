//
//  ObserverView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct ObserverView: View {
    
    @Binding var isObserve: Bool
    
    var body: some View {
        Button {
            isObserve.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.placeholder, lineWidth: 0.25)
                .background(RoundedRectangle(cornerRadius: 10).fill(.regularMaterial))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: isObserve ? "eye.fill" : "eye")
                        .foregroundColor(AppColors.icon)
                }
        }
    }
}

struct ObserverView_Previews: PreviewProvider {
    static var previews: some View {
        ObserverView(isObserve: .constant(false))
    }
}
