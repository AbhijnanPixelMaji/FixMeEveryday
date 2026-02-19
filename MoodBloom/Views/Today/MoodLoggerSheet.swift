import SwiftUI

struct MoodLoggerSheet: View {
    @Binding var selectedMood: MoodLevel
    @Binding var moodNote: String
    let onComplete: (MoodLevel, String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                headerView
                moodSlider
                noteSection
                Spacer()
                completeButton
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [selectedMood.color.opacity(0.05), selectedMood.color.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("How are you feeling?")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Mood Logged! 🎉", isPresented: $showSuccess) {
            Button("Great!") {
                dismiss()
            }
        } message: {
            Text("You earned 10 XP for logging your mood today!")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text(selectedMood.emoji)
                .font(.system(size: 80))
                .scaleEffect(showSuccess ? 1.2 : 1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0), value: selectedMood)
                .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0), value: showSuccess)
            
            Text(selectedMood.label)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(selectedMood.color)
        }
    }
    
    private var moodSlider: some View {
        VStack(spacing: 20) {
            Text("Drag to select your mood")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 16) {
                HStack {
                    ForEach(MoodLevel.allCases, id: \.rawValue) { mood in
                        VStack(spacing: 8) {
                            Text(mood.emoji)
                                .font(.title)
                                .opacity(selectedMood == mood ? 1.0 : 0.3)
                                .scaleEffect(selectedMood == mood ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0), value: selectedMood)
                            
                            Text(mood.label)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(selectedMood == mood ? mood.color : .secondary)
                                .opacity(selectedMood == mood ? 1.0 : 0.6)
                        }
                        
                        if mood != MoodLevel.allCases.last {
                            Spacer()
                        }
                    }
                }
                
                Slider(
                    value: Binding(
                        get: { Double(selectedMood.rawValue) },
                        set: { selectedMood = MoodLevel(rawValue: Int($0.rounded())) ?? .neutral }
                    ),
                    in: 1...5,
                    step: 1
                )
                .accentColor(selectedMood.color)
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .shadow(color: selectedMood.color.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add a note (optional)")
                .font(.headline)
                .fontWeight(.medium)
            
            TextField("What's on your mind?", text: $moodNote, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
        }
    }
    
    private var completeButton: some View {
        Button(action: {
            onComplete(selectedMood, moodNote)
            showSuccess = true
            
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // Auto dismiss after showing success
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                
                Text("Log Mood & Earn 10 XP")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [selectedMood.color, selectedMood.color.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: selectedMood.color.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .scaleEffect(showSuccess ? 1.1 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0), value: showSuccess)
    }
}

#Preview {
    MoodLoggerSheet(
        selectedMood: .constant(.happy),
        moodNote: .constant(""),
        onComplete: { _, _ in }
    )
}