//
//  ContentView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    
    @State var isObserve: Bool = false
    @State var zoom: Double = 1.0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapViewControllerBridge()
                .overlay {
                    ZoomControlView(zoom: $zoom)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(16)
                        .offset(y: -20)
                }
            
            VStack(spacing: 0) {
                ObserverView(isObserve: $isObserve)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(16)
                
                ControlView()
                    .background(.regularMaterial)
                    .overlay {
                        VStack {
                            Rectangle()
                                .fill(AppColors.placeholder)
                            .frame(height: 0.25)
                            Spacer()
                        }
                }
                    .padding(.bottom, 16)
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
