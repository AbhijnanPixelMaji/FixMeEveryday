import SwiftUI

struct NewJournalEntryView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var content = ""
    @State private var tags: [String] = []
    @State private var tagInput = ""
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    promptSection
                    contentEditor
                    if subscriptionManager.isPremium {
                        tagsSection
                    }
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .fontWeight(.semibold)
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("Entry Saved! 🎉", isPresented: $showSuccess) {
            Button("Great!") {
                dismiss()
            }
        } message: {
            Text("You earned 5 XP for journaling today!")
        }
    }
    
    private var promptSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reflection Prompts")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                PromptButton(title: "How am I feeling right now?") {
                    appendToContent("How am I feeling right now?\n\n")
                }
                
                PromptButton(title: "What am I grateful for today?") {
                    appendToContent("What am I grateful for today?\n\n")
                }
                
                PromptButton(title: "What challenged me today?") {
                    appendToContent("What challenged me today?\n\n")
                }
                
                PromptButton(title: "What did I learn about myself?") {
                    appendToContent("What did I learn about myself?\n\n")
                }
            }
        }
    }
    
    private var contentEditor: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Thoughts")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextEditor(text: $content)
                .font(.body)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
                .frame(minHeight: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    @ViewBuilder
    private var tagsSection: some View {
        if subscriptionManager.isPremium {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Tags")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("Premium")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(4)
                }
                
                HStack {
                    TextField("Add a tag...", text: $tagInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            addTag()
                        }
                    
                    Button("Add", action: addTag)
                        .disabled(tagInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                if !tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(tags, id: \.self) { tag in
                                TagView(tag: tag) {
                                    removeTag(tag)
                                }
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                }
            }
        }
    }
    
    private func appendToContent(_ text: String) {
        if content.isEmpty {
            content = text
        } else {
            content += "\n\n" + text
        }
    }
    
    private func addTag() {
        let newTag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if !newTag.isEmpty && !tags.contains(newTag) {
            tags.append(newTag)
            tagInput = ""
        }
    }
    
    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    private func saveEntry() {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }
        
        appState.addJournalEntry(trimmedContent, tags: tags)
        showSuccess = true
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Auto dismiss after showing success
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

struct PromptButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus.circle")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.05))
            .cornerRadius(8)
        }
    }
}

struct TagView: View {
    let tag: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(tag)
                .font(.caption)
                .fontWeight(.medium)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.1))
        .foregroundColor(.blue)
        .cornerRadius(8)
    }
}

#Preview {
    NewJournalEntryView()
        .environmentObject(AppState())
        .environmentObject(SubscriptionManager())
}