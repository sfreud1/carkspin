import SwiftUI

struct UsernameSetupView: View {
    @ObservedObject var userService: UserService
    @State private var username: String = ""
    @State private var isValidUsername: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("Kullanıcı Adın")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Arkadaşlarının seni bulabilmesi için bir kullanıcı adı seç")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
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
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isValidUsername ? Color.white : Color.gray.opacity(0.5))
                            .foregroundColor(isValidUsername ? .primary : .white)
                            .cornerRadius(25)
                            .shadow(radius: isValidUsername ? 10 : 0, x: 0, y: isValidUsername ? 5 : 0)
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