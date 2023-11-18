//
//  TrackSlider.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 17.11.2023.
//

import SwiftUI

struct TrackSlider: View {
    
    @Binding var value: Double
    @Binding var total: Double
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack {
            Slider(
                value: $value,
                in: 0.0...total,
                step: 1,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            
            Text("\(value)")
                .foregroundColor(isEditing ? .red : .blue)
        }
    }
}

struct TrackSlider_Previews: PreviewProvider {
    static var previews: some View {
        TrackSlider(
            value: .constant(33),
            total: .constant(100),
            isEditing: .constant(false)
        )
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
