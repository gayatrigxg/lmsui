import SwiftUI
import Combine

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let reply = ChatMessage(text: "Thanks! I've received your message. Is there anything else I can help with?", isCurrentUser: false, time: "Just now")
            self.messages.append(reply)
        }
    }
}

// MARK: - Main View
struct ChatConversationView: View {
    let agentName: String
    @StateObject var viewModel = ChatViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        MessagesExpandedHeader(agentName: agentName, scrollOffset: $scrollOffset)
                            .padding(.top, safeAreaTop + 44)

                        LazyVStack(spacing: 2) {
                            ForEach(viewModel.messages) { msg in
                                ChatBubble(message: msg)
                                    .id(msg.id)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: ScrollOffsetKey.self,
                                value: geo.frame(in: .global).minY
                            )
                        }
                    )
                }
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollOffset = value - (safeAreaTop + 44)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let last = viewModel.messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            MessagesCollapsedBar(
                agentName: agentName,
                presentationMode: presentationMode,
                scrollOffset: $scrollOffset
            )
            .ignoresSafeArea(edges: .top)

            VStack {
                Spacer()
                InputBarView(viewModel: viewModel)
            }
        }
        .navigationBarHidden(true)
    }

    var safeAreaTop: CGFloat {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top) ?? 44
    }
}

// MARK: - Collapsed Bar
struct MessagesCollapsedBar: View {
    let agentName: String
    var presentationMode: Binding<PresentationMode>
    @Binding var scrollOffset: CGFloat
    private let expandedHeaderHeight: CGFloat = 160

    private var collapseProgress: CGFloat {
        let threshold: CGFloat = -expandedHeaderHeight
        return max(0, min(1, scrollOffset / threshold))
    }

    var safeAreaTop: CGFloat {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top) ?? 44
    }

    var body: some View {
        let barHeight = safeAreaTop + 44

        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(Double(collapseProgress))

            VStack(spacing: 0) {
                Spacer()
                Divider().opacity(Double(collapseProgress))
            }

            HStack(spacing: 0) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 17))
                    }
                    .foregroundColor(.mainBlue)
                }
                .frame(minWidth: 80, alignment: .leading)

                Spacer()

                if collapseProgress > 0.5 {
                    VStack(spacing: 2) {
                        Circle()
                            .fill(Color.lightBlue)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text(String(agentName.prefix(1)))
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.mainBlue)
                            )
                        Text(agentName)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .opacity(Double((collapseProgress - 0.5) * 2))
                }

                Spacer()

                HStack(spacing: 20) {
                    Button {} label: {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 17))
                            .foregroundColor(.mainBlue)
                    }
                    Button {} label: {
                        Image(systemName: "video.fill")
                            .font(.system(size: 17))
                            .foregroundColor(.mainBlue)
                    }
                }
                .frame(minWidth: 80, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .frame(height: barHeight)
    }
}

// MARK: - Expanded Header
struct MessagesExpandedHeader: View {
    let agentName: String
    @Binding var scrollOffset: CGFloat

    private var opacity: Double {
        let fadeStart: CGFloat = -60
        let fadeEnd: CGFloat = -140
        guard scrollOffset < fadeStart else { return 1 }
        return max(0, Double(1 - (scrollOffset - fadeStart) / (fadeEnd - fadeStart)))
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Color.lightBlue)
                    .frame(width: 62, height: 62)
                Text(String(agentName.prefix(1)))
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.mainBlue)
            }
            Text(agentName)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
            Text("Support Agent")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .opacity(opacity)
    }
}

// MARK: - Message Bubble
struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 6) {
                if message.isCurrentUser {
                    Spacer(minLength: 60)
                } else {
                    Circle()
                        .fill(Color.lightBlue)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Text("R")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.mainBlue)
                        )
                }

                Text(message.text)
                    .font(.system(size: 16))
                    .foregroundColor(message.isCurrentUser ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(message.isCurrentUser ? Color.mainBlue : Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(BubbleShape(isCurrentUser: message.isCurrentUser))

                if !message.isCurrentUser {
                    Spacer(minLength: 60)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 2)

            HStack {
                if message.isCurrentUser { Spacer() }
                Text(message.time)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, message.isCurrentUser ? 18 : 50)
                if !message.isCurrentUser { Spacer() }
            }
            .padding(.bottom, 6)
        }
    }
}

// iMessage-style tail shape
struct BubbleShape: Shape {
    let isCurrentUser: Bool
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 18
        let tail: CGFloat = 6
        var path = Path()
        if isCurrentUser {
            path.addRoundedRect(in: CGRect(x: rect.minX, y: rect.minY, width: rect.width - tail, height: rect.height), cornerSize: CGSize(width: radius, height: radius))
            let tx = rect.maxX - tail
            path.move(to: CGPoint(x: tx, y: rect.maxY - 10))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: tx, y: rect.maxY - 4))
        } else {
            path.addRoundedRect(in: CGRect(x: tail, y: rect.minY, width: rect.width - tail, height: rect.height), cornerSize: CGSize(width: radius, height: radius))
            path.move(to: CGPoint(x: tail, y: rect.maxY - 10))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: tail, y: rect.maxY - 4))
        }
        return path
    }
}

// MARK: - Input Bar
struct InputBarView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 10) {
                Button {} label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.mainBlue)
                }

                HStack {
                    TextField("iMessage", text: $viewModel.inputText)
                        .font(.system(size: 16))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)

                    if !viewModel.inputText.isEmpty {
                        Button { viewModel.sendMessage() } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.mainBlue)
                        }
                        .padding(.trailing, 4)
                    }
                }
                .background(Color(UIColor.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(UIColor.separator), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemBackground))
        }
    }
}

// MARK: - Preference Key
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
