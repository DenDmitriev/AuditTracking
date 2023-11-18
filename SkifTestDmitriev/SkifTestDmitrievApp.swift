//
//  SkifTestDmitrievApp.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if let googleApiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY") as? String {
            GMSServices.provideAPIKey(googleApiKey)
        }
        return true
    }
}

@main
struct SkifTestDmitrievApp: App {
    
    @StateObject private var trackManager: TrackManager = .init()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    var body: some Scene {
        var contentViewModel: ContentViewModel = .init(trackManager: trackManager)
        
        WindowGroup {
            ContentView(viewModel: contentViewModel)
                .environmentObject(trackManager)
        }
    }
}
