import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var isUsernameSet: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var db = Firestore.firestore()
    
    init() {
        if let user = Auth.auth().currentUser {
            loadUserData(uid: user.uid)
        }
    }
    
    func loadUserData(uid: String) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            if let document = document, document.exists {
                do {
                    let userData = try document.data(as: UserModel.self)
                    self.currentUser = userData
                    self.isUsernameSet = userData.username != nil
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func setUsername(_ username: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        isLoading = true
        errorMessage = nil
        
        let lowercaseUsername = username.lowercased()
        
        checkUsernameAvailability(lowercaseUsername) { isAvailable in
            if isAvailable {
                self.db.collection("users").document(user.uid).updateData([
                    "username": lowercaseUsername
                ]) { error in
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    } else {
                        self.isUsernameSet = true
                        self.loadUserData(uid: user.uid)
                    }
                }
            } else {
                self.isLoading = false
                self.errorMessage = "Bu kullanıcı adı zaten kullanımda."
            }
        }
    }
    
    private func checkUsernameAvailability(_ username: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking username: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(snapshot?.documents.isEmpty ?? false)
        }
    }
    
    func searchUsers(query: String, completion: @escaping ([UserModel]) -> Void) {
        guard !query.isEmpty else {
            completion([])
            return
        }
        
        print("Searching for users with username containing: \(query)")
        
        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: query.lowercased())
            .whereField("username", isLessThan: query.lowercased() + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error searching users: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                let results = snapshot?.documents.compactMap { document -> UserModel? in
                    do {
                        let user = try document.data(as: UserModel.self)
                        print("Found user: \(user.username ?? "no username")")
                        return user
                    } catch {
                        print("Error decoding user: \(error)")
                        return nil
                    }
                } ?? []
                
                print("Search completed, found \(results.count) users")
                completion(results)
            }
    }
}

struct UserModel: Codable, Identifiable, Equatable {
    var id: String { uid }
    let uid: String
    let email: String
    let displayName: String
    let photoURL: String
    var username: String?
    let createdAt: Timestamp
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.uid == rhs.uid
    }
}