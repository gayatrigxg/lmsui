import SwiftUI
import Combine // <-- This fixes all 5 errors instantly!

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isCurrentUser: Bool
    let time: String
}

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(text: "Hi there! I noticed my PAN card was rejected during the upload. What went wrong?", isCurrentUser: true, time: "10:30 AM"),
        ChatMessage(text: "Hello! Let me check that for you.", isCurrentUser: false, time: "10:32 AM"),
        ChatMessage(text: "It looks like the image was a bit blurry and the system couldn't read the ID number. Could you please re-upload a clearer picture?", isCurrentUser: false, time: "10:33 AM"),
        ChatMessage(text: "Sure, let me do that right now.", isCurrentUser: true, time: "10:35 AM"),
        ChatMessage(text: "Yes, the new PAN card upload is confirmed. We will proceed with the verification.", isCurrentUser: false, time: "10:42 AM")
    ]
    @Published var inputText: String = ""
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newMsg = ChatMessage(text: inputText, isCurrentUser: true, time: "Just now")
        messages.append(newMsg)
        inputText = ""
        
        // Simulate an agent reply
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let reply = ChatMessage(text: "Thanks! I've received your message. Is there anything else I can help with?", isCurrentUser: false, time: "Just now")
            self.messages.append(reply)
        }
    }
}

struct ChatConversationView: View {
    let agentName: String
    @StateObject var viewModel = ChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Custom Chat Header
            VStack {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.lightBlue)
                        .frame(width: 40, height: 40)
                        .overlay(Text(String(agentName.prefix(1))).font(.headline).foregroundColor(.mainBlue))
                    
                    VStack(alignment: .leading) {
                        Text(agentName)
                            .font(.headline)
                        Text("Online")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#00C48C"))
                    }
                    Spacer()
                }
                .padding()
                Divider()
            }
            .background(Color(UIColor.systemBackground))
            
            // Message List
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.messages) { msg in
                            ChatBubble(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding(20)
                    .onChange(of: viewModel.messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            
            // Input Area
            VStack {
                Divider()
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "paperclip")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    
                    TextField("Type a message...", text: $viewModel.inputText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Capsule())
                    
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .foregroundColor(viewModel.inputText.isEmpty ? .secondary : .mainBlue)
                    }
                    .disabled(viewModel.inputText.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color(UIColor.systemBackground))
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isCurrentUser { Spacer(minLength: 40) }
            
            VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.subheadline)
                    .padding(14)
                    .foregroundColor(message.isCurrentUser ? .white : .primary)
                    .background(message.isCurrentUser ? Color.mainBlue : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    // Sharp corner on the sender side
                    .cornerRadius(4, corners: message.isCurrentUser ? [.bottomRight] : [.bottomLeft])
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                
                Text(message.time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if !message.isCurrentUser { Spacer(minLength: 40) }
        }
    }
}

// Helper extension to make specific corners sharp for chat bubbles
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
