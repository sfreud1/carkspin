import SwiftUI

struct SpinWheelView: View {
    @State private var rotationAngle: Double = 0
    @State private var isSpinning: Bool = false
    @State private var result: String = ""
    @State private var showResult: Bool = false
    @State private var showFriends: Bool = false
    @State private var pulseScale: CGFloat = 1.0
    
    let options = ["EVET", "HAYIR"]
    let colors: [Color] = [
        Color(red: 0.2, green: 0.8, blue: 0.4), // Yeşil
        Color(red: 0.9, green: 0.3, blue: 0.3)  // Kırmızı
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium gradient arka plan
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.indigo.opacity(0.8),
                        Color.teal.opacity(0.8),
                        Color.black
                    ]),
                    center: .center,
                    startRadius: 100,
                    endRadius: 600
                )
                .ignoresSafeArea()
                
                // Arka plan parçacıkları
                ForEach(0..<20, id: \.self) { _ in
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: Double.random(in: 2...6))
                        .position(
                            x: Double.random(in: 0...geometry.size.width),
                            y: Double.random(in: 0...geometry.size.height)
                        )
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: Double.random(in: 2...4)).repeatForever(autoreverses: true), value: pulseScale)
                }
                
                VStack(spacing: 0) {
                    // Üst bar
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("ÇarkSpin")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, Color.pink.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("Şansını dene!")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Button(action: { showFriends = true }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 45, height: 45)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 15)
                    
                    Spacer()
                    
                    // Ana çark alanı
                    ZStack {
                        // Çark altı glow efekti
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.pink.opacity(0.3), Color.orange.opacity(0.2), .clear],
                                    center: .center,
                                    startRadius: 50,
                                    endRadius: 200
                                )
                            )
                            .frame(width: 350, height: 350)
                            .scaleEffect(isSpinning ? 1.2 : 1.0)
                            .opacity(isSpinning ? 0.8 : 0.4)
                            .animation(.easeInOut(duration: 0.5), value: isSpinning)
                        
                        // Ana çark grubu
                        ZStack {
                            // Çark dış çemberi
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.8), Color.pink.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 8
                                )
                                .frame(width: 310, height: 310)
                                .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 0)
                            
                            // Çark segmentleri
                            ForEach(0..<options.count, id: \.self) { index in
                                ProfessionalWheelSegment(
                                    text: options[index],
                                    color: colors[index],
                                    startAngle: Double(index) * 180,
                                    endAngle: Double(index + 1) * 180,
                                    isSpinning: isSpinning
                                )
                            }
                            
                            // Merkez hub
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [.white, .gray.opacity(0.3)],
                                            center: .center,
                                            startRadius: 5,
                                            endRadius: 30
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                
                                Circle()
                                    .stroke(.white.opacity(0.5), lineWidth: 2)
                                    .frame(width: 45, height: 45)
                                
                                Text("SPIN")
                                    .font(.system(size: 12, weight: .black, design: .rounded))
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                            
                            // Profesyonel pointer
                            VStack {
                                ZStack {
                                    // Pointer gölgesi
                                    Pointer()
                                        .fill(.black.opacity(0.3))
                                        .frame(width: 30, height: 35)
                                        .offset(x: 2, y: 2)
                                    
                                    // Ana pointer
                                    Pointer()
                                        .fill(
                                            LinearGradient(
                                                colors: [.white, .gray.opacity(0.8)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: 30, height: 35)
                                        .overlay(
                                            Pointer()
                                                .stroke(.gray.opacity(0.4), lineWidth: 1)
                                                .frame(width: 30, height: 35)
                                        )
                                }
                                .offset(y: -155)
                            }
                        }
                        .frame(width: 300, height: 300)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.timingCurve(0.25, 0.46, 0.45, 0.94, duration: isSpinning ? 4.0 : 0), value: rotationAngle)
                    }
                    
                    Spacer()
                    
                    // Alt butonlar
                    VStack(spacing: 16) {
                        Button(action: spinWheel) {
                            ZStack {
                                // Buton glow efekti
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(
                                            colors: isSpinning ?
                                                [.gray.opacity(0.4), .gray.opacity(0.6)] :
                                                [Color.pink.opacity(0.8), Color.orange.opacity(0.9)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(height: 65)
                                    .blur(radius: isSpinning ? 0 : 2)
                                    .scaleEffect(1.05)
                                
                                // Ana buton
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(
                                            colors: isSpinning ?
                                                [.gray.opacity(0.6), .gray.opacity(0.8)] :
                                                [Color.pink, Color.orange],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(height: 65)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(.white.opacity(0.3), lineWidth: 1)
                                    )
                                
                                HStack(spacing: 12) {
                                    if isSpinning {
                                        ProgressView()
                                            .scaleEffect(0.9)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(isSpinning ? "ÇARK DÖNÜYOR..." : "ÇARKI ÇEVİR!")
                                        .font(.system(size: 18, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .disabled(isSpinning)
                        .scaleEffect(isSpinning ? 0.98 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSpinning)
                        
                        Button(action: { showFriends = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Arkadaşlarla Oyna")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            pulseScale = 1.1
        }
        .sheet(isPresented: $showResult) {
            ResultView(result: result, onDismiss: {
                showResult = false
                result = ""
            })
        }
        .sheet(isPresented: $showFriends) {
            FriendsView(userService: UserService())
        }
    }
    
    private func spinWheel() {
        guard !isSpinning else { return }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        isSpinning = true
        
        // Daha dramatik spin - minimum 5 tur, maksimum 10 tur
        let randomRotation = Double.random(in: 1800...3600) // 5-10 tur
        rotationAngle += randomRotation
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            isSpinning = false
            
            // Son konumu hesapla
            let normalizedAngle = rotationAngle.truncatingRemainder(dividingBy: 360)
            let adjustedAngle = (360 - normalizedAngle).truncatingRemainder(dividingBy: 360)
            
            // Pointer üstte olduğu için 0-180 arası EVET, 180-360 arası HAYIR
            if adjustedAngle >= 0 && adjustedAngle < 180 {
                result = options[0] // EVET
            } else {
                result = options[1] // HAYIR
            }
            
            // Sonuç haptic feedback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let successFeedback = UINotificationFeedbackGenerator()
                successFeedback.notificationOccurred(.success)
                showResult = true
            }
        }
    }
}

struct ProfessionalWheelSegment: View {
    let text: String
    let color: Color
    let startAngle: Double
    let endAngle: Double
    let isSpinning: Bool
    
    var body: some View {
        ZStack {
            // Ana segment
            Circle()
                .trim(from: startAngle / 360, to: endAngle / 360)
                .fill(
                    RadialGradient(
                        colors: [color.opacity(0.9), color, color.opacity(0.7)],
                        center: .center,
                        startRadius: 50,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .overlay(
                    Circle()
                        .trim(from: startAngle / 360, to: endAngle / 360)
                        .stroke(.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 300, height: 300)
                )
            
            // Segment iç gölgesi
            Circle()
                .trim(from: startAngle / 360, to: endAngle / 360)
                .fill(
                    LinearGradient(
                        colors: [.black.opacity(0.1), .clear, .white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 295, height: 295)
            
            // Text
            Text(text)
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                .rotationEffect(.degrees(startAngle + 90))
                .offset(y: -105)
                .scaleEffect(isSpinning ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isSpinning)
        }
        .rotationEffect(.degrees(startAngle))
    }
}

struct Pointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Üçgen şekli (daha profesyonel)
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + 5, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - 5, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct ResultView: View {
    let result: String
    let onDismiss: () -> Void
    @State private var showContent = false
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Premium arka plan
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.8),
                    Color.black.opacity(0.95)
                ]),
                center: .center,
                startRadius: 100,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            if showContent {
                VStack(spacing: 40) {
                    // Confetti efekti
                    HStack(spacing: 15) {
                        ForEach(0..<5, id: \.self) { _ in
                            Text("✨")
                                .font(.title)
                                .scaleEffect(pulseScale)
                                .animation(.easeInOut(duration: Double.random(in: 1...2)).repeatForever(autoreverses: true), value: pulseScale)
                        }
                    }
                    
                    VStack(spacing: 20) {
                        Text("Sonuç Açıklandı!")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        
                        // Sonuç kartı
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    RadialGradient(
                                        colors: result == "EVET" ? 
                                            [Color.green.opacity(0.8), Color.green] :
                                            [Color.red.opacity(0.8), Color.red],
                                        center: .center,
                                        startRadius: 50,
                                        endRadius: 150
                                    )
                                )
                                .frame(width: 250, height: 120)
                                .shadow(color: result == "EVET" ? .green.opacity(0.5) : .red.opacity(0.5), radius: 20, x: 0, y: 10)
                            
                            Text(result)
                                .font(.system(size: 48, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .white.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 2, y: 2)
                        }
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseScale)
                    }
                    
                    Button(action: onDismiss) {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                            Text("Tamam")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(width: 150, height: 55)
                        .background(
                            LinearGradient(
                                colors: [Color.pink, Color.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 27))
                        .overlay(
                            RoundedRectangle(cornerRadius: 27)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.pink.opacity(0.3), radius: 15, x: 0, y: 8)
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
            pulseScale = 1.1
        }
    }
}

#Preview {
    SpinWheelView()
}