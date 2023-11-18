//
//  CustomLabel.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 15.11.2023.
//

import SwiftUI

struct CustomLabel: View {
    
    let name: String?
    let systemName: String?
    let text: String
    
    init(name: String? = nil, systemName: String? = nil, text: String) {
        self.name = name
        self.systemName = systemName
        self.text = text
    }
    
    var body: some View {
        HStack(spacing: 2) {
            if let systemName {
                Image(systemName: systemName)
                    .font(.body)
                    .foregroundColor(AppColors.icon)
            } else if let name {
                Image(name)
                    .font(.body)
                    .foregroundColor(AppColors.icon)
            }
            
            Text(text)
        }
    }
}

struct CustomLabel_Previews: PreviewProvider {
    static var previews: some View {
        CustomLabel(systemName: "eye", text: "Text")
    }
}
