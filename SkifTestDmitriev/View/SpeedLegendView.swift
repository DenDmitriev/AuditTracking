//
//  SpeedLegendView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 14.11.2023.
//

import SwiftUI

struct SpeedLegendView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Легенда")
                .font(.title2)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Speed.allCases, id: \.rawValue) { speed in
                        HStack(spacing: .zero) {
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .background(Circle().fill(speed.color))
                                .frame(width: 32, height: 32)
                            
                            Text(" - " + speed.legend)
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct SpeedLegendView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedLegendView()
    }
}
