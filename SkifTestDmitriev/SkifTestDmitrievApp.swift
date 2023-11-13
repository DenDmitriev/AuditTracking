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
        GMSServices.provideAPIKey("")
        return true
    }
}

@main
struct SkifTestDmitrievApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
