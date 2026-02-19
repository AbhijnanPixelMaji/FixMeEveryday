import SwiftUI

struct ProfileEditorView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedAvatar: String = "person.circle.fill"
    @State private var selectedColor: Color = .blue
    
    private let avatarOptions = [
        "person.circle.fill",
        "person.crop.circle.fill",
        "figure.walk.circle.fill",
        "heart.circle.fill",
        "sun.max.circle.fill",
        "leaf.circle.fill",
        "star.circle.fill",
        "moon.circle.fill"
    ]
    
    private let colorOptions: [Color] = [
        .blue, .purple, .pink, .red, .orange, .yellow, .green, .mint
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                avatarPreview
                nameSection
                avatarSelection
                colorSelection
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [selectedColor.opacity(0.1), selectedColor.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            loadCurrentProfile()
        }
    }
    
    private var avatarPreview: some View {
        VStack(spacing: 16) {
            Image(systemName: selectedAvatar)
                .font(.system(size: 60))
                .foregroundColor(selectedColor)
                .frame(width: 100, height: 100)
                .background(
                    Circle()
                        .fill(selectedColor.opacity(0.1))
                )
                .overlay(
                    Circle()
                        .stroke(selectedColor.opacity(0.3), lineWidth: 2)
                )
            
            Text(name.isEmpty ? "Your Name" : name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextField("Enter your name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
        }
    }
    
    private var avatarSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Avatar")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(avatarOptions, id: \.self) { avatar in
                    Button(action: {
                        selectedAvatar = avatar
                    }) {
                        Image(systemName: avatar)
                            .font(.system(size: 30))
                            .foregroundColor(selectedAvatar == avatar ? selectedColor : .gray)
                            .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                    .fill(selectedAvatar == avatar ? selectedColor.opacity(0.1) : Color.gray.opacity(0.1))
                            )
                            .overlay(
                                Circle()
                                    .stroke(selectedAvatar == avatar ? selectedColor : Color.clear, lineWidth: 2)
                            )
                    }
                }
            }
        }
    }
    
    private var colorSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Color")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                ForEach(colorOptions, id: \.self) { color in
                    Button(action: {
                        selectedColor = color
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                            )
                            .scaleEffect(selectedColor == color ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedColor)
                    }
                }
            }
        }
    }
    
    private func loadCurrentProfile() {
        name = appState.userProfile.name
        selectedAvatar = appState.userProfile.avatar
        selectedColor = appState.userProfile.favoriteColor
    }
    
    private func saveProfile() {
        appState.userProfile.name = name
        appState.userProfile.avatar = selectedAvatar
        appState.userProfile.favoriteColor = selectedColor
        dismiss()
    }
}

#Preview {
    ProfileEditorView()
        .environmentObject(AppState())
}