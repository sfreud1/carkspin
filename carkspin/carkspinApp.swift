//
//  carkspinApp.swift
//  carkspin
//
//  Created by Doğan Topcu on 4.07.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

@main
struct carkspinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let clientId = plist["CLIENT_ID"] as? String {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
