import SwiftUI

struct FriendsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var userService: UserService
    @State private var searchText: String = ""
    @State private var searchResults: [UserModel] = []
    @State private var isSearching: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.indigo, Color.teal]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Üst kısım - Başlık ve arama
                    VStack(spacing: 20) {
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.8))
                                    .background(Circle().fill(.ultraThinMaterial))
                            }
                            
                            Spacer()
                            
                            Text("Arkadaş Ara")
                                .font(.system(size: 24, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            // Boş alan denge için
                            Color.clear
                                .frame(width: 32, height: 32)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Modern arama kutusu
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 18))

                            TextField("Kullanıcı adı ara...", text: $searchText)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.primary)
                                .onSubmit {
                                    searchUsers()
                                }
                                .onChange(of: searchText) { newValue in
                                    if newValue.isEmpty {
                                        searchResults = []
                                    } else if newValue.count >= 2 {
                                        searchUsers()
                                    }
                                }
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    searchResults = []
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                    
                    // İçerik alanı
                    if isSearching {
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            Text("Aranıyor...")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if searchResults.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "person.fill.questionmark")
                                .font(.system(size: 50))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("Kullanıcı bulunamadı")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Text("'\(searchText)' ile eşleşen kullanıcı bulunamadı")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 40)
                    } else if searchText.isEmpty {
                        VStack(spacing: 25) {
                            Image(systemName: "person.2.badge.plus")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.6))
                            
                            VStack(spacing: 10) {
                                Text("Arkadaş Keşfet")
                                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                                    .foregroundStyle(.white)
                                
                                Text("Kullanıcı adı ile arkadaşlarını bul\nve birlikte çark çevirin!")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.85))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 40)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(searchResults) { user in
                                    UserCard(user: user)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        }
                        .animation(.easeInOut(duration: 0.3), value: searchResults)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func searchUsers() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        userService.searchUsers(query: searchText) { results in
            DispatchQueue.main.async {
                self.searchResults = results
                self.isSearching = false
            }
        }
    }
}


struct UserCard: View {
    let user: UserModel
    @State private var isInviteSent: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Profil fotoğrafı
            AsyncImage(url: URL(string: user.photoURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.indigo.opacity(0.3), .teal.opacity(0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                    
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 2)
            )
            
            // Kullanıcı bilgileri
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("@\(user.username ?? "")")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                Text(user.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                // Aktif durumu (şimdilik mock)
                HStack(spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                    Text("Aktif")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            // Spin butonu
            Button(action: sendSpinInvite) {
                HStack(spacing: 8) {
                    Image(systemName: isInviteSent ? "checkmark.circle.fill" : "paperplane.fill")
                        .font(.system(size: 16))

                    Text(isInviteSent ? "Gönderildi" : "Çark İsteği")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: isInviteSent ? [Color.green, Color.green.opacity(0.8)] : [Color.pink, Color.orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .disabled(isInviteSent)
            .scaleEffect(isInviteSent ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isInviteSent)
        }
        .padding(20)
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func sendSpinInvite() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isInviteSent = true
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isInviteSent = false
            }
        }
    }
}

#Preview {
    FriendsView(userService: UserService())
}