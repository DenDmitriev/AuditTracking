//
//  TrackSliderView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct TrackSliderView: View {
    
    @Binding var value: Int
    @Binding var total: Int
    @Binding var speed: Double?
    @Binding var isEditing: Bool
    
    @State var lastCoordinateValue: CGFloat = 0
    @State var isDisable: Bool = false
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let height: CGFloat = 3.0
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                let width = geometryProxy.size.width
                
                Group {
                    RoundedRectangle(cornerRadius: height)
                        .foregroundColor(AppColors.placeholder)
                        .frame(width: width, height: height)
                    
                    RoundedRectangle(cornerRadius: height)
                        .foregroundColor(.accentColor)
                        .frame(width: width * toPartable(value), height: height)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(.linear, value: width)
                    
                    ZStack {
                        HStack {
                            Circle()
                                .fill(value == .zero && isEnabled ? AppColors.placeholder : .accentColor)
                                .frame(width: height * 2)
                            Spacer()
                            Circle()
                                .fill(value == total && isEnabled ? .accentColor : AppColors.placeholder)
                                .frame(width: height * 2)
                        }
                    }
                }
                
                bubble
                    .position(x: width * toPartable(value), y: geometryProxy.size.height / 2)
                    .overlay {
                        if let speed {
                            Text(speed.formatted() + "км/ч")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.placeholder)
                                .position(x: width * toPartable(value), y: geometryProxy.size.height / 2)
                                .offset(y: -25)
                                .animation(.linear, value: width)
                        }
                        
                    }
                    .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                isEditing = true
                                if abs(value.translation.width) < 0.1 {
                                    self.lastCoordinateValue = toPartable(self.value) * width
                                }
                                if value.translation.width > 0 {
                                    let part = min(width, self.lastCoordinateValue + value.translation.width) / width
                                    self.value = toValueable(part)
                                } else {
                                    let part = max(0, self.lastCoordinateValue + value.translation.width) / width
                                    self.value = toValueable(part)
                                }
                            }
                            .onEnded { _ in
                                isEditing = false
                            }
                    )
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 8)
        
        
    }
    
    var bubble: some View {
        Circle()
            .strokeBorder(AppColors.background, lineWidth: 2)
            .background(
                Circle()
                    .foregroundColor(isEnabled ? AppColors.accentColor : AppColors.placeholder)
            )
            .frame(width: 20)
    }
    
    private func toPartable(_ value: Int) -> Double {
        var result = (Double(value) / Double(total))
        result *= 100
        let roundedResult = result.rounded() / 100
        return roundedResult
    }
    
    private func toValueable(_ part: Double) -> Int {
        let result = part * Double(total)
        return Int(result)
    }
}

struct TrackSliderView_Previews: PreviewProvider {
    static var previews: some View {
        TrackSliderView(value: .constant(50), total: .constant(100), speed: .constant(65), isEditing: .constant(false))
            .previewLayout(.fixed(width: 100, height: 100))
            .disabled(false)
    }
}
