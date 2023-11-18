//
//  ViewExtension.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 18.11.2023.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
