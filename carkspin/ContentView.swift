//
//  ContentView.swift
//  carkspin
//
//  Created by Doğan Topcu on 4.07.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authService = AuthenticationService()
    @StateObject private var userService = UserService()
    @State private var showFriends = false
    
    var body: some View {
        ZStack {
            if !authService.isSignedIn {
                LoginView(authService: authService)
            } else if !userService.isUsernameSet {
                UsernameSetupView(userService: userService)
            } else {
                SpinWheelView()
                    .sheet(isPresented: $showFriends) {
                        FriendsView(userService: userService)
                    }
            }
        }
        .onReceive(authService.$isSignedIn) { isSignedIn in
            if isSignedIn, let user = authService.user {
                userService.loadUserData(uid: user.uid)
            }
        }
    }
}

#Preview {
    ContentView()
}
