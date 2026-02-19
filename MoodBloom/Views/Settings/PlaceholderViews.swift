import SwiftUI

// MARK: - Placeholder Views for Settings Navigation Links

struct DataExportView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Export Your Data")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Download your mood entries and journal as a PDF file.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Export as PDF") {
                // Export functionality would be implemented here
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Export Data")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FeedbackView: View {
    @State private var feedbackText = ""
    @State private var feedbackType: FeedbackType = .general
    
    enum FeedbackType: String, CaseIterable {
        case general = "General"
        case bug = "Bug Report"
        case feature = "Feature Request"
        case improvement = "Improvement"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("Feedback Type", selection: $feedbackType) {
                ForEach(FeedbackType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Feedback")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                TextEditor(text: $feedbackText)
                    .font(.body)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .frame(minHeight: 200)
            }
            
            Button("Send Feedback") {
                // Send feedback functionality would be implemented here
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(feedbackText.isEmpty ? Color.gray : Color.green)
            .cornerRadius(12)
            .disabled(feedbackText.isEmpty)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Feedback")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Last updated: \(Date(), formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                privacySection(title: "Information We Collect", content: "MoodBloom collects mood data, journal entries, and usage statistics to provide personalized insights and improve your experience. All data is stored securely on your device and our encrypted servers.")
                
                privacySection(title: "How We Use Your Data", content: "Your data is used to generate personalized insights, track your progress, and improve the app experience. We never share your personal data with third parties without your explicit consent.")
                
                privacySection(title: "Data Security", content: "We implement industry-standard security measures to protect your data. All data is encrypted in transit and at rest.")
                
                privacySection(title: "Your Rights", content: "You have the right to access, modify, or delete your data at any time through the app settings. You can also contact us to request data portability.")
                
                privacySection(title: "Contact Us", content: "If you have any questions about this Privacy Policy, please contact us at privacy@moodbloom.app")
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func privacySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Service")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Last updated: \(Date(), formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                termsSection(title: "Acceptance of Terms", content: "By using MoodBloom, you agree to these Terms of Service. If you don't agree to these terms, please don't use our service.")
                
                termsSection(title: "Use of Service", content: "MoodBloom is intended for personal wellness and self-reflection. It is not a substitute for professional mental health treatment.")
                
                termsSection(title: "Subscription Terms", content: "Premium subscriptions are billed monthly or yearly. You can cancel at any time through your App Store account settings.")
                
                termsSection(title: "Limitation of Liability", content: "MoodBloom is provided 'as is' without warranty. We are not liable for any damages resulting from your use of the service.")
                
                termsSection(title: "Contact Us", content: "If you have any questions about these Terms of Service, please contact us at legal@moodbloom.app")
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func termsSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()