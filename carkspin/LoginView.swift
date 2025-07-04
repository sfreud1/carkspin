import SwiftUI
import GoogleSignIn

struct LoginView: View {
    @ObservedObject var authService: AuthenticationService
    
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
                    Image(systemName: "sparkles")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("ÇarkSpin")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Arkadaşlarınla eğlenceli kararlar verin!")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button(action: {
                        authService.signInWithGoogle()
                    }) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.blue)
                            
                            Text("Google ile Giriş Yap")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .foregroundColor(.primary)
                        .cornerRadius(25)
                        .shadow(radius: 10, x: 0, y: 5)
                    }
                    .disabled(authService.isLoading)
                    .opacity(authService.isLoading ? 0.6 : 1.0)
                    
                    if authService.isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                            .tint(.white)
                    }
                    
                    if let errorMessage = authService.errorMessage {
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
}

#Preview {
    LoginView(authService: AuthenticationService())
}