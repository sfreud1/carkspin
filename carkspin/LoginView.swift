import SwiftUI
import GoogleSignIn

struct LoginView: View {
    @ObservedObject var authService: AuthenticationService
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.green.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 80, weight: .black, design: .rounded))
                        .foregroundStyle(.yellow)

                    Text("ÇarkSpin")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(.yellow)

                    Text("Arkadaşlarınla eğlenceli kararlar verin!")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.yellow.opacity(0.9))
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
                                .font(.title3)
                            Text("Google ile Giriş Yap")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.yellow)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            LinearGradient(colors: [Color.green, Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    .disabled(authService.isLoading)
                    .opacity(authService.isLoading ? 0.6 : 1.0)
                    
                    if authService.isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                            .tint(.yellow)
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