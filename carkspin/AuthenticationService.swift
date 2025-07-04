import Foundation
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

class AuthenticationService: ObservableObject {
    @Published var user: User?
    @Published var isSignedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var db = Firestore.firestore()
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        authStateListener = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
            self.isSignedIn = user != nil
        }
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let presentingViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.errorMessage = "Google Sign-In failed"
                self.isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }
                
                self.isLoading = false
                self.checkAndCreateUser()
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func checkAndCreateUser() {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection("users").document(user.uid).getDocument { document, error in
            if let error = error {
                print("Error checking user: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                print("User already exists")
            } else {
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "email": user.email ?? "",
                    "displayName": user.displayName ?? "",
                    "photoURL": user.photoURL?.absoluteString ?? "",
                    "createdAt": Timestamp(date: Date())
                ]
                
                self.db.collection("users").document(user.uid).setData(userData) { error in
                    if let error = error {
                        print("Error creating user: \(error.localizedDescription)")
                    } else {
                        print("User created successfully")
                    }
                }
            }
        }
    }
}