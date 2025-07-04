import SwiftUI

struct UsernameSetupView: View {
    @ObservedObject var userService: UserService
    @State private var username: String = ""
    @State private var isValidUsername: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.indigo, Color.teal]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 80, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Kullanıcı Adın")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Arkadaşlarının seni bulabilmesi için bir kullanıcı adı seç")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Kullanıcı adını gir", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title3)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .onChange(of: username) { newValue in
                                validateUsername(newValue)
                            }
                        
                        if !username.isEmpty {
                            Text(isValidUsername ? "✓ Kullanılabilir" : "✗ En az 3 karakter olmalı")
                                .font(.caption)
                                .foregroundColor(isValidUsername ? .green : .red)
                        }
                    }
                    
                    Button(action: {
                        userService.setUsername(username)
                    }) {
                        Text("Devam Et")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(
                                LinearGradient(colors: [Color.pink, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .opacity(isValidUsername ? 1 : 0.5)
                            )
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(isValidUsername ? 0.2 : 0), radius: 5, x: 0, y: 3)
                    }
                    .disabled(!isValidUsername || userService.isLoading)
                    .opacity(!isValidUsername || userService.isLoading ? 0.6 : 1.0)
                    
                    if userService.isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                            .tint(.white)
                    }
                    
                    if let errorMessage = userService.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
        }
    }
    
    private func validateUsername(_ username: String) {
        isValidUsername = username.count >= 3 && username.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
    }
}

#Preview {
    UsernameSetupView(userService: UserService())
}