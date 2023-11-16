//
//  ZoomControlView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct ZoomControlView: View {
    
    @Binding var zoom: Float
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                zoom += 1
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.placeholder, lineWidth: 0.25)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.regularMaterial))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "plus")
                            .foregroundColor(AppColors.iconSecondary)
                            .font(.title)
                            .fontWeight(.medium)
                    }
            }
            
            Button {
                zoom -= 1
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.placeholder, lineWidth: 0.25)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.regularMaterial))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "minus")
                            .foregroundColor(AppColors.iconSecondary)
                            .font(.title)
                            .fontWeight(.medium)
                    }
            }
        }
    }
}

struct ZoomControlView_Previews: PreviewProvider {
    static var previews: some View {
        ZoomControlView(zoom: .constant(1))
    }
}
